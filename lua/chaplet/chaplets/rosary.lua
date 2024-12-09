local utils = require("chaplet.utils")


local function create_decade()
    local decade = { "our_father" }
    local hail_marys = utils.repeat_prayer("hail_mary", 10)
    for _, prayer in ipairs(hail_marys) do
        table.insert(decade, prayer)
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

M.rosary = {
    prayers = prayers,
    order = create_order(),
}

return M
