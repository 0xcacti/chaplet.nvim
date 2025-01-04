local utils = require("chaplet.utils")
local config = require("chaplet.config")
local chaplets = require("chaplet.chaplets")
local M = {}

local has_notify, notify = pcall(require, "notify")
if not has_notify then
    notify = vim.notify
end

M.state = nil

local function clear_timers()
    if M.state then
        if M.state.display_timer then
            vim.fn.timer_stop(M.state.display_timer)
            M.state.display_timer = nil
        end

        if M.state.between_timer then
            vim.fn.timer_stop(M.state.between_timer)
            M.state.between_timer = nil
        end
    end
end

local function pause()
    if M.state then
        M.state.is_active = false
        clear_timers()

        if M.state.win and vim.api.nvim_win_is_valid(M.state.win) then
            vim.api.nvim_win_close(M.state.win, true)
            if M.state.prayer_index > 1 then
                M.state.prayer_index = M.state.prayer_index - 1
            end
        end
    end
end

local function resume()
    if M.state then
        M.state.is_active = true
        M.show_prayer()
        if not config.manual_only then
            M.schedule_prayer()
        end
    end
end

local function expand()
    if M.state and M.state.win and vim.api.nvim_win_is_valid(M.state.win) then
        M.state.expanded = not M.state.expanded
        if M.state.expanded then -- we just expanded
            clear_timers()
        else
            if not config.manual_only then
                M.schedule_prayer()
            end
            vim.api.nvim_win_set_cursor(M.state.win, { 1, 0 })
        end

        vim.api.nvim_win_set_height(
            M.state.win,
            M.state.expanded and M.state.max_height or M.state.collapse_height
        )
    end
end

local function terminate()
    clear_timers()
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

local function previous()
    if M.state and M.state.prayer_index > 1 then
        if M.state.win and vim.api.nvim_win_is_valid(M.state.win) then
            vim.api.nvim_win_close(M.state.win, true)
        end

        M.state.prayer_index = M.state.prayer_index - 1

        M.show_prayer()
        if not config.manual_only then
            M.schedule_prayer()
        end
    end
end

local function next()
    if M.state then
        clear_timers()

        if M.state.win and vim.api.nvim_win_is_valid(M.state.win) then
            vim.api.nvim_win_close(M.state.win, true)
        end

        M.state.prayer_index = M.state.prayer_index + 1

        if M.state.prayer_index > #M.state.chaplet.order then
            M.state = nil
        else
            M.show_prayer()
            if not config.manual_only then
                M.schedule_prayer()
            end
        end
    end
end

function M.show_prayer()
    if not M.state or not M.state.is_active or M.state.prayer_index > #M.state.chaplet.order then
        return
    end

    local prayer_name = M.state.chaplet.order[M.state.prayer_index]
    local prayer_text = M.state.chaplet.get_prayer_text(prayer_name)

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
            timeout = false,
            on_open = function(win)
                M.state.win = win
                vim.api.nvim_win_set_option(win, 'wrap', true)
                vim.api.nvim_win_set_option(win, 'linebreak', true)
                vim.api.nvim_win_set_option(win, 'list', false)
                vim.api.nvim_win_set_option(win, 'breakindent', true) -- Preserve indentation when wrapping
                vim.api.nvim_win_set_width(win, 50)
                vim.api.nvim_win_set_height(win, M.state.collapse_height)

                local buf = vim.api.nvim_win_get_buf(win)
                local opts = { buffer = buf, noremap = true, silent = true }

                vim.keymap.set('n', 'k', 'gk', opts)
                vim.keymap.set('n', 'j', 'gj', opts)
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

function M.schedule_prayer()
    if not M.state or not M.state.is_active then return end
    clear_timers()

    M.state.display_timer = vim.fn.timer_start(config.display_time, function()
        if M.state and M.state.win and vim.api.nvim_win_is_valid(M.state.win) then
            vim.api.nvim_win_close(M.state.win, true)
        end
    end)

    M.state.between_timer = vim.fn.timer_start(config.display_time + config.time_between, function()
        if M.state and M.state.is_active then
            next()
        end
    end)
end

function M.start_chaplet(message_type)
    if M.state then
        terminate()
    end

    M.state = nil

    local chaplet = chaplets[message_type]
    if not chaplet or not chaplet.order then
        notify("Chaplet not found: " .. message_type, "error")
        return
    end

    M.state = {
        -- window management
        main_win = vim.api.nvim_get_current_win(),
        win = nil,
        current_win = nil,
        expanded = false,
        collapse_height = 3,
        max_height = 7,

        -- timers
        display_timer = nil,
        between_timer = nil,

        -- prayer state
        is_active = true,
        prayer_index = 1,
        chaplet = chaplet,
    }

    M.show_prayer()
    if not config.manual_only then
        M.schedule_prayer()
    end
end

function M.setup(opts)
    config.setup(opts)

    vim.api.nvim_create_user_command('Chaplet', function(args)
        M.start_chaplet(args.args)
    end, {
        nargs = '?',
        complete = function()
            return { 'rosary', 'divine_mercy', 'st_michael' }
        end
    })

    vim.api.nvim_create_user_command('ChapletPause', pause, {})
    vim.api.nvim_create_user_command('ChapletResume', resume, {})
    vim.api.nvim_create_user_command('ChapletNext', next, {})
    vim.api.nvim_create_user_command('ChapletPrevious', previous, {})
    vim.api.nvim_create_user_command('ChapletEnd', terminate, {})
    vim.api.nvim_create_user_command('ChapletToggleFocus', toggle_focus, {})
    vim.api.nvim_create_user_command('ChapletToggleExpand', expand, {})
end

return M
