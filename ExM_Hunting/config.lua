Config = {}

Config.MeatSellPoint = {
	coords = vec(985.21, -2110.54, 29.4),
	markerType = 1,
	markerColours = {r = 255, g = 0, b = 0, a = 100},
	markerScale = vec(1.5, 1.5, 0.6),
	markerRange = 15.0,
	showMapBlip = true
}

Config.PeltSellPoint = {
	coords = vec(1678.36, 4882.32, 41.0),
	markerType = 1,
	markerColours = {r = 255, g = 0, b = 0, a = 100},
	markerScale = vec(1.5, 1.5, 0.6),
	markerRange = 50.0,
	showMapBlip = true
}

Config.QuestionableSellPoint = {
	coords = vec(-643.11, -1227.68, 10.5),
	markerType = 1,
	markerColours = {r = 255, g = 0, b = 0, a = 100},
	markerScale = vec(1.5, 1.5, 0.6),
	markerRange = 25.0,
	showMapBlip = false
}

Config.InteractButton = 38 -- E key to interact with markers and animal
Config.Scenario = "CODE_HUMAN_MEDIC_TEND_TO_DEAD" -- Scenario to play when harvesting the animal
Config.HarvestWeapon = `WEAPON_KNIFE` -- The weapon required to be able to harvest animal parts

Config.Text = {
	["Harvest"] = "Harvest %s",
	["MeatStoreOpen"] = "Open Meat Store",
	["PeltStoreOpen"] = "Open Pelt Store",
	["QuestionableStoreOpen"] = "Open Questionable Store",
	["MeatStoreBlip"] = "Hunting Meat Sales",
	["PeltStoreBlip"] = "Hunting Pelt Sales",
	["QuestionableStoreBlip"] = "Questionable Items Sales",
	["MeatStoreTitle"] = "Sell your Meat",
	["PeltStoreTitle"] = "Sell your Pelts",
	["QuestionableStoreTitle"] = "Sell your Items",
	["MeatStoreSubtitle"] = "Meats",
	["PeltStoreSubtitle"] = "Pelts",
	["QuestionableStoreSubtitle"] = "Items",
	["TooDamaged"] = "You damaged the pelt and meat too badly and received nothing.",
	["TooDamagedBird"] = "You damaged the feathers and meat too badly and received nothing.",
	["Pelt"] = "Pelt",
	["Meat"] = "Meat",
	["Feathers"] = "Feathers",
	["MaxLimit"] = "You cannot carry any more ~y~%s~s~",
	["SoldItem"] = "You have sold ~y~ %s %s(s) ~s~for ~g~$%s~s~",
	["NoHarvestWeapon"] = "You need a Knife to harvest any animals",
	["PlayerTooClose"] = "There is someone else too close to harvest this animal",
	["NothingToSell"] = "You have nothing to sell",
}

Config.Animals = {
    [`a_c_boar`] = {
		model = "a_c_boar",
		name = "Boar",
		isBird = false,
		maxMeat = 3
	},
    [`a_c_chickenhawk`] = {
		model = "a_c_chickenhawk",
		name = "Chicken Hawk",
		isBird = true,
		maxMeat = 2
	},
    [`a_c_cormorant`] = {
		model = "a_c_cormorant",
		name = "Cormorant",
		isBird = true,
		maxMeat = 2
	},
    [`a_c_coyote`] = {
		model = "a_c_coyote",
		name = "Coyote",
		isBird = false,
		maxMeat = 3
	},
    [`a_c_crow`] = {
		model = "a_c_crow",
		name = "Crow",
		isBird = true,
		maxMeat = 2
	},
    [`a_c_deer`] = {
		model = "a_c_deer",
		name = "Deer",
		isBird = false,
		maxMeat = 5
	},
    [`a_c_mtlion`] = {
		model = "a_c_mtlion",
		name = "Mountain Lion",
		isBird = false,
		maxMeat = 4
	},
    [`a_c_pigeon`] = {
		model = "a_c_pigeon",
		name = "Pigeon",
		isBird = true,
		maxMeat = 1
	},
    [`a_c_rabbit_01`] = {
		model = "a_c_rabbit_01",
		name = "Rabbit",
		isBird = false,
		maxMeat = 1
	},
    [`a_c_rat`] = {
		model = "a_c_rat",
		name = "Rat",
		isBird = false,
		maxMeat = 1
	},
    [`a_c_seagull`] = {
		model = "a_c_seagull",
		name = "Seagull",
		isBird = true,
		maxMeat = 2
	},
    [`a_c_cat_01`] = {
		model = "a_c_cat_01",
		name = "Cat",
		isBird = false,
		maxMeat = 2
	},
    [`a_c_poodle`] = {
		model = "a_c_poodle",
		name = "Poodle",
		isBird = false,
		maxMeat = 2
	},
    [`a_c_pug`] = {
		model = "a_c_pug",
		name = "Pug",
		isBird = false,
		maxMeat = 2
	},
    [`a_c_westy`] = {
		model = "a_c_westy",
		name = "West Highland Terrier",
		isBird = false,
		maxMeat = 2
	},
    [`a_c_chop`] = {
		model = "a_c_chop",
		name = "Rottweiler",
		isBird = false,
		maxMeat = 3
	},
    [`a_c_husky`] = {
		model = "a_c_husky",
		name = "Husky",
		isBird = false,
		maxMeat = 3
	},
    [`a_c_retriever`] = {
		model = "a_c_retriever",
		name = "Retriever",
		isBird = false,
		maxMeat = 3
	},
    [`a_c_shepherd`] = {
		model = "a_c_shepherd",
		name = "German Shephard",
		isBird = false,
		maxMeat = 3
	}
}

Config.QuestionableSell = {
	-- [inventoryItem] = sellPrice
	["a_c_cat_01_meat"] = 300,
	["a_c_poodle_meat"] = 310,
	["a_c_pug_meat"] = 310,
	["a_c_westy_meat"] = 310,
	["a_c_chop_meat"] = 360,
	["a_c_husky_meat"] = 360,
	["a_c_retriever_meat"] = 360,
	["a_c_shepherd_meat"] = 360,
	["a_c_cat_01_pelt_bad"] = 180,
	["a_c_cat_01_pelt_good"] = 200,
	["a_c_cat_01_pelt_rare"] = 240,
	["a_c_poodle_pelt_bad"] = 190,
	["a_c_poodle_pelt_good"] = 210,
	["a_c_poodle_pelt_rare"] = 230,
	["a_c_pug_pelt_bad"] = 190,
	["a_c_pug_pelt_good"] = 210,
	["a_c_pug_pelt_rare"] = 230,
	["a_c_westy_pelt_bad"] = 190,
	["a_c_westy_pelt_good"] = 210,
	["a_c_westy_pelt_rare"] = 230,
	["a_c_chop_pelt_bad"] = 210,
	["a_c_chop_pelt_good"] = 230,
	["a_c_chop_pelt_rare"] = 260,
	["a_c_husky_pelt_bad"] = 210,
	["a_c_husky_pelt_good"] = 230,
	["a_c_husky_pelt_rare"] = 260,
	["a_c_retriever_pelt_bad"] = 210,
	["a_c_retriever_pelt_good"] = 230,
	["a_c_retriever_pelt_rare"] = 260,
	["a_c_shepherd_pelt_bad"] = 210,
	["a_c_shepherd_pelt_good"] = 230,
	["a_c_shepherd_pelt_rare"] = 260
}

Config.MeatSell = {
	-- [inventoryItem] = sellPrice
	["a_c_boar_meat"] = 110,
	["a_c_chickenhawk_meat"] = 60,
	["a_c_cormorant_meat"] = 40,
	["a_c_coyote_meat"] = 75,
	["a_c_crow_meat"] = 25,
	["a_c_deer_meat"] = 125,
	["a_c_mtlion_meat"] = 250,
	["a_c_pigeon_meat"] = 25,
	["a_c_rabbit_01_meat"] = 100,
	["a_c_rat_meat"] = 25,
	["a_c_seagull_meat"] = 60
}

Config.PeltSell = {
	-- [inventoryItem] = sellPrice
	["a_c_boar_pelt_bad"] = 40,
	["a_c_boar_pelt_good"] = 125,
	["a_c_boar_pelt_rare"] = 250,
	["a_c_chickenhawk_pelt_bad"] = 35,
	["a_c_chickenhawk_pelt_good"] = 110,
	["a_c_chickenhawk_pelt_rare"] = 225,
	["a_c_cormorant_pelt_bad"] = 40,
	["a_c_cormorant_pelt_good"] = 125,
	["a_c_cormorant_pelt_rare"] = 250,
	["a_c_coyote_pelt_bad"] = 40,
	["a_c_coyote_pelt_good"] = 150,
	["a_c_coyote_pelt_rare"] = 300,
	["a_c_crow_pelt_bad"] = 40,
	["a_c_crow_pelt_good"] = 75,
	["a_c_crow_pelt_rare"] = 175,
	["a_c_deer_pelt_bad"] = 40,
	["a_c_deer_pelt_good"] = 150,
	["a_c_deer_pelt_rare"] = 250,
	["a_c_mtlion_pelt_bad"] = 75,
	["a_c_mtlion_pelt_good"] = 225,
	["a_c_mtlion_pelt_rare"] = 350,
	["a_c_pigeon_pelt_bad"] = 40,
	["a_c_pigeon_pelt_good"] = 100,
	["a_c_pigeon_pelt_rare"] = 150,
	["a_c_rabbit_01_pelt_bad"] = 40,
	["a_c_rabbit_01_pelt_good"] = 125,
	["a_c_rabbit_01_pelt_rare"] = 200,
	["a_c_rat_pelt_bad"] = 40,
	["a_c_rat_pelt_good"] = 60,
	["a_c_rat_pelt_rare"] = 100,
	["a_c_seagull_pelt_bad"] = 40,
	["a_c_seagull_pelt_good"] = 150,
	["a_c_seagull_pelt_rare"] = 200
}