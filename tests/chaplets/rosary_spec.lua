describe("rosary tests", function()
    local rosary = require("chaplet.chaplets.rosary")

    it("should have correct opening sequence", function()
        local expected_opening = {
            "apostles_creed",
            "our_father",
            "hail_mary",
            "hail_mary",
            "hail_mary",
            "glory_be"
        }

        for i, prayer_name in ipairs(expected_opening) do
            assert.equals(prayer_name, rosary.order[i])
        end
    end)

    it("should have correct decade structure", function()
        local decade_start = 7 -- after opening prayers
        local expected_decade = {
            "our_father",
            "hail_mary", "hail_mary", "hail_mary", "hail_mary", "hail_mary",
            "hail_mary", "hail_mary", "hail_mary", "hail_mary", "hail_mary",
            "glory_be",
            "fatima_prayer"
        }

        -- Test first decade
        for i, prayer_name in ipairs(expected_decade) do
            assert.equals(prayer_name, rosary.order[decade_start + i - 1])
        end
    end)

    it("should have correct number of decades", function()
        local decades_count = 0
        local start_index = 7                     -- after opening prayers

        for i = start_index, #rosary.order - 2 do -- -2 for closing prayers
            if rosary.order[i] == "our_father" and
                rosary.order[i + 11] == "glory_be" and
                rosary.order[i + 12] == "fatima_prayer" then
                decades_count = decades_count + 1
            end
        end

        assert.equals(5, decades_count)
    end)

    it("should have correct closing prayers", function()
        local order_length = #rosary.order
        assert.equals("hail_holy_queen", rosary.order[order_length - 1])
        assert.equals("rosary_prayer", rosary.order[order_length])
    end)

    it("should have correct total length", function()
        local expected_length =
            6 +        -- opening prayers
            (13 * 5) + -- 5 decades * (1 our father + 10 hail marys + 1 glory be + 1 fatima prayer)
            2          -- closing prayers

        assert.equals(expected_length, #rosary.order)
    end)

    it("should return valid prayer text for each prayer in order", function()
        for _, prayer_name in ipairs(rosary.order) do
            local success, result = pcall(function()
                return rosary.get_prayer_text(prayer_name)
            end)
            assert.is_true(success, "Failed to get text for prayer: " .. prayer_name)
            assert.is_string(result)
            assert.is_true(#result > 0)
        end
    end)

    it("should error on invalid prayer name", function()
        local success, _ = pcall(function()
            rosary.get_prayer_text("nonexistent_prayer")
        end)
        assert.is_false(success)
    end)
end)
