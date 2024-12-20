-- Define leader key
vim.g.mapleader = " "

-- Basic settings
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.termguicolors = true
vim.opt.errorbells = false
vim.opt.title = true
vim.opt.autoindent = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.fixendofline = false
vim.opt.lazyredraw = true
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.omni_sql_no_default_maps = 1
vim.opt.guicursor = "n-v-c:block,i:hor10"
vim.opt.shortmess:append("I")

-- Clipboard copy
vim.api.nvim_set_keymap('v', '<leader>y', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>Y', '"+Y', { noremap = true, silent = true })

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
        event = "InsertEnter",
        dependencies = {
            {
                'mfussenegger/nvim-dap-python',
                config = function()
                    local python_path = vim.fn.system('which python3'):gsub("\n", "")

                    require('dap-python').setup(python_path)
                end,
            },
            {
                'rcarriga/nvim-dap-ui',
                dependencies = {
                    'nvim-neotest/nvim-nio',
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
            -- vim.api.nvim_set_keymap('n', '<leader>lp', ':lua require\'dap\'.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))<CR>', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>dr', ':lua require\'dap\'.repl.open()<CR>', { noremap = true, silent = true })
            vim.api.nvim_set_keymap('n', '<leader>dl', ':lua require\'dap\'.run_last()<CR>', { noremap = true, silent = true })
        end,
    },

  {
      "nvim-tree/nvim-tree.lua",
      version = "*",
      lazy = false,
      dependencies = {
          "nvim-tree/nvim-web-devicons",
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
  "tpope/vim-obsession",

  {
    "tpope/vim-surround",
    event = "VeryLazy"
  },

  -- Vim plugin for handling with databases
  { "tpope/vim-dadbod" },
  { 'kristijanhusak/vim-dadbod-ui' },
  { 'kristijanhusak/vim-dadbod-completion', ft = { 'sql', 'mysql', 'plsql' }, lazy = true },

  -- vim-go
  { 'fatih/vim-go', run = ':GoUpdateBinaries' },

  -- zen mode B)
  "folke/zen-mode.nvim",

  -- COPILOT
  "github/copilot.vim",

  -- Telescope
  { 'nvim-telescope/telescope.nvim', tag = '0.1.8', dependencies = { 'nvim-lua/plenary.nvim' } },
  { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' },
  'nvim-telescope/telescope-symbols.nvim',
  "benfowler/telescope-luasnip.nvim",

  -- Treesitter
  { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' },
  'nvim-treesitter/nvim-treesitter-context',

  -- Lualine
  'nvim-lualine/lualine.nvim',
  'kyazdani42/nvim-web-devicons', -- optional, for file icons

  -- Color scheme
  'folke/tokyonight.nvim',
  { "rose-pine/neovim", name = "rose-pine", config = function ()
      vim.cmd('colorscheme rose-pine-main')
  end },

  -- vim-tmux-navigator
  {
      "christoomey/vim-tmux-navigator",
      cmd = {
          "TmuxNavigateLeft",
          "TmuxNavigateDown",
          "TmuxNavigateUp",
          "TmuxNavigateRight",
          "TmuxNavigatePrevious",
      },
      keys = {
          { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
          { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
          { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
          { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
          { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
      },
  },

  -- Linter
  'mfussenegger/nvim-lint',

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

  {
    "Hoffs/omnisharp-extended-lsp.nvim",
    dependencies = { "neovim/nvim-lspconfig" },
  },


  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.nvim' }, -- if you use the mini.nvim suite
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'echasnovski/mini.icons' }, -- if you use standalone mini plugins
    -- dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' }, -- if you prefer nvim-web-devicons
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = {},
  },

  -- Autopairs (also lazy-load)
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",  -- Load when entering insert mode
  }
})

vim.g.go_def_mapping_enabled = 0
vim.o.completeopt = "menuone,noselect"
vim.g.tmux_navigator_disable_when_zoomed = 1

-- Mason
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "tailwindcss", "html", "htmx", "templ", "gopls", "pyright", "ts_ls","lua_ls", "emmet_language_server", "cssls" },
    automatic_installation = true,
})

-- Zenmode
require("zen-mode").setup({
    window = {
        width = 0.8,
        options = {
            number = false, -- Disable line numbers
            relativenumber = false, -- Disable relative numbers
            cursorline = false, -- Disable cursorline
        },
    },
    plugins = {
        options = {
            latstatus = 0,
        },
        tmux = { enabled = true },
    },
})

-- Autopairs setup
require('nvim-autopairs').setup{}

local function nvim_tree_on_attach(bufnr)
    local api = require('nvim-tree.api')

    local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    api.config.mappings.default_on_attach(bufnr)
    vim.keymap.del('n', '<C-]>', { buffer = bufnr })
    vim.keymap.del('n', 'C', { buffer = bufnr })
    vim.keymap.set('n', 'C', api.tree.change_root_to_node, opts('CD'))

end

require("nvim-tree").setup {
    on_attach = nvim_tree_on_attach,
    sort = {
        sorter = "case_sensitive",
    },
    view = {
        centralize_selection = true,
        number = true,
        relativenumber = true,
        -- float = {
        --     enable = true,             -- Enable floating window
        --     quit_on_focus_loss = true,
        --     open_win_config = {
        --         relative = "editor",     -- Relative to the entire editor
        --         border = "rounded",      -- Rounded border style for aesthetics
        --         width = vim.fn.round(vim.o.columns * 0.7),  -- 70% of the screen width
        --         height = vim.fn.round(vim.o.lines * 0.8),   -- 80% of the screen height
        --         row = vim.fn.round((vim.o.lines - vim.fn.round(vim.o.lines * 0.8)) / 2),  -- Center the row
        --         col = vim.fn.round((vim.o.columns - vim.fn.round(vim.o.columns * 0.7)) / 2), -- Center the column
        --     },
        -- },
        width = 30,
    },
    actions = {
        change_dir = {
            enable = true,                -- Enable the feature to change OS working directory
            global = true,                -- Set this to true to change the global working directory
            restrict_above_cwd = false,   -- Allow directory changes to parent directories
        },
    },
    renderer = {
        group_empty = true,
    },
    filters = {
        dotfiles = true,
    },
    live_filter = {
        always_show_folders = false,
    },
}

-- LSP settings
local lspconfig = require('lspconfig')
local cmp = require('cmp')
Luasnip = require('luasnip')
local telescope = require("telescope")


Luasnip.add_snippets("sql", {
  Luasnip.snippet("sel", {
    Luasnip.text_node("SELECT * FROM "),
    Luasnip.insert_node(1, "table_name"),
    Luasnip.text_node(";"),
  }),

  Luasnip.snippet("ins", {
    Luasnip.text_node("INSERT INTO "),
    Luasnip.insert_node(1, "table_name"),
    Luasnip.text_node(" ("),
    Luasnip.insert_node(2, "columns"),
    Luasnip.text_node(") VALUES ("),
    Luasnip.insert_node(3, "values"),
    Luasnip.text_node(");"),
  }),

  Luasnip.snippet("get_view_def", {
    Luasnip.text_node("SELECT pg_get_viewdef ('"),
    Luasnip.insert_node(1, "schema.view"),
    Luasnip.text_node("' , true);")
  })
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()
local on_attach = function(client, bufnr)
    -- Custom on_attach logic here
end

-- LSP servers setup
lspconfig.gopls.setup{}


lspconfig.omnisharp.setup{
    cmd = { "omnisharp", "--languageserver" },
    settings = {
        FormattingOptions = {
            EnableEditorConfigSupport = true,
            OrganizeImports = nil,
        },
        MsBuild = {
            LoadProjectsOnDemand = nil,
        },
        RoslynExtensionsOptions = {
            EnableAnalyzersSupport = nil,
            EnableImportCompletion = nil,
            AnalyzeOpenDocumentsOnly = nil,
        },
        Sdk = {
            IncludePrereleases = true,
        },
    },
    on_attach = function(client, bufnr)
        -- Helper function for buffer-local keymaps
        local buf_set_keymap = function(mode, key, action, desc)
            vim.api.nvim_buf_set_keymap(bufnr, mode, key, action, { noremap = true, silent = true, desc = desc })
        end

    -- Set omnisharp-extended keymaps
    buf_set_keymap('n', 'gd', "<cmd>lua require('omnisharp_extended').lsp_definition()<CR>", "Go to Definition (OmniSharp)")
    buf_set_keymap('n', 'gi', "<cmd>lua require('omnisharp_extended').lsp_implementation()<CR>", "Go to Implementation (OmniSharp)")
    buf_set_keymap('n', '<leader>K', "<cmd>lua require('omnisharp_extended').lsp_type_definition()<CR>", "Type Definition (OmniSharp)")
    buf_set_keymap('n', 'gr', "<cmd>lua require('omnisharp_extended').telescope_lsp_references()<CR>", "Find References (OmniSharp)")
    -- buf_set_keymap('n', 'gr', "nnoremap gr <cmd>lua require('omnisharp_extended').telescope_lsp_references()<cr>", "Find References (OmniSharp)")
    -- lua require('omnisharp_extended').telescope_lsp_references()

    -- Optional: Notify that OmniSharp is active
    print("OmniSharp LSP attached for buffer " .. bufnr)
    end,
    capabilities = capabilities
}

lspconfig.pyright.setup{
    on_attach = on_attach,
    capabilities = capabilities
}

lspconfig.ts_ls.setup{}

lspconfig.eslint.setup{
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "javascript" }
}

lspconfig.cssls.setup{
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "css" }
}

lspconfig.jsonls.setup{}

lspconfig.lua_ls.setup{}

lspconfig.sqlls.setup({
  on_attach = on_attach,
  filetypes = {"sql", "mysql"};
  root_dir = function() return vim.loop.cwd() end;
})

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

lspconfig.emmet_language_server.setup({
  filetypes = { "eruby", "html", "javascript", "javascriptreact", "less", "sass", "scss", "pug", "typescriptreact", "htmx" },
  init_options = {},
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
            Luasnip.lsp_expand(args.body)
        end,
    },
    mapping = {
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<C-n>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif Luasnip.expand_or_jumpable() then
                Luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<C-p>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif Luasnip.jumpable(-1) then
                Luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    },sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
    })
})

-- -- Add cmp for sql with vim-dadbod-completion
cmp.setup.filetype('sql', {
    sources = {
        { name = 'vim-dadbod-completion'},
        { name = 'buffer' },
    },
})

-- Make autopairs and completion work together
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
cmp.event:on(
  'confirm_done',
  cmp_autopairs.on_confirm_done()
)

require('lint').linters_by_ft = {
  javascript = { 'eslint' },
}

vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "BufEnter" }, {
    callback = function()
        require("lint").try_lint()
    end,
})


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
-- require('lualine').setup()
require('lualine').setup {
  options = {
    theme = 'tokyonight'
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'diff', 'diagnostics'},  -- Removed 'branch' from here
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  -- You can also customize the inactive sections similarly if needed
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  -- The rest of your configuration
}

-- Telescope setup
telescope.setup{
  defaults = {
    file_ignore_patterns = { "node_modules", ".git/", "%.min%.js$" },
    preview = {
        timeout = 200,
    },
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
pcall(require('telescope').load_extension, 'luasnip')

vim.api.nvim_set_keymap('n', '<leader>sp', '<cmd>Telescope luasnip<CR>', { noremap = true, silent = true })

-- REMAPS
-- Add <leader>t as create new tab 
vim.api.nvim_set_keymap('n', '<leader>t', ':tabnew<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>q', ':bd<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>w', ':w<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>o', '<cmd>DBUIToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>l', 'gt', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>h', 'gT', { noremap = true, silent = true })


-- greatest remap ever / ThePrimeagean
vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])
-- vim.api.nvim_set_keymap('i', '<C-c>', '<Esc>', { noremap = true, silent = true })
-- vim.keymap.del('i', '<C-c>')
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>fm", vim.lsp.buf.format)

vim.keymap.set("n", "<leader>j", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>cprev<CR>zz")

---- Map <Leader> + c to clear screen (redraw)
vim.api.nvim_set_keymap('n', '<leader>c', '<cmd>nohlsearch<CR>', { noremap = true, silent = true })

-- Function to toggle window zoom for each tab
function ToggleZoom()
  -- Check if the current tab is zoomed
  if not vim.t.zoomed then
    print("Zooming in!")
    -- Maximize the current window (Ctrl-w | and Ctrl-w _)
    vim.cmd('wincmd |')
    vim.cmd('wincmd _')
    vim.t.zoomed = true
  else
    print("Zooming out!")
    -- Restore window layout (Ctrl-w =)
    vim.cmd('wincmd =')
    vim.t.zoomed = false
  end
end

vim.api.nvim_set_keymap('n', '<c-w>z', ':lua ToggleZoom()<CR>', { noremap = true, silent = true })


-- Telescope key mappings
vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fw', '<cmd>Telescope find_files search_dir=.<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fh', '<cmd>Telescope help_tags<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>qq', '"zy:Telescope live_grep default_text=<C-r>z<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>fs', '<cmd>Telescope lsp_document_symbols<CR>', { noremap = true, silent = true })

-- Key binding for NvimTree
-- vim.api.nvim_set_keymap('n', '<leader>n', ':NvimTreeFind<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-t>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-f>', ':NvimTreeFindFile<CR>', { noremap = true, silent = true })

-- Zenmode keybindings
vim.keymap.set('n', '<leader>z', '<cmd>ZenMode<CR>')

-- LSP key mappings
-- vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>zz', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', 'gd', require('telescope.builtin').lsp_definitions)
vim.keymap.set('n', 'gr', require('telescope.builtin').lsp_references)
vim.keymap.set('n', 'K', vim.lsp.buf.hover)
-- vim.api.nvim_set_keymap('n', '<leader>ci', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>vrn', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true })
-- vim.api.nvim_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>vd', '<cmd>lua vim.diagnostic.enable(not vim.diagnostic.is_enabled())<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>x', '<cmd>lua vim.diagnostic.setloclist()<CR>', { noremap = true, silent = true })

-- Fugitive
-- -- Remap ]c to jump to the next change and center the screen
vim.api.nvim_set_keymap('n', ']c', ']czz', { noremap = true, silent = true })

-- Remap [c to jump to the previous change and center the screen
vim.api.nvim_set_keymap('n', '[c', '[czz', { noremap = true, silent = true })

-- Create an autocmd for highlighting yanked text
vim.api.nvim_set_hl(0, 'YankHighlight', { bg = '#FFA500', fg = '#000000' })
vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight yanked text',
    group = vim.api.nvim_create_augroup('YankHighlightGroup', { clear = true }),
    callback = function()
        vim.highlight.on_yank({ higroup = 'YankHighlight', timeout = 200 })
    end,
})


-- Set the commentstring for SQL filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = "sql",
  callback = function()
    vim.bo.commentstring = "--%s"
  end,
})

-- Function to toggle statusline visibility
local statusline_visible = true

function ToggleStatusline()
  if statusline_visible then
    vim.opt.laststatus = 0 -- Hide the statusline
    statusline_visible = false
  else
    vim.opt.laststatus = 2 -- Show the statusline (always visible)
    statusline_visible = true
  end
end

-- Map a key to toggle statusline
vim.keymap.set('n', '<leader>st', ToggleStatusline, { noremap = true, silent = true, desc = "Toggle Statusline" })

