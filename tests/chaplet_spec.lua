describe("chaplet", function()
    it("can be required", function()
        require("chaplet")
    end)

    it("setup works", function()
        local chaplet = require("chaplet")
        chaplet.setup({})
    end)

    it("contains the correct prayers for a decade of the Holy Rosary", function()
        local chaplet = require("chaplet.chaplets")
        print(vim.inspect(chaplet.rosary.order))
        assert.are.same(chaplet.rosary.order[1], "apostles_creed")
        assert.are.same(chaplet.rosary.order[2], "our_father")
        for i = 3, 5 do
            assert.are.same(chaplet.rosary.order[i], "hail_mary")
        end
        assert.are.same(chaplet.rosary.order[6], "glory_be")
        assert.are.same(chaplet.rosary.order[7], "our_father")
        for i = 8, 17 do
            assert.are.same(chaplet.rosary.order[i], "hail_mary")
        end
        assert.are.same(chaplet.rosary.order[18], "glory_be")
        assert.are.same(chaplet.rosary.order[19], "fatima_prayer")
        assert.are.same(chaplet.rosary.order[20], "our_father")
    end)
end)
