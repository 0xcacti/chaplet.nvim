describe("common prayers test", function()
    local common = require("chaplet.prayers.common")
    it("contains the correct keys with non-empty values", function()
        expected_prayers = {
            "apostles_creed",
            "our_father",
            "hail_mary",
            "glory_be",
        }
    end)
end)


describe("rosary prayers test", function()
    local common = require("chaplet.prayers.rosary")
    it("contains the correct keys with non-empty values", function()
        expected_prayers = {
            "fatima_prayer",
            "hail_holy_queen",
            "rosary_prayer",
        }
    end)
end)
