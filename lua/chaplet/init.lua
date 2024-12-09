local config = require("chaplet.config")
local M = {}

local has_notify, notify = pcall(require, "notify")
if not has_notify then
    notify = vim.notify
end

function M.start_chaplet(message_type)
    notify(
        {
            "Initial message (press 'e' to expand)",
            "-----------------",
            "Here's the expanded content",
            "With multiple lines",
            "Of detailed information"
        },
        "info",
        {
            title = "Chaplet",
            render = "default",
            timeout = false,
            on_open = function(win)
                local buf = vim.api.nvim_win_get_buf(win)
                local expanded = false
                local collapse_height = 3
                local max_height = 7

                -- Start collapsed
                vim.api.nvim_win_set_height(win, collapse_height)

                vim.keymap.set('n', '<leader>j', function()
                    -- Store current window before jumping
                    local current_win = vim.api.nvim_get_current_win()
                    vim.api.nvim_set_current_win(win)

                    -- Create mapping to jump back (using the same key)
                    vim.keymap.set('n', '<leader>j', function()
                        if vim.api.nvim_win_is_valid(current_win) then
                            vim.api.nvim_set_current_win(current_win)
                        end
                    end, { buffer = buf, silent = true })
                end, { silent = true })

                vim.keymap.set('n', 'e', function()
                    expanded = not expanded
                    vim.api.nvim_win_set_height(win, expanded and max_height or collapse_height)
                end, { buffer = buf, silent = true })

                vim.keymap.set('n', 'q', function()
                    vim.api.nvim_win_close(win, true)
                end, { buffer = buf, silent = true })
            end,
            window = {
                border = "rounded",
                focusable = true,
            }
        }
    )
end

function M.setup(opts)
    config.setup(opts)

    vim.api.nvim_create_user_command('Chaplet', function(args)
        M.start_chaplet(args.args)
    end, {
        nargs = '?',
        complete = function()
            return { 'rosary', 'st michael' }
        end
    })
end

return M
