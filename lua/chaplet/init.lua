local config = require("chaplet.config")
local chaplets = require("chaplet.chaplets")
local M = {}

local has_notify, notify = pcall(require, "notify")
if not has_notify then
    notify = vim.notify
end

function M.start_chaplet(message_type)
    local chaplet = chaplets[message_type]
    if not chaplet then
        notify("Chaplet not found: " .. message_type, "error")
        return
    end

    local prayer_order = chaplet[message_type].order
    if not prayer_order then
        notify("Chaplet not found: " .. message_type, "error")
        return
    end

    local current_win = nil
    local is_closed = false
    local prayer_index = 1

    local function show_next_prayer()
        if prayer_index > #prayer_order then
            return
        end
        local prayer_text = chaplet.get_prayer_text(prayer_name)
        notify(
            {
                prayer_name,
                string.rep("-", #prayer_name),
                prayer_text,
            },
            "info",
            {
                title = "Chaplet",
                render = "default",
                timeout = false,
                on_open = function(win)
                    current_win = win
                    is_closed = false
                    local buf = vim.api.nvim_win_get_buf(win)

                    local expanded = false
                    local collapse_height = 3
                    local max_height = 7
                    vim.api.nvim_win_set_option(win, 'wrap', true)
                    vim.api.nvim_win_set_option(win, 'linebreak', true)
                    vim.api.nvim_win_set_width(win, 50)

                    -- Start collapsed
                    vim.api.nvim_win_set_height(win, collapse_height)

                    vim.keymap.set('n', '<leader>j', function()
                        -- Store current window before jumping
                        current_win = vim.api.nvim_get_current_win()
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
                        is_closed = true
                        prayer_index = prayer_index + 1
                    end, { buffer = buf, silent = true })
                    vim.defer_fn(function()
                        if not is_closed and vim.api.nvim_win_is_valid(win) then
                            vim.api.nvim_win_close(win, true)
                            prayer_index = prayer_index + 1
                            show_next_prayer()
                        end
                    end, 20000)
                end,
                window = {
                    border = "rounded",
                    focusable = true,
                    width = 50,
                    max_width = 50,
                }
            }
        )
    end
    for _, prayer_name in ipairs(chaplet.rosary.order) do
        show_next_prayer()
    end
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
