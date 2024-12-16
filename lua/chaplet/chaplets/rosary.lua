local M = {}

local common_prayers = require("chaplet.prayers.common")
local rosary_prayers = require("chaplet.prayers.rosary")

local function create_decade()
    local decade = { "our_father" }
    -- Add 10 Hail Marys
    for _ = 1, 10 do
        table.insert(decade, "hail_mary")
    end
    table.insert(decade, "glory_be")
    table.insert(decade, "fatima_prayer")
    return decade
end

local function create_order()
    local order = {
        "apostles_creed",
        "our_father",
        "hail_mary",
        "hail_mary",
        "hail_mary",
        "glory_be",
    }
    for _ = 1, 5 do
        local decade = create_decade()
        for _, prayer in ipairs(decade) do
            table.insert(order, prayer)
        end
    end

    table.insert(order, "hail_holy_queen")
    table.insert(order, "rosary_prayer")
    return order
end

function M.get_prayer_text(prayer_name)
    local prayer = common_prayers[prayer_name] or rosary_prayers[prayer_name]
    if not prayer then
        error("Prayer not found: " .. prayer_name)
    end

    return prayer
end

M.rosary = {
    order = create_order(),
}

return M
