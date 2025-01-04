describe("chaplet", function()
    it("can be required", function()
        require("chaplet")
    end)

    it("setup works", function()
        local chaplet = require("chaplet")
        chaplet.setup({})
    end)

    it("can start a chaplet", function()
        local chaplet = require("chaplet")
        assert.is_nil(chaplet.state)
        chaplet.start_chaplet("rosary")
        assert.is_not_nil(chaplet.state)
        state = chaplet.state
        assert.equals(state.prayer_index, 1)
        assert.equals(state.is_active, true)
    end)
end)
