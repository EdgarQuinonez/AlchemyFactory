-- TODO: Might use DB instead of tables

-- mats = {
--     43102 = {
--         name = "Frozen Orb"
--     }
-- }


-- ID Mapping
-- Icy Prism
FROZEN_ORB = 43102
CHALCEDONY = 36923
DARK_JADE = 36932
SHADOW_CRYSTAL = 36926
-- Rare gems 
SCARLET_RUBY = 36918
AUTUMNS_GLOW = 36921
MONARCH_TOPAZ = 36930
TWILIGHT_OPAL = 36927
FOREST_EMERALD = 36933
SKY_SAPPHIRE = 36924
-- Elements
ETERNAL_FIRE = 36860
ETERNAL_LIFE = 35625
ETERNAL_SHADOW = 35627
ETERNAL_AIR = 35623

-- Products
-- Epic Gems
CARDINAL_RUBY = 36919
KINGS_AMBER = 36922
AMETRINE = 36931
DREADSTONE = 36928
EYE_OF_ZUL = 36934
MAJESTIC_ZIRCON = 36925
DRAGONS_EYE = 42225

-- Recipes
ICY_PRISM_RECIPE = {
    {FROZEN_ORB, 1},
    {CHALCEDONY, 1},
    {DARK_JADE, 1},
    {SHADOW_CRYSTAL, 1}
}

-- TODO: Add a function to manually change prio order in-game or auto (e.g. using ah prices for gem crafts)
-- { item_id, quantity } instead of recipe per epic gem transmutation
PriorityList = {
    {SCARLET_RUBY, 1},
    {AUTUMNS_GLOW, 1},
    {MONARCH_TOPAZ, 1},
    {TWILIGHT_OPAL, 1},
    {SKY_SAPPHIRE, 1},
    {FOREST_EMERALD, 3},
}

local function search_item_in_gbank(item_id, quantity)        
    local n_tabs = GetNumGuildBankTabs()
    local n_slots = 98
    for tab = 1,n_tabs
    do                
        for slot = 1,n_slots
        do
            local _, count, locked = GetGuildBankItemInfo(tab, slot)            
            local item = GetGuildBankItemLink(tab, slot)
            -- Item is found by id and count is enough
            if count ~= 0 then                
                if string.find(item, item_id) and count >= quantity then                
                    return {item_id, quantity, tab, slot}
                end
            end
        end
    end
    -- print("Item not found.")
    return false
end

local function pickup_on_container_empty_slot ()
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


local function withdraw_jalch_mats ()
    local withdraw_list = {}
    
    -- Iterate through priority list also checking for pair matches such as Scarlet Ruby and Eternal Fire
    for i = 1,#PriorityList
    do
        local is_last_iteration = i == #PriorityList
        local item_id, quantity = unpack(PriorityList[i])
        local rare_gem_found = search_item_in_gbank(item_id, quantity)        
        
        local the_other_one = nil
        if rare_gem_found then            
           
            if item_id == SCARLET_RUBY then
                the_other_one = search_item_in_gbank(ETERNAL_FIRE, quantity)                            
            elseif item_id == AUTUMNS_GLOW then
                the_other_one = search_item_in_gbank(ETERNAL_LIFE, quantity)
            elseif item_id == MONARCH_TOPAZ then
                the_other_one = search_item_in_gbank(ETERNAL_SHADOW, quantity)                
            elseif item_id == TWILIGHT_OPAL then
                the_other_one = search_item_in_gbank(ETERNAL_SHADOW, quantity)
            elseif item_id == SKY_SAPPHIRE then
                the_other_one = search_item_in_gbank(ETERNAL_AIR, quantity)
            elseif item_id == FOREST_EMERALD then
                table.insert(withdraw_list, rare_gem_found)                
                break
            else
                error(string.format("Unhandled case (%s)", item_id), 2)
                break
            end
        end        

      
        if the_other_one then            
            table.insert(withdraw_list, rare_gem_found)
            table.insert(withdraw_list, the_other_one)
            break
        end
   
        if is_last_iteration then
            error("Insuficient materials.")
        end        
    end
    
    
    for i = 1,#ICY_PRISM_RECIPE
    do
        local mat = ICY_PRISM_RECIPE[i]
        local item_id, quantity = unpack(mat)
        local mat_found = search_item_in_gbank(item_id, quantity)
        if not mat_found then            
            error("Insuficient JWC mats.", 2)            
        end        
        table.insert(withdraw_list, mat_found)
    end    
    for i = 1,#withdraw_list
    do
        local _, quantity, tab, slot = unpack(withdraw_list[i])        
        AutoStoreGuildBankItem(tab, slot)
        -- SplitGuildBankItem(tab, slot, quantity)
        -- pickup_on_container_empty_slot()        
    end
end


SLASH_ALCHEMYFACTORY1 = '/alfa';
local function handler(msg, editBox)
    if msg == 'jwc' then
        print("Withdraw jwcs")
    elseif msg == 'alch' then
        print("Withdraw alch")
    elseif msg == 'jalch' then
        withdraw_jalch_mats()
    else
        print("Invalid option for /alfa. Try options jwc, alch or jalch")
    end
end

SlashCmdList["ALCHEMYFACTORY"] = handler;