describe("divine mercy tests", function()
    local divine_mercy = require("chaplet.chaplets.divine_mercy")

    it("should have correct opening sequence", function()
        local expected_opening = {
            "you_expired_jesus",
            "fount_of_mercy",
            "fount_of_mercy",
            "fount_of_mercy",
            "our_father",
            "hail_mary",
            "apostles_creed",
        }

        for i, prayer_name in ipairs(expected_opening) do
            assert.equals(prayer_name, divine_mercy.order[i])
        end
    end)

    it("should have correct decade structure", function()
        local decade_start = 8 -- after opening prayers
        local expected_decade = {
            "the_eternal_father",
            "sorrowful_passion", "sorrowful_passion", "sorrowful_passion",
            "sorrowful_passion", "sorrowful_passion", "sorrowful_passion",
            "sorrowful_passion", "sorrowful_passion", "sorrowful_passion",
            "sorrowful_passion"
        }

        -- Test first decade
        for i, prayer_name in ipairs(expected_decade) do
            assert.equals(prayer_name, divine_mercy.order[decade_start + i - 1])
        end
    end)

    it("should have correct number of decades", function()
        local decade_length = 13                        -- our father + 10 hail marys + glory be + fatima prayer
        local decades_count = 0
        local start_index = 8                           -- after opening prayers

        for i = start_index, #divine_mercy.order - 4 do -- -2 for closing prayers
            if divine_mercy.order[i] == "the_eternal_father" and
                divine_mercy.order[i + 10] == "sorrowful_passion" then
                decades_count = decades_count + 1
            end
        end

        assert.equals(5, decades_count)
    end)

    it("should have correct closing sequence", function()
        local order_length = #divine_mercy.order
        local expected_closing = {
            "holy_god",
            "holy_god",
            "holy_god",
            "mercy_prayer"
        }
        for i, prayer_name in ipairs(expected_closing) do
            assert.equals(
                prayer_name,
                divine_mercy.order[order_length - #expected_closing + i]
            )
        end
    end)

    it("should have correct total length", function()
        local expected_length =
            7 +        -- opening prayers (you expired + 3x fount + our father + hail mary + creed)
            (11 * 5) + -- 5 decades * (1 eternal father + 10 sorrowful passion)
            4          -- closing prayers (3x holy god + mercy prayer)
        assert.equals(expected_length, #divine_mercy.order)
    end)

    it("should return valid prayer text for each prayer in order", function()
        for _, prayer_name in ipairs(divine_mercy.order) do
            local success, result = pcall(function()
                return divine_mercy.get_prayer_text(prayer_name)
            end)
            assert.is_true(success, "Failed to get text for prayer: " .. prayer_name)
            assert.is_string(result)
            assert.is_true(#result > 0)
        end
    end)

    it("should error on invalid prayer name", function()
        local success, _ = pcall(function()
            divine_mercy.get_prayer_text("nonexistent_prayer")
        end)
        assert.is_false(success)
    end)
end)
