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
					style = "cool",
					transparent = true
				}
				require("onedark").load()
			end
		}, 
		{
			"hrsh7th/nvim-cmp",
			config = function()
				local cmp = require("cmp")
				cmp.setup({
					sources = {
						{ name = "nvim_lsp" }
					},
					
					mapping = cmp.mapping.preset.insert({
						-- Navigate between completion items
						['<C-p>'] = cmp.mapping.select_prev_item({ behavior = 'select' }),
						['<C-n>'] = cmp.mapping.select_next_item({ behavior = 'select' }),

						-- "Enter" key to confirm completion
						['<CR>'] = cmp.mapping.confirm({ select = false }),
						
						-- CTRL+Space to trigger completion menu
						['<C-Space>'] = cmp.mapping.complete(),
		
						-- Scroll up and down in the completion documentation
						['<C-u>'] = cmp.mapping.scroll_docs(-4),
						['<C-d>'] = cmp.mapping.scroll_docs(4),
					}),
					
					snippet = {
						expand = function(args)
							vim.snippet.expand(args.body)
						end,
					}
				})
			end,
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
    	dependencies = {
				"williamboman/mason-lspconfig.nvim",
			},
			config = function()
				require("mason").setup()
				require("mason-lspconfig").setup({
					
					-- LSP PACKAGES, LOOK HERE IF YOU MISS A LANGUAGE LSP
					ensure_installed = {
						"bashls",
						"eslint",
						"jsonls",
						"lua_ls",
						"pyright",
						"ts_ls",
						"clangd"
					},
					automatic_installation = true,
				})
			end
		},
		{
    	"mason-org/mason-lspconfig.nvim",
    	opts = {},
    	dependencies = {
      	{ 
					"mason-org/mason.nvim", opts = {} 
				},
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
        		"c", "rust", "lua", "vim", "vimdoc", "elixir", "javascript", "html", "python", "typescript"
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

-- LSP enable typescript
vim.lsp.config.typescript = {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = { "javascript", "typescript", "typescriptreact", "javascriptreact" },
	root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
	settings = {
		typescript = {
			inlayHints = inlayHints,
		},
		javascript = {
			inlayHints = inlayHints
		}
	}
}

vim.lsp.enable("typescript")
vim.lsp.enable("c")
vim.lsp.enable("rust")

-- Set theme
vim.cmd("colorscheme onedark")
