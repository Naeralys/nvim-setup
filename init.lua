local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
	{
	  	"navarasu/onedark.nvim",
  		priority = 1000, -- Ensure it loads first
			config = function()
				require("onedark").setup {
					style = "dark",
					transparent = true
				}
				require("onedark").load()
			end
	}, 
		{
		"hrsh7th/nvim-cmp",
		},
		{
			"neovim/nvim-lspconfig",
			dependencies= {
				{
					"hrsh7th/cmp-nvim-lsp"
				}
			},
	},{
		"mason-org/mason.nvim",
    		opts = {}
	},
	{
    		"mason-org/mason-lspconfig.nvim",
    		opts = {},
    		dependencies = {
        	{ 
			"mason-org/mason.nvim", opts = {} },
        		"neovim/nvim-lspconfig",
    		},
	},
		{
    'nvim-telescope/telescope.nvim', tag = 'v0.1.9',
     dependencies = { 'nvim-lua/plenary.nvim' }
    },
		{
			"nvim-telescope/telescope-file-browser.nvim",
			dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" }
		},
		{
  		"nvim-treesitter/nvim-treesitter",
  		build = ":TSUpdate",
  		config = function()
    		local configs = require("nvim-treesitter.configs")
 
    		configs.setup({
      		ensure_installed = {
        		"c", "lua", "vim", "vimdoc", "elixir", "javascript", "html", "python", "typescript"
      		},
      		sync_install = false,
      		highlight = { enable = true },
      		indent = { enable = true },
    		})
  		end
		}
	  -- add your plugins here 
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { "onedark" } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})

-- Setup telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>p', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>f', builtin.live_grep, { desc = 'Telescope live grep' })

-- Telescope File Browser
vim.keymap.set('n', '<leader>o', ":Telescope file_browser<CR>")

vim.diagnostic.config({ virtual_text = true })

-- Set theme
vim.cmd("colorscheme onedark")
