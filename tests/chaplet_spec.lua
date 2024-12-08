describe("chaplet", function()
    it("can be required", function()
        require("chaplet")
    end)

    it("setup works", function()
        local chaplet = require("chaplet")
        chaplet.setup({})
        -- Add assertions here
    end)
end)
