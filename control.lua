
local max_spill = 60

local rock_yield = {
    ['big-rock'] = 1,
    ['huge-rock'] = 2,
    ['big-sand-rock'] = 1
}
local rocks_yield_ore_distance_modifier = 0.25
local rocks_yield_ore_base_amount = 35
local rocks_yield_ore_maximum_amount = 150

local function get_chances() 
    local randomValue = math.random(0,99)
    
    if randomValue < 50 then
        return 'iron-ore'
    end
    if ( randomValue < 75) then
        return 'copper-ore'
    end
    
    return 'coal'
end

local function get_amount(entity)
    local distance_to_center = math.floor(math.sqrt(entity.position.x ^ 2 + entity.position.y ^ 2))

    local amount = rocks_yield_ore_base_amount + (distance_to_center * rocks_yield_ore_distance_modifier)
    if amount > rocks_yield_ore_maximum_amount then
        amount = rocks_yield_ore_maximum_amount
    end

    local m = (70 + math.random(0, 60)) * 0.01

    amount = math.floor(amount * rock_yield[entity.name] * m)
    if amount < 1 then
        amount = 1
    end

    return amount
end

local function on_player_mined_entity(event)
    local entity = event.entity
    if not entity.valid then
        return
    end
    if not rock_yield[entity.name] then
        return
    end

    event.buffer.clear()

    local ore = get_chances()
    local player = game.players[event.player_index]

    local position = { x = entity.position.x, y = entity.position.y }

    local count = get_amount(entity)
    local ore_amount = math.floor(count * 0.85) + 1
    local stone_amount = math.floor(count * 0.15) + 1
    entity.destroy()
    
    if ore_amount > max_spill then
        player.surface.spill_item_stack({position = position, stack = { name = ore, count = max_spill }, enable_looted = true})
        ore_amount = ore_amount - max_spill
        local inserted_count = player.insert({ name = ore, count = ore_amount })
        ore_amount = ore_amount - inserted_count
        if ore_amount > 0 then
            player.surface.spill_item_stack({position = position, stack = { name = ore, count = ore_amount }, enable_looted=true})
        end
    else
        player.surface.spill_item_stack({position=position, stack = { name = ore, count = ore_amount }, enable_looted=true})
    end

    if stone_amount > max_spill then
        player.surface.spill_item_stack({position=position, stack = { name = 'stone', count = max_spill }, enable_looted=true})
        stone_amount = stone_amount - max_spill
        local inserted_count = player.insert({ name = 'stone', count = stone_amount })
        stone_amount = stone_amount - inserted_count
        if stone_amount > 0 then
            player.surface.spill_item_stack({position=position, stack = { name = 'stone', count = stone_amount }, enable_looted=true})
        end
    else
        player.surface.spill_item_stack({position=position, stack = { name = 'stone', count = stone_amount }, enable_looted = true})
    end
end

script.on_event(defines.events.on_player_mined_entity, on_player_mined_entity)
