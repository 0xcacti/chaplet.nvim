local M = {}

local defaults = {
    manual_only = false,
    display_time = 60000,
    time_between = 360000,
}

function M.setup(opts)
    M = vim.tbl_deep_extend("force", defaults, opts or {})
end

return M
