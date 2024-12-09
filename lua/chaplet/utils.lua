local M = {}

function M.repeat_prayer(prayer, times)
    local prayers = {}
    for i = 1, times do
        prayers[i] = prayer
    end
    return prayers
end

return M
