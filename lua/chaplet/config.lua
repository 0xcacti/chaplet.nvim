local M = {}

local defaults = {
    manual_only = false,
    display_time = 5000, -- 5 seconds
    time_between = 5000, -- 1 second
}

M = vim.deepcopy(defaults)

function M.setup(opts)
    M = vim.tbl_deep_extend("force", defaults, opts or {})
end

return M
