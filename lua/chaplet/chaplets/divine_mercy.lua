local M = {}

local common_prayers = require("chaplet.prayers.common")
local divine_mercy_prayers = require("chaplet.prayers.divine_mercy")

local function create_decade()
    local decade = { "the_eternal_father" }
    -- Add 10 Hail Marys
    for _ = 1, 10 do
        table.insert(decade, "sorrowful_passion")
    end
    return decade
end

local function create_order()
    local order = {
        "you_expired_jesus",
        "fount_of_mercy",
        "fount_of_mercy",
        "fount_of_mercy",
        "our_father",
        "hail_mary",
        "apostles_creed",
    }

    for _ = 1, 5 do
        local decade = create_decade()
        for _, prayer in ipairs(decade) do
            table.insert(order, prayer)
        end
    end

    table.insert(order, "holy_god")
    table.insert(order, "holy_god")
    table.insert(order, "holy_god")
    table.insert(order, "mercy_prayer")

    return order
end

function M.get_prayer_text(prayer_name)
    local prayer = common_prayers[prayer_name] or divine_mercy_prayers[prayer_name]
    if not prayer then
        error("Prayer not found: " .. prayer_name)
    end

    return prayer
end

M.order = create_order()

return M
