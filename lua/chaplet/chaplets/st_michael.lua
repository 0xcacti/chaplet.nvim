local M = {}

local common_prayers = require("chaplet.prayers.common")
local st_michaels_prayers = require("chaplet.prayers.st_michael")

local function create_decade()
    local decade = { "our_father" }
    -- Add 10 Hail Marys
    for _ = 1, 3 do
        table.insert(decade, "hail_mary")
    end
    return decade
end

local function create_order()
    local order = {
        "deus_in_adjutorium",
    }

    local decade = create_decade()

    table.insert(order, "seraphim_salutation")
    for _, prayer in ipairs(decade) do
        table.insert(order, prayer)
    end

    table.insert(order, "cherubim_salutation")
    for _, prayer in ipairs(decade) do
        table.insert(order, prayer)
    end

    table.insert(order, "thrones_salutation")
    for _, prayer in ipairs(decade) do
        table.insert(order, prayer)
    end

    table.insert(order, "dominations_salutation")
    for _, prayer in ipairs(decade) do
        table.insert(order, prayer)
    end

    table.insert(order, "virtues_salutation")
    for _, prayer in ipairs(decade) do
        table.insert(order, prayer)
    end

    table.insert(order, "powers_salutation")
    for _, prayer in ipairs(decade) do
        table.insert(order, prayer)
    end

    table.insert(order, "principalities_salutation")
    for _, prayer in ipairs(decade) do
        table.insert(order, prayer)
    end

    table.insert(order, "archangels_salutation")
    for _, prayer in ipairs(decade) do
        table.insert(order, prayer)
    end

    table.insert(order, "angels_salutation")
    for _, prayer in ipairs(decade) do
        table.insert(order, prayer)
    end

    for i = 1, 4 do
        table.insert(order, "our_father")
    end

    table.insert(order, "st_michaels_prayer_of_intercession")

    return order
end

function M.get_prayer_text(prayer_name)
    local prayer = common_prayers[prayer_name] or st_michaels_prayers[prayer_name]
    if not prayer then
        error("Prayer not found: " .. prayer_name)
    end

    return prayer
end

M.order = create_order()

return M
