local foundAnimals = {}

CreateThread(function()
	interactButton = Config.InteractButton
	
	local meatPoint = Config.MeatSellPoint
	local peltPoint = Config.PeltSellPoint
	local questionPoint = Config.QuestionableSellPoint
	
	meatStoreMarker = ExM.Markers.Add(meatPoint.markerType, meatPoint.coords, meatPoint.markerColours.r, meatPoint.markerColours.g, meatPoint.markerColours.b, meatPoint.markerColours.a, meatPoint.markerRange, false, meatPoint.markerScale)
	peltStoreMarker = ExM.Markers.Add(peltPoint.markerType, peltPoint.coords, peltPoint.markerColours.r, peltPoint.markerColours.g, peltPoint.markerColours.b, peltPoint.markerColours.a, peltPoint.markerRange, false, peltPoint.markerScale)
	questionableStoreMarker = ExM.Markers.Add(questionPoint.markerType, questionPoint.coords, questionPoint.markerColours.r, questionPoint.markerColours.g, questionPoint.markerColours.b, questionPoint.markerColours.a, questionPoint.markerRange, false, questionPoint.markerScale)
end)

CreateThread(function()
    while true do
        Wait(1000)
        GetAllAnimals()
    end
end)

CreateThread(function()
    while true do
        Wait(0)
		if next(foundAnimals) ~= nil then
			local plyPed = PlayerPedId()
			for _, animal in ipairs(foundAnimals) do
				local animalCoords = GetEntityCoords(animal)
				if #(animalCoords - GetEntityCoords(plyPed)) < 1.5 then
					local model = GetEntityModel(animal)
					if Config.Animals[model] and not IsPedInAnyVehicle(plyPed) then
						local enterForm = setupScaleform("instructional_buttons", string.format(Config.Text.Harvest, Config.Animals[model].name), interactButton)
						if HasPedGotWeapon(plyPed, Config.HarvestWeapon, false) then
							if PlayerNearby(animalCoords) then
								enterForm = setupScaleform("instructional_buttons", Config.Text.PlayerTooClose)
							else
								if IsControlJustReleased(2, interactButton) then
									DoHuntingTask(Config.Animals[model], animal)
								end
							end
						else
							enterForm = setupScaleform("instructional_buttons", string.format(Config.Text.NoHarvestWeapon, Config.HarvestWeapon))
						end
						DrawScaleformMovieFullscreen(enterForm, 255, 255, 255, 255, 0)
					end
				end
			end
		end
    end
end)

local inMeatStore = false
local inPeltStore = false
local inQuestionableStore = false
CreateThread(function()
    while true do
        Wait(1000)
		inMeatStore = ExM.Markers.In(meatStoreMarker)
		inPeltStore = ExM.Markers.In(peltStoreMarker)
		inQuestionableStore = ExM.Markers.In(questionableStoreMarker)
    end
end)

CreateThread(function()
	while true do
		Wait(0)
		if inMeatStore then
			local enterForm = setupScaleform("instructional_buttons", Config.Text.MeatStoreOpen, interactButton)
			DrawScaleformMovieFullscreen(enterForm, 255, 255, 255, 255, 0)
			if IsControlJustReleased(2, interactButton) and not IsPedInAnyVehicle(PlayerPedId()) then
				MeatStore()
			end
		end
		if inPeltStore then
			local enterForm = setupScaleform("instructional_buttons", Config.Text.PeltStoreOpen, interactButton)
			DrawScaleformMovieFullscreen(enterForm, 255, 255, 255, 255, 0)
			if IsControlJustReleased(2, interactButton) and not IsPedInAnyVehicle(PlayerPedId()) then
				PeltStore()
			end
		end
		if inQuestionableStore then
			local enterForm = setupScaleform("instructional_buttons", Config.Text.QuestionableStoreOpen, interactButton)
			DrawScaleformMovieFullscreen(enterForm, 255, 255, 255, 255, 0)
			if IsControlJustReleased(2, interactButton) and not IsPedInAnyVehicle(PlayerPedId()) then
				QuestionableStore()
			end
		end
	end
end)

function PlayerNearby(coords)
	for _, player in ipairs(GetActivePlayers()) do
		if player ~= PlayerPedId() then
			if #(GetEntityCoords(player) - coords) <= 3.0 then
				return true
			end
		end
	end
	return false
end

function DoHuntingTask(animalStuff, animalEnt)
	local plyPed = PlayerPedId()
	local animalModel = animalStuff.model
	local animalFName = animalStuff.name
	local isBird = animalStuff.isBird
	local maxMeat = animalStuff.maxMeat
	
    local CauseOfDeath = COD(animalEnt)
    if GetCurrentPedWeapon(plyPed, true) ~= Config.HarvestWeapon then
        SetCurrentPedWeapon(plyPed, Config.HarvestWeapon)
        Wait(1000)
    end
    TaskTurnPedToFaceEntity(plyPed, animalEnt, -1)
    Wait(1000)
    TaskStartScenarioInPlace(plyPed, Config.Scenario, -1, true)
    Wait(10000)
    ClearPedTasks(plyPed)
    NetworkFadeOutEntity(animalEnt, false, true)
    Wait(1000)
    SetEntityCoords(animalEnt, 0.0, 0.0, 0.0, false, false, false, false)
    DeleteEntity(animalEnt)
	if DoesEntityExist(animalEnt) then
		TriggerServerEvent("ExM_Hunting:deleteEntity", NetworkGetNetworkIdFromEntity(animalEnt))
	end
    if CauseOfDeath then
        local randomAmount = math.random(1, maxMeat)
        local peltName = animalModel .. "_pelt_" .. string.lower(CauseOfDeath)
        local meatName = animalModel .. "_meat"
        local mName = animalFName .. " " .. Config.Text.Meat
        local fName = animalFName
        if isBird then
            fName = fName .. " " .. Config.Text.Feathers
        else
            fName = fName .. " " .. Config.Text.Pelt
        end
        if CauseOfDeath ~= "Bad" then
            TriggerServerEvent('ExM_Hunting:addItem', meatName, randomAmount, mName)
        end
        TriggerServerEvent('ExM_Hunting:addItem', peltName, 1, fName)
    else
        if isBird then
            ExM.ShowNotification(Config.Text.TooDamagedBird)
        else
            ExM.ShowNotification(Config.Text.TooDamaged)
        end
    end
end

function COD(animalEnt)
    local CauseOfDeath = GetPedCauseOfDeath(animalEnt)
    if CauseOfDeath == `WEAPON_RUN_OVER_BY_CAR` or CauseOfDeath == `WEAPON_RAMMED_BY_CAR` or HasEntityBeenDamagedByAnyVehicle(animalEnt) then -- Killed by a car
        return false
    elseif GetWeapontypeGroup(CauseOfDeath) ~= nil then -- Killed by a weapon
		local weaponGroup = GetWeapontypeGroup(CauseOfDeath)
		if weaponGroup == `GROUP_UNARMED` or weaponGroup == `GROUP_MELEE` then
			return "Rare"
		elseif weaponGroup == `GROUP_PISTOL` or weaponGroup == `GROUP_SMG` or weaponGroup == `GROUP_SNIPER` then
			return "Good"
		elseif weaponGroup == `GROUP_MG` or weaponGroup == `GROUP_SHOTGUN` or weaponGroup == `GROUP_RIFLE` then
			return "Bad"
		else
			return false
		end
    end
    return false
end

function GetAllAnimals()
    local findHandle, foundPed = FindFirstPed()
    local continueFind = (foundPed and true or false)
    while continueFind do
		if GetPedType(foundPed) == 28 and IsEntityDead(foundPed) then -- Get all dead animals (Type 28)
            foundAnimals[#foundAnimals + 1] = foundPed
        end
        continueFind, foundPed = FindNextPed(findHandle)
    end
    EndFindPed(findHandle)
	
    return foundAnimals
end

local allPelt = {}
function PeltStore()
	ExM.TriggerServerCallback('ExM_Hunting:getPelt', function(peltReturn)
		allPelt = peltReturn
		JayMenu.OpenMenu("peltSell")
	end)
end

local allMeat = {}
function MeatStore()
    ExM.TriggerServerCallback('ExM_Hunting:getMeat', function(meatReturn)
		allMeat = meatReturn
		JayMenu.OpenMenu("meatSell")
	end)
end

local questionableItems = {}
function QuestionableStore()
    ExM.TriggerServerCallback('ExM_Hunting:getQuestionable', function(questionableReturn)
		questionableItems = questionableReturn
		JayMenu.OpenMenu("questionableSell")
	end)
end

CreateThread(function()
	JayMenu.CreateMenu("peltSell", Config.Text.PeltStoreTitle)
    JayMenu.SetSubTitle('peltSell', Config.Text.PeltStoreSubtitle)
	JayMenu.CreateMenu("meatSell", Config.Text.MeatStoreTitle)
    JayMenu.SetSubTitle('meatSell', Config.Text.MeatStoreSubtitle)
	JayMenu.CreateMenu("questionableSell", Config.Text.QuestionableStoreTitle)
    JayMenu.SetSubTitle('questionableSell', Config.Text.QuestionableStoreSubtitle)

    while true do 
        Wait(0)
        if JayMenu.IsMenuOpened('peltSell') then
            if next(allPelt) ~= nil then
                for _, pelt in ipairs(allPelt) do
                    if JayMenu.Button(pelt.label .. " x" .. pelt.count, "~HUD_COLOUR_GREENDARK~$" .. pelt.price * pelt.count) then
                        TriggerServerEvent('ExM_Hunting:sellItem', pelt.name)
                        PeltStore()
                    end
                end
			else
				JayMenu.Button(Config.Text.NothingToSell)
            end
			JayMenu.Display()
        elseif JayMenu.IsMenuOpened('meatSell') then
            if next(allMeat) ~= nil then
                for _, meat in ipairs(allMeat) do
                    if JayMenu.Button(meat.label .. " x" .. meat.count, "~HUD_COLOUR_GREENDARK~$" .. meat.price * meat.count) then
                        TriggerServerEvent('ExM_Hunting:sellItem', meat.name)
                        MeatStore()
                    end
                end
			else
				JayMenu.Button(Config.Text.NothingToSell)
            end
			JayMenu.Display()
        elseif JayMenu.IsMenuOpened('questionableSell') then
            if next(questionableItems) ~= nil then
                for _, item in ipairs(questionableItems) do
                    if JayMenu.Button(item.label .. " x" .. item.count, "~HUD_COLOUR_GREENDARK~$" .. item.price * item.count) then
                        TriggerServerEvent('ExM_Hunting:sellItem', item.name)
                        QuestionableStore()
                    end
                end
			else
				JayMenu.Button(Config.Text.NothingToSell)
            end
			JayMenu.Display()
        end
    end
end)

CreateThread(function()
	AddTextEntry("HuntingMeat", Config.Text.MeatStoreBlip)
    AddTextEntry("HuntingPelt", Config.Text.PeltStoreBlip)
    AddTextEntry("HuntingQuestionable", Config.Text.QuestionableStoreBlip)
    
	if Config.MeatSellPoint.showMapBlip then
		local meatBlip = AddBlipForCoord(Config.MeatSellPoint.coords)
		SetBlipSprite(meatBlip, 141)
		SetBlipScale(meatBlip, 0.8)
		SetBlipAsShortRange(meatBlip,true)
		SetBlipColour(meatBlip, 66)
		BeginTextCommandSetBlipName("HuntingMeat")
		EndTextCommandSetBlipName(meatBlip)
	end
	
	if Config.PeltSellPoint.showMapBlip then
		local peltBlip = AddBlipForCoord(Config.PeltSellPoint.coords)
		SetBlipSprite(peltBlip, 141)
		SetBlipScale(peltBlip, 0.8)
		SetBlipAsShortRange(peltBlip,true)
		SetBlipColour(peltBlip, 66)
		BeginTextCommandSetBlipName("HuntingPelt")
		EndTextCommandSetBlipName(peltBlip)
	end
	
    if Config.QuestionableSellPoint.showMapBlip then
		local questionableBlip = AddBlipForCoord(Config.QuestionableSellPoint.coords)
		SetBlipSprite(questionableBlip, 141)
		SetBlipScale(questionableBlip, 0.8)
		SetBlipAsShortRange(questionableBlip,true)
		SetBlipColour(questionableBlip, 66)
		BeginTextCommandSetBlipName("HuntingQuestionable")
		EndTextCommandSetBlipName(questionableBlip)
	end
end)

function ButtonMessage(text)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentScaleform(text)
    EndTextCommandScaleformString()
end

function Button(ControlButton)
    PushScaleformMovieMethodParameterButtonName(ControlButton)
end

function setupScaleform(scaleform, itemString, button)
    local scaleform = RequestScaleformMovie(scaleform)
    while not HasScaleformMovieLoaded(scaleform) do
        Wait(0)
    end
    PushScaleformMovieFunction(scaleform, "CLEAR_ALL")
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "SET_CLEAR_SPACE")
    PushScaleformMovieFunctionParameterInt(200)
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "SET_DATA_SLOT")
    PushScaleformMovieFunctionParameterInt(0)
	if button ~= nil then
		Button(GetControlInstructionalButton(2, button, true))
	end
    ButtonMessage(itemString)
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    PopScaleformMovieFunctionVoid()
    PushScaleformMovieFunction(scaleform, "SET_BACKGROUND_COLOUR")
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(0)
    PushScaleformMovieFunctionParameterInt(80)
    PopScaleformMovieFunctionVoid()
    return scaleform
end

AddEventHandler('onResourceStop', function(resourceName)
  if GetCurrentResourceName() ~= resourceName then return end
  ExM.Markers.Remove(meatStoreMarker)
  ExM.Markers.Remove(peltStoreMarker)
  ExM.Markers.Remove(questionableStoreMarker)
end)

RegisterNetEvent('ExM_Hunting:deleteEntOnClient')
AddEventHandler('ExM_Hunting:deleteEntOnClient', function(netID)
	local entID = NetworkGetEntityFromNetworkId(netID)
	DeleteEntity(entID)
end)