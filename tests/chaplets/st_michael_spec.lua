describe("st_michaels_chaplet tests", function()
    local chaplet = require("chaplet.chaplets.st_michael")

    it("should have correct opening prayer", function()
        assert.equals("deus_in_adjutorium", chaplet.order[1])
    end)

    it("should have correct salutation and prayers structure", function()
        local section_start = 2 -- after opening prayer
        local expected_section = {
            "seraphim_salutation",
            "our_father", "hail_mary", "hail_mary", "hail_mary"
        }

        -- Test first section
        for i, prayer_name in ipairs(expected_section) do
            assert.equals(prayer_name, chaplet.order[section_start + i - 1])
        end
    end)

    it("should have all nine choirs in correct order", function()
        local choirs = {
            "seraphim", "cherubim", "thrones", "dominations", "virtues",
            "powers", "principalities", "archangels", "angels"
        }

        local section_length = 5 -- 1 salutation + 3 prayers
        for i, choir in ipairs(choirs) do
            local salutation_index = 2 + ((i - 1) * section_length)
            assert.equals(
                choir .. "_salutation",
                chaplet.order[salutation_index]
            )
        end
    end)

    it("should have four Our Fathers before final prayer", function()
        local order_length = #chaplet.order
        for i = order_length - 4, order_length - 1 do
            assert.equals("our_father", chaplet.order[i])
        end
    end)

    it("should end with St Michael's Prayer of Intercession", function()
        assert.equals(
            "st_michaels_prayer_of_intercession",
            chaplet.order[#chaplet.order]
        )
    end)

    it("should have correct total length", function()
        local expected_length =
            1 +     -- opening prayer (Deus in adjutorium)
            9 * 5 + -- 9 sections (salutation + our father + 3 hail marys)
            4 +     -- 4 our fathers
            1       -- final prayer
        assert.equals(expected_length, #chaplet.order)
    end)

    it("should return valid prayer text for each prayer in order", function()
        for _, prayer_name in ipairs(chaplet.order) do
            local success, result = pcall(function()
                return chaplet.get_prayer_text(prayer_name)
            end)
            assert.is_true(success, "Failed to get text for prayer: " .. prayer_name)
            assert.is_string(result)
            assert.is_true(#result > 0)
        end
    end)

    it("should error on invalid prayer name", function()
        local success, _ = pcall(function()
            chaplet.get_prayer_text("nonexistent_prayer")
        end)
        assert.is_false(success)
    end)
end)
