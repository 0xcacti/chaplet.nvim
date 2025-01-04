describe("repeat_prayer", function()
    local utils

    before_each(function()
        utils = require("chaplet.utils")
    end)

    it("Capitalize the beginnings of each prayer name", function()
        -- can handle a single word
        local prayer = "our_father"
        local result = utils.format_prayer_name(prayer)
        assert.are.equals(result, "Our Father")

        -- can handle a caps in name
        prayer = "Hail_Mary"
        result = utils.format_prayer_name(prayer)
        assert.are.equals(result, "Hail Mary")

        -- can handle multiple words
        prayer = "glory_be_to_the_father"
        result = utils.format_prayer_name(prayer)
        assert.are.equals(result, "Glory Be To The Father")
    end)
end)
