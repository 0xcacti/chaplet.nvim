local M = {}

function M.format_prayer_name(name)
    -- First replace underscores with spaces
    local with_spaces = name:gsub("_", " ")
    -- Then capitalize each word
    return with_spaces:gsub("%w+", function(word)
        return word:sub(1, 1):upper() .. word:sub(2):lower()
    end)
end

return M
