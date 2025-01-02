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
            AlchemyFactory.CONSTANT.RECIPE.TWILIGHT_OPAL,
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
            if count ~= 0 then                
                if string.find(item, itemID) and count >= quantity then                
                    return {itemID, quantity, t, s}
                end
            end
            
        end
    end
    return false
end

function AlchemyFactory.UTILS.CalcGBDelay()
    if AlchemyFactory.db then delay = tonumber(AlchemyFactory.db.global.GB_SlotCooldown) end
    local down, up, lag = GetNetStats()
    if lag > 0 then lag = (3*lag/1000) + 0.2 + delay
    
    else
        lag = 2
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
        AlchemyFactory:Print("Operation Done.")
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