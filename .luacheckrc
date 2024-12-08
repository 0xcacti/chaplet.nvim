-- Set the Lua standard environment
-- luajit for Neovim since it uses LuaJIT
std = "luajit"

-- Enable caching of check results
cache = true

-- Maximum line length (0 means no limit)
max_line_length = 120

-- Globals that can be both read and modified
globals = {
    -- Add your plugin's global variables here
    "MyPluginConfig",
}

-- Globals that can only be read, not modified
read_globals = {
    "vim",
}

-- Files to exclude from checking
exclude_files = {
    -- Third party modules
    ".luacheckrc"
}

-- Modify warnings
quiet = 1    -- Only show warnings for current file
color = true -- Colorize output
