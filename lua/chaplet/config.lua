local M = {
    manual_only = false,
    display_time = 60000,
    time_between = 300000,
}

function M.setup(opts)
    for k, v in pairs(opts or {}) do
        M[k] = v
    end
end

return M
