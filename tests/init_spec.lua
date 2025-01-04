describe("chaplet", function()
    local chaplet
    before_each(function()
        chaplet = require("chaplet")
        chaplet.setup({})
    end)

    it("can start a chaplet", function()
        assert.is_nil(chaplet.state)
        chaplet.start_chaplet("rosary")
        vim.wait(100)
        assert.is_not_nil(chaplet.state)
        assert.are.equals(chaplet.state.prayer_index, 1)
        assert.are.equals(chaplet.state.is_active, true)
    end)

    it("can pause a chaplet", function()
        chaplet.start_chaplet("rosary")
        vim.wait(100)
        vim.cmd("ChapletPause")
        vim.wait(100)
        assert.is_false(chaplet.state.is_active)
        assert.is_nil(chaplet.state.display_timer)
        assert.is_nil(chaplet.state.between_timer)
    end)

    it("can resume a chaplet", function()
        chaplet.start_chaplet("rosary")
        vim.wait(100)
        vim.cmd("ChapletPause")
        vim.wait(100)
        vim.cmd("ChapletResume")
        vim.wait(100)
        assert.is_true(chaplet.state.is_active)
    end)

    it("can progress forward through prayers", function()
        chaplet.start_chaplet("rosary")
        vim.wait(100)
        vim.cmd("ChapletNext")
        vim.wait(100)
        assert.are.equals(chaplet.state.prayer_index, 2)

        -- Test going to end
        for _ = 1, 72 do
            vim.cmd("ChapletNext")
            vim.wait(100)
        end
        assert.is_nil(chaplet.state)

        -- Test going beyond end
        vim.cmd("ChapletNext")
        vim.wait(100)
        assert.is_nil(chaplet.state)
    end)

    it("can progress backwards through prayers", function()
        chaplet.start_chaplet("rosary")
        vim.wait(100)
        vim.cmd("ChapletNext")
        vim.wait(100)
        assert.are.equals(chaplet.state.prayer_index, 2)
        vim.cmd("ChapletPrevious")
        vim.wait(100)
        assert.are.equals(chaplet.state.prayer_index, 1)
        vim.cmd("ChapletPrevious")
        vim.wait(100)
        assert.are.equals(chaplet.state.prayer_index, 1)
    end)

    it("can end a chaplet", function()
        chaplet.start_chaplet("rosary")
        vim.wait(100)
        vim.cmd("ChapletEnd")
        vim.wait(100)
        assert.is_nil(chaplet.state)
    end)

    after_each(function()
        if chaplet.state then
            vim.cmd("ChapletEnd")
        end
        package.loaded["chaplet"] = nil
    end)
end)
