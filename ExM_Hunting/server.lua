RegisterServerEvent('ExM_Hunting:addItem')
AddEventHandler('ExM_Hunting:addItem', function(itemName, amount, friendlyName)
    local plySource = source
    local iName = itemName
    local fName = friendlyName
    local iAmount = ExM.Math.Round(amount)
    local xPlayer = ExM.GetPlayerFromId(plySource)
	local sourceItem = xPlayer.getInventoryItem(iName)

	if Config.QuestionableSell[iName] or Config.MeatSell[iName] or Config.PeltSell[iName] then
		if not xPlayer.canCarryItem(iName, iAmount) then
			local difference = sourceItem.limit - sourceItem.count
			if difference == 0 then
				TriggerClientEvent('esx:showNotification', plySource, string.format(Config.Text.MaxLimit, fName))
			else
				xPlayer.addInventoryItem(iName, difference)
			end
		else
			xPlayer.addInventoryItem(iName, iAmount)
		end
	else
		-- The user is probably cheating by trying to give themselves some random item unrelated to hunting, you could put some anti-cheat captures here.
		-- Uncomment the below line if you'd like to be notified of this in your server console, you could also trigger a ban here if you wanted to.
		
		-- print("ExM_Hunting: ^3" .. GetPlayerName(plySource) .. "^r has attempted to give themselves an item not related to hunting ^4(" .. iName .. ")^r")
	end
end)

ExM.RegisterServerCallback('ExM_Hunting:getPelt', function(source, cb)
	local plySource = source
    local xPlayer = ExM.GetPlayerFromId(plySource)
    local allPelt = {}

	if xPlayer then
		for pelt, price in pairs(Config.PeltSell) do
			GetInventItem(xPlayer, pelt, function(sourceItem)
				if sourceItem ~= nil then
					if sourceItem.count > 0 then
						allPelt[#allPelt + 1] = {
							name = pelt,
							price = price,
							label = sourceItem.label,
							count = sourceItem.count
						}
					end
				end
			end)
		end
		cb(allPelt)
	else
		cb()
	end
end)

ExM.RegisterServerCallback('ExM_Hunting:getMeat', function(source, cb)
	local plySource = source
    local xPlayer = ExM.GetPlayerFromId(plySource)
    local allMeat = {}

	if xPlayer then
		for meat, price in pairs(Config.MeatSell) do
			GetInventItem(xPlayer, meat, function(sourceItem)
				if sourceItem ~= nil then
					if sourceItem.count > 0 then
						allMeat[#allMeat + 1] = {
							name = meat,
							price = price,
							label = sourceItem.label, 
							count = sourceItem.count
						}
					end
				end
			end)
		end
		cb(allMeat)
	else
		cb()
	end
end)

ExM.RegisterServerCallback('ExM_Hunting:getQuestionable', function(source, cb)
	local plySource = source
    local xPlayer = ExM.GetPlayerFromId(plySource)
    local questionableItems = {}

	if xPlayer then
		for item, price in pairs(Config.QuestionableSell) do
			GetInventItem(xPlayer, item, function(sourceItem)
				if sourceItem ~= nil then
					if sourceItem.count > 0 then
						questionableItems[#questionableItems + 1] = {
							name = item, 
							price = price, 
							label = sourceItem.label, 
							count = sourceItem.count
						}
					end
				end
			end)
		end
		cb(questionableItems)
	else
		cb()
	end
end)

RegisterServerEvent('ExM_Hunting:sellItem')
AddEventHandler('ExM_Hunting:sellItem', function(itemName)
    local plySource = source
    local xPlayer = ExM.GetPlayerFromId(plySource)

	GetInventItem(xPlayer, itemName, function(sourceItem)
		if sourceItem ~= nil then
			if Config.MeatSell[sourceItem.name] then
				SellItem(plySource, xPlayer, sourceItem, Config.MeatSell[sourceItem.name])
			elseif Config.PeltSell[sourceItem.name] then
				SellItem(plySource, xPlayer, sourceItem, Config.PeltSell[sourceItem.name])
			elseif Config.QuestionableSell[sourceItem.name] then
				SellItem(plySource, xPlayer, sourceItem, Config.QuestionableSell[sourceItem.name])
			end
		end
	end)
end)

RegisterServerEvent('ExM_Hunting:deleteEntity')
AddEventHandler('ExM_Hunting:deleteEntity', function(netID)
	local entID = NetworkGetEntityFromNetworkId(netID)
    TriggerClientEvent('ExM_Hunting:deleteEntOnClient', NetworkGetEntityOwner(entID), netID)
end)

function SellItem(plySource, xPlayer, sourceItem, price)
	local money = ExM.Math.Round(price * sourceItem.count)
	xPlayer.addAccountMoney('money', money)
	xPlayer.removeInventoryItem(sourceItem.name, sourceItem.count)
	TriggerClientEvent('esx:showNotification', plySource, string.format(Config.Text.SoldItem, sourceItem.count, sourceItem.label, money))
end

function GetInventItem(xPlayer, item, cb)
	local items = xPlayer.getInventoryItem(item)
	if items ~= nil then
		cb(items)
	end
end