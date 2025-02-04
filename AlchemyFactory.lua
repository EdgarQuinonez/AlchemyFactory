AlchemyFactory = LibStub("AceAddon-3.0"):NewAddon("AlchemyFactory", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0")

local delay = 0

-- available classes
AlchemyFactory.UTILS = {}

AlchemyFactory.CONSTANT = {
    GUILDBANK = {
        SHORT = 'G',
        BAGSLOTS = {
            1, 2, 3, 4, 5, 6
        },
        MAX_GUILDBANK_SLOTS_PER_TAB = 98
    },
    ITEM = {
        FROZEN_ORB = {
            name = 'Frozen Orb',
            ID = 43102
        },
        CHALCEDONY = {
            name = 'Chalcedony',
            ID = 36923
        },
        DARK_JADE = {
            name = 'Dark Jade',
            ID = 36932
        },
        SHADOW_CRYSTAL = {
            name = 'Shadow Crystal',
            ID = 36926
        },
        SCARLET_RUBY = {
            name = 'Scarlet Ruby',
            ID = 36918
        },
        AUTUMNS_GLOW = {
            name = 'Autumn\'s Glow',
            ID = 36921
        },
        MONARCH_TOPAZ = {
            name = 'Monarch Topaz',
            ID = 36930
        },
        TWILIGHT_OPAL = {
            name = 'Twilight Opal',
            ID = 36927
        },
        FOREST_EMERALD = {
            name = 'Forest Emerald',
            ID = 36933
        },
        SKY_SAPPHIRE = {
            name = 'Sky Sapphire',
            ID = 36924
        },
        -- Elements
        ETERNAL_FIRE = {
            name = 'Eternal Fire',
            ID = 36860
        },
        ETERNAL_LIFE = {
            name = 'Eternal Life',
            ID = 35625
        },
        ETERNAL_SHADOW = {
            name = 'Eternal Shadow',
            ID = 35627
        },
        ETERNAL_AIR = {
            name = 'Eternal Air',
            ID = 35623
        },
        -- Products (Epic Gems)
        CARDINAL_RUBY = {
            name = 'Cardinal Ruby',
            ID = 36919
        },
        KINGS_AMBER = {
            name = 'King\'s Amber',
            ID = 36922
        },
        AMETRINE = {
            name = 'Ametrine',
            ID = 36931
        },
        DREADSTONE = {
            name = 'Dreadstone',
            ID = 36928
        },
        EYE_OF_ZUL = {
            name = 'Eye of Zul',
            ID = 36934
        },
        MAJESTIC_ZIRCON = {
            name = 'Majestic Zircon',
            ID = 36925
        },
        DRAGONS_EYE = {
            name = 'Dragon\'s Eye',
            ID = 42225
        },
        COBALT_ORE = {
            name = 'Cobalt Ore',
            ID = 36909
        },
        SARONITE_ORE = {
            name = 'Saronite Ore',
            ID = 36909
        },
        BLOODSTONE = {
            name = 'Bloodstone',
            ID = 36917
        },
        SUN_CRYSTAL = {
            name = 'Sun Crystal',
            ID = 36920
        },
        HUGE_CITRINE = {
            name = 'Huge Citrine',
            ID = 36929
        }
    },
    ROLES = {
        JA = {
            name = 'Jewelcrafting & Alchemy',
            short = 'JA'
        },
        A = {
            name = 'Alchemy',
            short = 'A'
        },
        J = {
            name = 'Jewelcrafting',
            short = 'J'
        }
    }
}

AlchemyFactory.CONSTANT.RECIPE = {    
    ICY_PRISM = {
        name = 'Icy Prism',
        mats = {
            -- itemId, quantity
            {AlchemyFactory.CONSTANT.ITEM.FROZEN_ORB.ID, 1},
            {AlchemyFactory.CONSTANT.ITEM.CHALCEDONY.ID, 1},
            {AlchemyFactory.CONSTANT.ITEM.DARK_JADE.ID, 1},
            {AlchemyFactory.CONSTANT.ITEM.SHADOW_CRYSTAL.ID, 1},
        }
    },
    CARDINAL_RUBY = {
        name = 'Transmute: Cardinal Ruby',
        mats = {                
            {AlchemyFactory.CONSTANT.ITEM.SCARLET_RUBY.ID, 1},
            {AlchemyFactory.CONSTANT.ITEM.ETERNAL_FIRE.ID, 1},
        }
    },
    KINGS_AMBER = {
        name = 'Transmute: King\'s Amber',
        mats = {                
            {AlchemyFactory.CONSTANT.ITEM.AUTUMNS_GLOW.ID, 1},
            {AlchemyFactory.CONSTANT.ITEM.ETERNAL_LIFE.ID, 1},
        }
    },
    AMETRINE = {
        name = 'Transmute: Ametrine',
        mats = {                
            {AlchemyFactory.CONSTANT.ITEM.MONARCH_TOPAZ.ID, 1},
            {AlchemyFactory.CONSTANT.ITEM.ETERNAL_SHADOW.ID, 1},
        }
    },
    DREADSTONE = {
        name = 'Transmute: Dreadstone',
        mats = {                
            {AlchemyFactory.CONSTANT.ITEM.TWILIGHT_OPAL.ID, 1},
            {AlchemyFactory.CONSTANT.ITEM.ETERNAL_SHADOW.ID, 1},
        }
    },
    MAJESTIC_ZIRCON = {
        name = 'Transmute: Majestic Zircon',
        mats = {                
            {AlchemyFactory.CONSTANT.ITEM.SKY_SAPPHIRE.ID, 1},
            {AlchemyFactory.CONSTANT.ITEM.ETERNAL_AIR.ID, 1},
        }
    },
    EYE_OF_ZUL = {
        name = 'Transmute: Eye of Zul',
        mats = {                
            {AlchemyFactory.CONSTANT.ITEM.FOREST_EMERALD.ID, 3},            
        }
    }
}

local defaults = {
    global = {
        GB_SlotCooldown = 0,
        GB_TransmutationPriorityList = {
            AlchemyFactory.CONSTANT.RECIPE.CARDINAL_RUBY,
            AlchemyFactory.CONSTANT.RECIPE.KINGS_AMBER,
            AlchemyFactory.CONSTANT.RECIPE.AMETRINE,
            AlchemyFactory.CONSTANT.RECIPE.DREADSTONE,
            AlchemyFactory.CONSTANT.RECIPE.MAJESTIC_ZIRCON,
            AlchemyFactory.CONSTANT.RECIPE.EYE_OF_ZUL,
        }
    }
}

function AlchemyFactory:OnInitialize()
    self:Print("AlchemyFactory initialized.")
    
    self:RegisterChatCommand("af", "SlashCommand")

    self.db = LibStub("AceDB-3.0"):New("AlchemyFactoryDB", defaults, true)    
end

function AlchemyFactory:OnEnable()
    
end

function AlchemyFactory:OnDisable()
    
end

function AlchemyFactory:SlashCommand(msg)
    if msg == "ja" then
        self:Print("Withdrawing JwC/Alch mats.")
        AlchemyFactory:WithdrawJAMats()
    elseif msg == "a" then
        self:Print("Withdrawing Alchemy mats.")
        AlchemyFactory:WithdrawAMats()
    elseif msg == "j" then
        self:Print("Withdrawing JwC mats.")
        AlchemyFactory:WithdrawJMats()
    elseif msg == "t" then
        AlchemyFactory:Transmute()
    elseif msg == "ip" then
        AlchemyFactory:CraftIcyPrism()
    elseif msg == "d" then
        AlchemyFactory:DepositProducts()
    elseif msg == "deg" then
        AlchemyFactory:DepositEpicGemsToGuildBank()
    elseif msg == "weg" then
        AlchemyFactory:WithdrawEpicGemsFromGuildBank()
    end
end

function AlchemyFactory:SearchItemInGBank(itemID, quantity)
    local nTabs = GetNumGuildBankTabs()
    local nSlots = AlchemyFactory.CONSTANT.GUILDBANK.MAX_GUILDBANK_SLOTS_PER_TAB
    
    for t = 1,nTabs
    do
        for s = 1,nSlots
        do
            local _, count, locked = GetGuildBankItemInfo(t, s)            
            local item = GetGuildBankItemLink(t, s)
            -- Item is found by id and count is enough
            if count ~= 0 and not locked then                
                if string.find(item, itemID) and count >= quantity then                
                    return {itemID, quantity, t, s}
                end
            end
            
        end
    end
    return false
end

function AlchemyFactory:SearchItemInSlot(itemID, b, s)    
    if itemID == GetContainerItemID(b,s) then                
        return {b, s}
    end
    return false
end

function AlchemyFactory:SearchProductInSlot(productsList, b, s)
    for i = 1,#productsList
    do
        local itemID = productsList[i]        
        local itemFound = AlchemyFactory:SearchItemInSlot(itemID, b, s)
        if itemFound then
            return itemFound
        end
    end
    return false
end

function AlchemyFactory:SearchProductsInContainer(productsList)
    local foundProducts = {}
    for b = 0,4
    do
        for s = 1,GetContainerNumSlots(b)
        do
            if GetContainerItemID(b,s) then
                local pos = AlchemyFactory:SearchProductInSlot(productsList, b, s)
                if pos then
                    table.insert(foundProducts, pos)
                end
            end
        end
    end
    return foundProducts
end


function AlchemyFactory.UTILS.CalcGBDelay()
    if AlchemyFactory.db then delay = tonumber(AlchemyFactory.db.global.GB_SlotCooldown) end
    local down, up, lag = GetNetStats()
    if lag > 0 then lag = (3*lag/1000) + 0.2 + delay            
    else
        lag = 0.35
    end
    return lag    
end

function AlchemyFactory:PickupOnContainerEmptySlot()
    for i = 0,4
    do
        for j = 2,GetContainerNumSlots(i)
        do
            if not GetContainerItemID(i,j) then
                PickupContainerItem(i,j)
                break
            end
        end
    end   
end

function AlchemyFactory:TableConcat(t1, t2)
    for i=1,#t2
    do
        t1[#t1+1] = t2[i]
    end
    return t1
end

function AlchemyFactory:DoWithdrawItemFromGuildBank(list)    
    if #list > 0 then
        local itemID, q, t, s = unpack(list[#list])
        SplitGuildBankItem(t, s, q)
        AlchemyFactory:PickupOnContainerEmptySlot()
        table.remove(list)
        AlchemyFactory:ScheduleTimer("DoWithdrawItemFromGuildBank", AlchemyFactory.UTILS.CalcGBDelay(), list)
    else
        AlchemyFactory:Print("Withdraw Done.")
        return false
    end
    return true
end

function AlchemyFactory:WithdrawJAMats()    
    local jList = AlchemyFactory:GetJWithdrawList()
    local aList = AlchemyFactory:GetAWithdrawList()

    local withdrawList = AlchemyFactory:TableConcat(aList, jList)
    -- print list
    -- for i = 1, #withdrawList
    -- do        
    --     AlchemyFactory:Print(withdrawList[i][1], withdrawList[i][2])
    -- end

    AlchemyFactory:DoWithdrawItemFromGuildBank(withdrawList)
end


function AlchemyFactory:WithdrawAMats()
    local withdrawList = AlchemyFactory:GetAWithdrawList()
    AlchemyFactory:DoWithdrawItemFromGuildBank(withdrawList)
end

function AlchemyFactory:WithdrawJMats()
    local withdrawList = AlchemyFactory:GetJWithdrawList()
    AlchemyFactory:DoWithdrawItemFromGuildBank(withdrawList)    
end

function AlchemyFactory:GetJWithdrawList()
    local recipe = AlchemyFactory.CONSTANT.RECIPE.ICY_PRISM
    local list = {}
    for i=1,#recipe.mats
    do
        local itemID, quantity = unpack(recipe.mats[i])        
        local foundItem = AlchemyFactory:SearchItemInGBank(itemID, quantity)

        if not foundItem then
            list = {}
            error("Not enough materials for Icy Prism craft.", 2)
        end
        
        table.insert(list, foundItem)
    end
    
    return list
end

function AlchemyFactory:GetAWithdrawList()
    local prioList = AlchemyFactory.db.global.GB_TransmutationPriorityList
    local withdrawList = {}

    for i=1,#prioList
    do
        local isLastIteration = i == #prioList
        local recipe = prioList[i]
        local matsFound = {} -- contains results from searching items through recipes' mats. Used to verify if all of the mats from a recipe exist before adding them to the withdrawing list.
        local match = true -- assuming there is a match (all mats needed for craft exists) we will add them to the withdrawing list and break from the prioList loop

        for j=1,#recipe.mats
        do
            local itemID, quantity = unpack(recipe.mats[j])
            local foundItem = AlchemyFactory:SearchItemInGBank(itemID, quantity)

            table.insert(matsFound, foundItem)
        end

        for j=1,#matsFound
        do
            local result = matsFound[j]
            if not result then
                match = false
                if isLastIteration then
                    error("Not enough materials for Transmutation.", 2)                                    
                end
            end
        end

        if match then
            for j=1,#matsFound
            do
                table.insert(withdrawList, matsFound[j])
            end

            break
        end
    end

    return withdrawList
end

function AlchemyFactory:Transmute()
    local prioList = AlchemyFactory.db.global.GB_TransmutationPriorityList
     
    for i = 1,#prioList
    do
        local craftName = prioList[i].name
        TradeSkillOnlyShowMakeable(true)
        for j = 1,GetNumTradeSkills()
        do
            if GetTradeSkillInfo(j) == craftName then
                SelectTradeSkill(j)
                DoTradeSkill(j)
                CloseTradeSkill()
                return
            end
        end
    end    
end

function AlchemyFactory:CraftIcyPrism()
    local craftName = AlchemyFactory.CONSTANT.RECIPE.ICY_PRISM.name
    TradeSkillOnlyShowMakeable(true)
    for i = 0,GetNumTradeSkills()
    do  
        if GetTradeSkillInfo(i) == craftName then
            SelectTradeSkill(i)
            DoTradeSkill(i)
            CloseTradeSkill()
            return
        end
    end
end

function AlchemyFactory:PickupOnGuildBankCurrentTabEmptySlot()
    local nSlots = AlchemyFactory.CONSTANT.GUILDBANK.MAX_GUILDBANK_SLOTS_PER_TAB
    local currTab = GetCurrentGuildBankTab()
    for s = 1,nSlots
    do                  
        local item = GetGuildBankItemLink(currTab, s)
        if not item then                
            PickupGuildBankItem(currTab, s)
            break
        end        
    end        
end

function AlchemyFactory:DoDepositIntoGuildBank(list)    
    if #list > 0 then
        local b, s = unpack(list[#list])
        UseContainerItem(b,s)
        -- i thought UseContainerItem was protected but it's fine to use
        -- ClearCursor()
        -- PickupContainerItem(b,s)
        -- AlchemyFactory:PickupOnGuildBankCurrentTabEmptySlot()
        table.remove(list)
        AlchemyFactory:ScheduleTimer("DoDepositIntoGuildBank", AlchemyFactory.UTILS.CalcGBDelay(), list)
    else
        AlchemyFactory:Print("Deposit Done.")
        return false
    end
    return true
end

function AlchemyFactory:DepositProducts()
    local items = AlchemyFactory.CONSTANT.ITEM
    local productsItemIDs = {}
    for k, v in pairs(items)
    do
        local itemID = v.ID
        table.insert(productsItemIDs, itemID)                
    end
    
    local products = AlchemyFactory:SearchProductsInContainer(productsItemIDs)
    AlchemyFactory:DoDepositIntoGuildBank(products)

end

function AlchemyFactory:DoWithdrawByItemNameListGuildBank(args)
    local itemNames, currSlot = unpack(args)
    local currTab = GetCurrentGuildBankTab()
    local nSlots = AlchemyFactory.CONSTANT.GUILDBANK.MAX_GUILDBANK_SLOTS_PER_TAB
    

    if currSlot <= nSlots then        
        local itemLink = GetGuildBankItemLink(currTab, currSlot)
        if itemLink then            
            for i = 1,#itemNames
            do            
                local name = itemNames[i]                            
                if string.find(itemLink, name) then
                    -- match                
                    AutoStoreGuildBankItem(currTab, currSlot)
                    AlchemyFactory:ScheduleTimer("DoWithdrawByItemNameListGuildBank", AlchemyFactory.UTILS.CalcGBDelay(), {itemNames, currSlot + 1})
                    return true
                end                                      
            end
            -- not empty, no match
            AlchemyFactory:DoWithdrawByItemNameListGuildBank({itemNames, currSlot + 1})
        else
            -- empty
            AlchemyFactory:DoWithdrawByItemNameListGuildBank({itemNames, currSlot + 1})
        end
    else
        AlchemyFactory:Print("Withdraw Done.")
        return false
    end    
end

function AlchemyFactory:WithdrawEpicGemsFromGuildBank()
    local items = AlchemyFactory.CONSTANT.ITEM
    local stringsToMatch = {items.CARDINAL_RUBY.name, items.KINGS_AMBER.name, items.AMETRINE.name, items.DREADSTONE.name, items.EYE_OF_ZUL.name, items.MAJESTIC_ZIRCON.name, items.DRAGONS_EYE.name, items.BLOODSTONE.name, items.HUGE_CITRINE.name, items.SUN_CRYSTAL.name, items.COBALT_ORE.name, items.SARONITE_ORE.name }


    AlchemyFactory:DoWithdrawByItemNameListGuildBank({stringsToMatch, 1})    
end

function AlchemyFactory:DoDepositByItemNameListIntoGuildBank(args)
    local itemNames, currBag, currSlot = unpack(args)
    if not itemNames then
        error("Item list to deposit was not provided.", 2)
    end
    if currBag <= 4 then
        local bagSlots = GetContainerNumSlots(currBag)
        local itemLink = GetContainerItemLink(currBag,currSlot)
        local bagIncrement = 0
        local slotIncrement = 1
        
        if currSlot >= bagSlots then
            bagIncrement = 1
            slotIncrement = -bagSlots - 1
        end

        if itemLink then                       
            for i = 1,#itemNames
            do            
                local name = itemNames[i]        
                if string.find(itemLink, name) then
                    UseContainerItem(currBag,currSlot)
                    AlchemyFactory:ScheduleTimer("DoDepositByItemNameListIntoGuildBank", AlchemyFactory.UTILS.CalcGBDelay(), {itemNames, currBag + bagIncrement, currSlot + slotIncrement} )
                    return true
                end            
            end
            -- not empty, no item match
            AlchemyFactory:DoDepositByItemNameListIntoGuildBank({itemNames, currBag + bagIncrement, currSlot + slotIncrement})         
        else
            -- empty slot
            AlchemyFactory:DoDepositByItemNameListIntoGuildBank({itemNames, currBag + bagIncrement, currSlot + slotIncrement})
        end
    else
        AlchemyFactory:Print("Deposit Done.")
        return false
    end         
end

function AlchemyFactory:DepositEpicGemsToGuildBank()
    local items = AlchemyFactory.CONSTANT.ITEM
    local stringsToMatch = {items.CARDINAL_RUBY.name, items.KINGS_AMBER.name, items.AMETRINE.name, items.DREADSTONE.name, items.EYE_OF_ZUL.name, items.MAJESTIC_ZIRCON.name, items.DRAGONS_EYE.name, items.BLOODSTONE.name, items.HUGE_CITRINE.name, items.SUN_CRYSTAL.name, items.COBALT_ORE.name, items.SARONITE_ORE.name }

    AlchemyFactory:DoDepositByItemNameListIntoGuildBank({stringsToMatch, 0, 1})
end