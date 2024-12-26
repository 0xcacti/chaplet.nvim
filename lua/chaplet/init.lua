local utils = require("chaplet.utils")
local config = require("chaplet.config")
local chaplets = require("chaplet.chaplets")
local M = {}

local has_notify, notify = pcall(require, "notify")
if not has_notify then
    notify = vim.notify
end

M.state = nil

local function pause()
    if M.state and M.state.win and vim.api.nvim_win_is_valid(M.state.win) then
        vim.api.nvim_win_close(M.state.win, true)
    end
end

local function resume()
end

local function expand()
    if M.state and M.state.win then
        M.state.expanded = not M.state.expanded
        vim.api.nvim_win_set_height(
            M.state.win,
            M.state.expanded and M.state.max_height or M.state.collapse_height
        )
    end
end

local function terminate()
    if M.state and M.state.win and vim.api.nvim_win_is_valid(M.state.win) then
        vim.api.nvim_win_close(M.state.win, true)
    end
    M.state = nil
end

local function toggle_focus()
    local current_win = vim.api.nvim_get_current_win()
    if M.state and M.state.win and vim.api.nvim_win_is_valid(M.state.win) then
        if current_win == M.state.win then
            vim.api.nvim_set_current_win(M.state.main_win)
        else
            vim.api.nvim_set_current_win(M.state.win)
        end
    end
end

-- handle edge cases
local function previous()
    if M.state then
        if M.state.prayer_index > 1 then
            if M.state.win and vim.api.nvim_win_is_valid(M.state.win) then
                vim.api.nvim_win_close(M.state.win, true)
            end
            M.state.prayer_index = M.state.prayer_index - 1
            M.state.show_next_prayer()
        end
    end
end

local function next()
    if M.state then
        if M.state.win and vim.api.nvim_win_is_valid(M.state.win) then
            vim.api.nvim_win_close(M.state.win, true)
        end

        M.state.prayer_index = M.state.prayer_index + 1

        if M.state.prayer_index > #M.state.prayer_order then
            M.state = nil
        else
            M.state.show_next_prayer()
        end
    end
end




function M.start_chaplet(message_type)
    if M.state and M.state.win and vim.api.nvim_win_is_valid(M.state.win) then
        M.state = nil
    end

    M.state = nil

    local chaplet = chaplets[message_type]
    if not chaplet or not chaplet.order then
        notify("Chaplet not found: " .. message_type, "error")
        return
    end

    M.state = {
        main_win = vim.api.nvim_get_current_win(),
        win = nil,
        expanded = false,
        collapse_height = 3,
        max_height = 7,
        is_active = true,
        current_win = nil,
        prayer_index = 1,
        prayer_order = chaplet.order,
        timeout = config.display_time,
    }

    if config.manual_only then
        M.state.timeout = false
    end

    local function show_next_prayer()
        if not M.state or M.state.prayer_index > #M.state.prayer_order then
            return
        end

        local prayer_name = M.state.prayer_order[M.state.prayer_index]
        local prayer_text = chaplet.get_prayer_text(prayer_name)

        notify(
            {
                utils.format_prayer_name(prayer_name),
                string.rep("-", #prayer_name),
                prayer_text,
            },
            "info",
            {
                title = "Chaplet",
                render = "default",
                timeout = M.state.timeout,
                on_open = function(win)
                    M.state.win = win
                    vim.api.nvim_win_set_option(win, 'wrap', true)
                    vim.api.nvim_win_set_option(win, 'linebreak', true)
                    vim.api.nvim_win_set_width(win, 50)
                    vim.api.nvim_win_set_height(win, M.state.collapse_height)
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

    M.state.show_next_prayer = show_next_prayer


    if config.manual_only then
        show_next_prayer()
    else
        local function schedule_next_prayer()
            if not M.state then return end -- Check if state still exists

            show_next_prayer()

            vim.defer_fn(function()
                if M.state and M.state.win and vim.api.nvim_win_is_valid(M.state.win) then
                    pcall(vim.api.nvim_win_close, M.state.win, true)
                end

                if M.state then
                    M.state.prayer_index = M.state.prayer_index + 1
                    if M.state.prayer_index > #M.state.prayer_order then
                        M.state = nil
                    else
                        vim.defer_fn(function()
                            if M.state then -- Check if state still exists
                                schedule_next_prayer()
                            end
                        end, config.time_between)
                    end
                end
            end, config.display_time)
        end

        schedule_next_prayer()
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

    vim.api.nvim_create_user_command('ChapletPause', pause, {})
    vim.api.nvim_create_user_command('ChapletResume', resume, {})
    vim.api.nvim_create_user_command('ChapletNext', next, {})                -- done  I think but needs to be checked with edge cases
    vim.api.nvim_create_user_command('ChapletPrevious', previous, {})        -- done I think but needs to be checked with edge cases
    vim.api.nvim_create_user_command('ChapletEnd', terminate, {})            -- done I think but needs to be checked when no notif is displaying
    vim.api.nvim_create_user_command('ChapletToggleFocus', toggle_focus, {}) -- done
    vim.api.nvim_create_user_command('ChapletToggleExpand', expand, {})      --done
end

return M

--- I want
--- Pause and Hide - should close the window keeping track of state (pause)
--- Open and Continue (either with full time or part time) ; default full time (resume)
---
--- Complete and Next - must be hit for manual only, otherwise closes auto styles, (next)
---         should have manual_with_wait (where it moves only after a certain time even in manual), can be set to 0 for immediate
---
--- Get Last Prayer (should accept a count) (previous)
--- -- Using v:count (defaults to 0 if no count given)
--          vim.keymap.set('n', '<leader>lsp', function()
--              for i = 1, math.max(1, vim.v.count) do
--                  -- Your LSP restart logic here
--                  vim.cmd('LspRestart')
--              end
--          end)
--
--          -- Using v:count1 (defaults to 1 if no count given)
--          vim.keymap.set('n', '<leader>lsp', function()
--              for i = 1, vim.v.count1 do
--                  vim.cmd('LspRestart')
--              end
--          end)
--- End Completely (terminate)
--- Focus should go to the thing (toggle_focus)
--- Expand should expand the window to show the prayer (expand)
---
--- these commands will handle all moving forward and backwards
