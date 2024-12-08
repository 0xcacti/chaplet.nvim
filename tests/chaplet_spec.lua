require("plenary.test_harness")

describe("chaplet", function()
    it("can be required", function()
        require("chaplet")
    end)

    it("setup works", function()
        local chaplet = require("chaplet")
        chaplet.setup({})
    end)
end)
