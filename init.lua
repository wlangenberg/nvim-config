-- Define leader key
vim.g.mapleader = " "

-- Basic settings
vim.opt.relativenumber = true
vim.opt.errorbells = false
vim.opt.title = true
vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.fixendofline = false
vim.opt.lazyredraw = true



-- Clipboard copy
local is_windows = vim.loop.os_uname().sysname == 'Windows_NT'
local is_linux = vim.loop.os_uname().sysname == 'Linux'

-- if false or is_windows or is_linux then
--   -- Windows/WSL specific keybinding
--   vim.api.nvim_set_keymap('v', '<leader>y', ':w !clip.exe<CR><CR>', { noremap = true, silent = true })
--   vim.api.nvim_set_keymap('n', '<leader>Y', ':.w !clip.exe<CR><CR>', { noremap = true, silent = true })
-- else
  -- Unix/Linux specific keybinding
vim.api.nvim_set_keymap('v', '<leader>y', '"*y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>Y', '"*Y', { noremap = true, silent = true })
-- end

-- Plugin manager setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    defaults = { lazy = true },
	performance = {
		cache = {
			enabled = true,
		},
		rtp = {
			disabled_plugins = {
				"netrwPlugin",
				"gzip",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
	debug = false,
 
    {
        'mfussenegger/nvim-dap',
        event = "InsertEnter",  -- Lazy-load DAP when entering insert mode
        dependencies = {
            {
                'mfussenegger/nvim-dap-python',
                config = function()
                    -- Dynamically determine the Python path
                    local python_path = vim.fn.system('which python3'):gsub("\n", "") -- Get Python path and remove trailing newline

                    require('dap-python').setup(python_path)
                end,
            },
            {
                'rcarriga/nvim-dap-ui',
                dependencies = {
                    'nvim-neotest/nvim-nio',  -- Adding nvim-nio as a dependency
                },
                config = function()
                    require('dapui').setup()
                end,
            },
            {
                'theHamsta/nvim-dap-virtual-text',
                config = function()
                    require('nvim-dap-virtual-text').setup()
                end,
            }
        },
        config = function()
            -- Key mappings for DAP
            vim.api.nvim_set_keymap('n', '<F4>', ':lua require(\'dapui\').toggle()<CR>', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<F5>', ':lua require\'dap\'.continue()<CR>', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<F10>', ':lua require\'dap\'.step_over()<CR>', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<F11>', ':lua require\'dap\'.step_into()<CR>', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<F12>', ':lua require\'dap\'.step_out()<CR>', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>b', ':lua require\'dap\'.toggle_breakpoint()<CR>', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>B', ':lua require\'dap\'.set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>lp', ':lua require\'dap\'.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>dr', ':lua require\'dap\'.repl.open()<CR>', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>dl', ':lua require\'dap\'.run_last()<CR>', { noremap = true, silent = true })
        end,
    },
  -- Lazy-load NERDTree
  {
    'preservim/nerdtree',
    cmd = { "NERDTreeToggle", "NERDTreeFocus", "NERDTreeFind" },
    keys = {
      { "<leader>n", ":NERDTreeFind<CR>", noremap = true, silent = true },
      { "<C-n>", ":NERDTree<CR>", noremap = true, silent = true },
      { "<C-t>", ":NERDTreeToggle<CR>", noremap = true, silent = true },
      { "<C-f>", ":NERDTreeFind<CR>", noremap = true, silent = true }
    },
  },
  
  -- Lazy-load nvim-cmp and related plugins
  {
    'hrsh7th/nvim-cmp',
    event = "InsertEnter",  -- Load when entering insert mode
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-cmdline',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',
    }
  },
  
  -- fzf
  { 'junegunn/fzf', run = function() vim.fn['fzf#install']() end },
  'junegunn/fzf.vim',

  -- Add vim-obsession
  {
      "tpope/vim-obsession",
      config = function()
          -- Optional configuration can be added here
      end,
  },

  -- Vim surround for adding stuff around selections
  {
    "tpope/vim-surround",
    event = "VeryLazy"  -- This ensures the plugin is only loaded when needed
  },

  -- Vim plugin for handling with databases
  {
      "tpope/vim-dadbod",
      event = "VeryLazy"  -- Lazy load vim-dadbod too
  },
  {
      "kristijanhusak/vim-dadbod-ui",
      requires = {"tpope/vim-dadbod"},
      config = function()
          -- Optional: Set keybindings or other configurations
      end
  },
  {
      "kristijanhusak/vim-dadbod-completion",
      requires = {"tpope/vim-dadbod"},
      config = function()
          -- Optional: Set up completion configurations
      end
  },


  -- vim-go
  { 'fatih/vim-go', run = ':GoUpdateBinaries' },
  
  -- Telescope
  { 'nvim-telescope/telescope.nvim', tag = '0.1.8', dependencies = { 'nvim-lua/plenary.nvim' } },
  { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
  'nvim-telescope/telescope-symbols.nvim',
  
  -- Treesitter
  { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' },
  'nvim-treesitter/nvim-treesitter-context',
  
  -- Lualine
  'nvim-lualine/lualine.nvim',
  'kyazdani42/nvim-web-devicons', -- optional, for file icons

  -- Tokyo Night color scheme
  'folke/tokyonight.nvim',

  -- Diffview
  "sindrets/diffview.nvim",

  -- Git Fugitive
  'tpope/vim-fugitive',

  -- Vim Commentary
  'tpope/vim-commentary',

  -- Mason
  {
    "williamboman/mason.nvim",
    event = "BufReadPre",  -- Load Mason when a buffer is read
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "neovim/nvim-lspconfig",
    }
  },

  -- Autopairs (also lazy-load)
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",  -- Load when entering insert mode
  }
})

vim.g.go_def_mapping_enabled = 0

-- Set color scheme
vim.cmd[[colorscheme tokyonight]]

-- Disable native completion
vim.o.completeopt = "menuone,noselect"

-- Mason
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "tailwindcss", "html", "htmx", "templ", "gopls", "pyright", "tsserver" },
    automatic_installation = true,
})

-- Autopairs setup
require('nvim-autopairs').setup{}

-- LSP settings
local lspconfig = require('lspconfig')
local cmp = require('cmp')
local luasnip = require('luasnip')

-- LSP servers setup
lspconfig.gopls.setup{}
lspconfig.pyright.setup{}
lspconfig.tsserver.setup{}
-- lspconfig.html.setup{}

lspconfig.templ.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "templ" },
})

lspconfig.html.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "html", "templ" },
})

lspconfig.htmx.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "html", "templ" },
})

lspconfig.tailwindcss.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "templ", "astro", "javascript", "typescript", "react" },
    init_options = { userLanguages = { templ = "html" } },
})


vim.filetype.add({ extension = { templ = "templ" } })


-- nvim-cmp setup
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item.
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = cmp.config.sources({
    { name = 'vim-dadbod-completion' },
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
})

-- Make autopairs and completion work together
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

-- Treesitter setup
require('nvim-treesitter.configs').setup {
  ensure_installed = "all",
  highlight = {
    enable = true,
  },
}

-- Treesitter-context setup
require'treesitter-context'.setup{
  enable = true,
  throttle = true,
}

-- Lualine setup
require('lualine').setup()

-- Telescope setup
require('telescope').setup{
  defaults = {
    file_ignore_patterns = { "node_modules", ".git/" },
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
  },
}

pcall(require('telescope').load_extension, 'fzf')



-- REMAPS

-- greatest remap ever / ThePrimeagean
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
-- vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
-- vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])
vim.keymap.set("i", "<C-c>", "<Esc>")
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- vim.keymap.set("n", "<C-l>", "<cmd>cclose<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Telescope key mappings
vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fw', '<cmd>Telescope find_files search_dir=.<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('v', '<leader>qq', [[:<C-u>execute 'Telescope live_grep default_text=' . escape(@z, ' ')<CR>]], { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>qq', '"zy:Telescope live_grep default_text=<C-r>z<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fs', '<cmd>Telescope lsp_document_symbols<CR>', { noremap = true, silent = true })


-- Key binding for NERDTree
vim.api.nvim_set_keymap('n', '<leader>n', ':NERDTreeFind<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-n>', ':NERDTree<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-t>', ':NERDTreeToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-f>', ':NERDTreeFind<CR>', { noremap = true, silent = true })

-- LSP key mappings
vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>zz', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>ci', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', { noremap = true, silent = true })

-- Fugitive
-- -- Remap ]c to jump to the next change and center the screen
vim.api.nvim_set_keymap('n', ']c', ']czz', { noremap = true, silent = true })

-- Remap [c to jump to the previous change and center the screen
vim.api.nvim_set_keymap('n', '[c', '[czz', { noremap = true, silent = true })


-- Auto-source Session.vim if it exists
local session_file = vim.fn.getcwd() .. "/Session.vim"

if vim.fn.filereadable(session_file) == 1 then
  vim.cmd("source " .. session_file)
end

