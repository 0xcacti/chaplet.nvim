vim.cmd [[set runtimepath+=.]]
vim.cmd [[set runtimepath+=~/.local/share/nvim/site/pack/vendor/start/plenary.nvim]]
vim.cmd [[set runtimepath+=~/.local/share/nvim/site/pack/vendor/start/nvim-notify]]
vim.cmd [[runtime plugin/plenary.vim]]

require("notify").setup({})

