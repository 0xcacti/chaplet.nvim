describe("chaplet", function()
    local chaplet
    before_each(function()
        -- First require and setup chaplet
        chaplet = require("chaplet")
        chaplet.setup({})
    end)

    it("can start a chaplet", function()
        assert.is_nil(chaplet.state)
        chaplet.start_chaplet("rosary")
        assert.is_not_nil(chaplet.state)
        local state = chaplet.state
        assert.are.equals(state.prayer_index, 1)
        assert.are.equals(state.is_active, true)
    end)

    it("can pause a chaplet", function()
        chaplet.start_chaplet("rosary")
        vim.wait(100)
        vim.cmd("ChapletPause")
        assert.is_false(chaplet.state.is_active)
        assert.is_nil(chaplet.state.display_timer)
        assert.is_nil(chaplet.state.between_timer)
        assert.is_false(vim.api.nvim_win_is_valid(chaplet.state.win))
    end)

    it("can resume a chaplet", function()
        chaplet.start_chaplet("rosary")
        vim.wait(10)
        vim.cmd("ChapletPause")
        vim.wait(10)
        vim.cmd("ChapletResume")
        vim.wait(10)

        assert.is_true(chaplet.state.is_active)
        assert.is_not_nil(chaplet.state.display_timer)
        assert.is_not_nil(chaplet.state.between_timer)
        assert.is_true(vim.api.nvim_win_is_valid(chaplet.state.win))
    end)

    it("can progress forward through prayers", function()
        chaplet.start_chaplet("rosary")
        vim.wait(10)

        vim.cmd("ChapletNext")
        vim.wait(10)
        assert.are.equals(chaplet.state.prayer_index, 2)

        for _ = 1, 72 do
            vim.cmd("ChapletNext")
            vim.wait(10)
        end
        assert.is_nil(chaplet.state)

        -- try to go beyond the end
        vim.cmd("ChapletNext")
        vim.wait(10)
        assert.is_nil(chaplet.state)
    end)

    it("can progress backwards through prayers", function()
        chaplet.start_chaplet("rosary")
        vim.cmd("ChapletNext")
        vim.wait(10)
        assert.are.equals(chaplet.state.prayer_index, 2)

        vim.cmd("ChapletPrevious")
        vim.wait(10)
        assert.are.equals(chaplet.state.prayer_index, 1)

        vim.cmd("ChapletPrevious")
        vim.wait(10)
        assert.are.equals(chaplet.state.prayer_index, 1)
    end)

    it("can end a chaplet", function()
        chaplet.start_chaplet("rosary")
        vim.wait(10)
        vim.cmd("ChapletEnd")
        assert.is_nil(chaplet.state)
    end)

    after_each(function()
        package.loaded["chaplet"] = nil
    end)
end)
