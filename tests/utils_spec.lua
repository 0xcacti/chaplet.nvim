describe("repeat_prayer", function()
    local utils = require("chaplet.utils") -- adjust path as needed

    local sample_prayer = {
        text = "Sample Prayer",
        type = "test"
    }

    it("repeats a prayer the specified number of times", function()
        local result = utils.repeat_prayer(sample_prayer, 3)
        assert.equals(3, #result)
        assert.same(sample_prayer, result[1])
        assert.same(sample_prayer, result[2])
        assert.same(sample_prayer, result[3])
    end)

    it("returns empty table when times is 0", function()
        local result = utils.repeat_prayer(sample_prayer, 0)
        assert.equals(0, #result)
    end)

    it("maintains prayer reference integrity", function()
        local result = utils.repeat_prayer(sample_prayer, 2)
        -- Verify all entries point to the same prayer
        assert.is_true(result[1] == result[2])
    end)

    it("preserves prayer content", function()
        local complex_prayer = {
            text = "Complex Prayer",
            type = "test",
            metadata = {
                duration = 60,
                category = "test"
            }
        }
        local result = utils.repeat_prayer(complex_prayer, 1)
        assert.same(complex_prayer, result[1])
        assert.equals(complex_prayer.metadata.duration, result[1].metadata.duration)
    end)
end)
