## chaplet.nvim 
#### A neovim plugin to help you pray the rosary and other chaplets while you code.

----

<p align="center">
  <img alt="Rosary" height = "500" src="/assets/praying-hands-chaplet.jpg" />
</p>

----

### Table of Contents 
- [About](#about)
- [Installation](#installation)
- [Configuration](#configuration)
- [Contributing](#contributing)
- [Local Parish Support](#local-parish-support)

----

### About 

<p align="center">
    <em>"Pray without ceasing"</em><br>
    - Saint Paul (1 Thessalonians 5:17)
</p>


Chaplet.nvim is inspired by Saint Paul's call to constant prayer. 

The plugin provides a non-intrusive way to pray traditional Catholic chaplets,
including the Holy Rosary, the Divine Mercy Chaplet, and others, right within your Neovim environment. 


### Installation


<details>
<summary>Packer</summary>

Using [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use {
    'turakar/chaplet.nvim',
    requires = {
        'rcarriga/nvim-notify'  -- Required for notifications
    },
    config = function()
        require('chaplet').setup({
            -- Your configuration here (optional)
        })
    end
}
</details>

<details>
<summary>Lazy</summary>
{
    'turakar/chaplet.nvim',
    dependencies = {
        'rcarriga/nvim-notify'  -- Required for notifications
    },
    opts = {
        -- Your configuration here (optional)
    },
    -- If you want to load only when a command is used
    cmd = {
        "Chaplet",
        "ChapletPause",
        "ChapletResume",
        "ChapletNext",
        "ChapletPrevious",
        "ChapletEnd",
        "ChapletToggleFocus",
        "ChapletToggleExpand"
    }
}
</details>

#### Requirementns 
- This plugin requires Neovim 0.8 or higher
- nvim-notify

### Configuration

There are a few configuration options available for chaplet.nvim.

```lua
    require('chaplet').setup({
        -- Time in milliseconds to display each prayer
        display_time = 10000,

        -- Time in milliseconds between each prayer 
        time_between = 60000,

        -- If true, prayers will not be displayed on a timer
        manual_only = false,
    })
```

I did not add any keybindings to this plugin, however, 
if you would like some, I use the following. 

```lua
    vim.keymap.set('n', '<leader>chn', function()
        for _ = 1, vim.v.count1 do
            vim.cmd('ChapletNext')
        end
    end, { desc = 'Next prayer' })

    vim.keymap.set('n', '<leader>chp', function()
        for _ = 1, vim.v.count1 do
            vim.cmd('ChapletPrevious')
        end
    end, { desc = 'Previous prayer' })

    vim.keymap.set('n', '<leader>chf', ':ChapletToggleFocus<CR>', { desc = 'Toggle focus' })
    vim.keymap.set('n', '<leader>che', ':ChapletToggleExpand<CR>', { desc = 'Toggle expand' })
    vim.keymap.set('n', '<leader>chq', ':ChapletEnd<CR>', { desc = 'End chaplet' })
    vim.keymap.set('n', '<leader>chs', ':ChapletPause<CR>', { desc = 'Pause chaplet' })
```

### Contributing

Contributions are welcome! Please open a pull request or issue to get started.

### Local Parish Support

If you find this plugin helpful, please consider supporting your local parish. 
