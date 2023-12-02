-- Adapted from kickstart (https://github.com/nvim-lua/kickstart.nvim.git)

-- Set leader key (Space) (`:help mapleader`)
-- Must happen before plugins are required otherwise wrong leader will be used
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
--    https://github.com/folke/lazy.nvim (`:help lazy.nvim.txt`)
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- [[ PLUGINS ]]
-- Plugins can be configured with the `config` key or
-- after the setup call, since they will be available.
require('lazy').setup({

  -- Git related plugins
  --'tpope/vim-fugitive',
  --'tpope/vim-rhubarb',

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  {
    -- LSP Configuration & Plugins
    -- Configured below; search for lspconfig to find it
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', tag = 'legacy', opts = {} },
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',

      -- Adds buffer completion capabilities
      'hrsh7th/cmp-path',

      -- File path completions
      'hrsh7th/cmp-buffer',
      --
      -- Adds completion capabilities for Neovim config
      'hrsh7th/cmp-nvim-lua',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',
    },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },

  {
    -- Adds git-related signs to the gutter, as well as viewing changeset hunks
    'lewis6991/gitsigns.nvim',
    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      on_attach = function(bufnr)
        vim.keymap.set('n', '[c', require('gitsigns').prev_hunk,
              { buffer = bufnr, desc = 'Previous' })
        vim.keymap.set('n', ']c', require('gitsigns').next_hunk,
              { buffer = bufnr, desc = 'Next' })
        vim.keymap.set('n', '<leader>gh', require('gitsigns').preview_hunk,
              { buffer = bufnr, desc = '[G]it [H]unks' })
      end,
    },
  },

  {
    -- Themes
    -- lualine fails without nvim-base16 only if base16 is used
    'mcchrish/zenbones.nvim',
    dependencies = {
      'rktjmp/lush.nvim',
    },
    --'chriskempson/base16-vim',
    --dependencies = {
    --  'RRethy/nvim-base16',
    --},
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'zenwritten'
      --vim.cmd.colorscheme 'base16-tomorrow-night'
    end,
  },

  {
    -- Set lualine as statusline (:help lualine.txt)
    'nvim-lualine/lualine.nvim',
    opts = {
      options = {
        icons_enabled = false,
        theme = 'auto',
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_c = {
          {'filename', path = 3, file_status = true,},
        },
        lualine_x = {'filetype'},
      },
    },
  },

  {
    -- Add indentation guides (`:help indent_blankline.txt`)
    'lukas-reineke/indent-blankline.nvim',
    opts = {
      char = '┊',
      show_trailing_blankline_indent = false,
    },
  },

  {
    -- Replace colorcolumn with a text character (`:help virt-column.txt`)
    'lukas-reineke/virt-column.nvim',
    opts = {
      char = '┊',
    },
  },

  -- "gc" to comment visual regions/lines
  { 'numToStr/Comment.nvim', opts = {} },

  -- File explorer
  -- Configured below; search for nvim-tree to find it
  { 'nvim-tree/nvim-tree.lua', },

  {
    -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim'
    }
  },

  -- Fuzzy Finder Algorithm which requires local dependencies to be built.
  -- Only load if `make` is available. Make sure you have the system
  -- requirements installed.
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    --  If you are having trouble with this installation,
    --  refer to the README for telescope-fzf-native for more instructions.
    build = 'make',
    cond = function()
      return vim.fn.executable 'make' == 1
    end,
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  -- Terminal support
  { 'akinsho/toggleterm.nvim', version = "*", config = true }

  -- Additional kickstart plugins for autoformat and debug; currently disabled
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- Import plugins from `lua/custom/plugins/*.lua`
  --    See: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  -- { import = 'custom.plugins' },
}, {})

-- [[ OPTIONS ]]
-- To see what an option does, run `:help <option>`

-- Highlight current line
vim.opt.cursorline = true

-- Set visual bar at 80 characters
vim.o.colorcolumn = "80"

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 300
vim.o.timeout = true
vim.o.timeoutlen = 300

-- Highlight trailing characters
vim.opt.listchars = {
  tab = "▸ ",
  trail = "_",
}
vim.opt.list = true

-- Set completeopt to have a better completion experience
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force user to select one from the menu
vim.o.completeopt = 'menuone,noinsert,noselect'

-- Enable true colours if supported by the terminal
if vim.fn.has("termguicolors") == 1 then vim.o.termguicolors = true end

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Line Navigation Remaps
--   Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', 'H', '^')
vim.keymap.set('n', 'L', '$')

-- Terminal keymaps
vim.keymap.set('n', '<leader>t', '<Cmd>ToggleTerm direction=vertical size=100<CR>', { silent = true })
vim.keymap.set('n', '<leader>th', '<Cmd>ToggleTerm size=25<CR>', { silent = true })

vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], { silent = true })
vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], { silent = true })
vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], { silent = true })
vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], { silent = true })

-- Tabs and windows keymaps
vim.keymap.set('n', '<leader>n', ':tabnew<CR>', { silent = true })
vim.keymap.set('n', '<leader>b', ':tabp<CR>', { silent = true })
vim.keymap.set('n', '<leader>w', ':tabn<CR>', { silent = true })

vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Comment ]]
require('Comment').setup()
vim.keymap.set('n', '<leader>/',
    require("Comment.api").toggle.linewise.current, { desc = 'Toggle Comment' })
vim.keymap.set('v', '<leader>/',
    "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
    { desc = 'Toggle Comment' })

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>f', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })

vim.keymap.set('n', '<leader>sp', require('telescope.builtin').git_files, { desc = '[S]earch Git Files' })
vim.keymap.set('n', '<leader>sf', require('telescope.builtin').live_grep, { desc = '[S]earch [F]iles by grep' })
-- vim.keymap.set('n', '<leader>sg', require('telescope.builtin').find_files, { desc = '[S]earch Files' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').git_commits, { desc = '[S]earch git [H]istory' })
-- vim.keymap.set('n', '<leader>st', require('telescope.builtin').help_tags, { desc = '[S]earch Help [T]ags' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sc', require('telescope.builtin').colorscheme, { desc = '[S]earch [C]olours' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'vimdoc', 'vim' },

  -- Autoinstall languages that are not installed
  auto_install = false,

  highlight = { enable = true },
  indent = { enable = true, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- Function that lets us more easily define mappings for LSP-related items.
  -- It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('gt', vim.lsp.buf.type_definition, '[G]oto [T]ype')

  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('<C-\\>s', require('telescope.builtin').lsp_references, 'Find all References')

  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<leader>k', vim.lsp.buf.signature_help, 'Signature Documentation')
  nmap('<C-space>', vim.lsp.buf.hover, 'Hover Documentation')

  -- Lesser used LSP functionality
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers. They will automatically be installed.
local servers = {
  -- gopls = {},
  -- pyright = {},

  clangd = {},
  rust_analyzer = {
    cargo = {
      allFeatures = true,
    },
    checkOnSave = {
      -- default: `cargo check`
      command = "clippy",
      allFeatures = true
    },
  },
}

-- nvim-cmp has additional completion capabilities, so broadcast to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

-- [[ Configure nvim-cmp for Autocompletion ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = false,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'nvim_lua' },
    { name = 'buffer', keyword_length = 2 },
    { name = 'path' },
    { name = 'luasnip', keyword_length = 2 },
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
}

-- [[ Configure nvim-tree (File Explorer) ]]
local function nvim_tree_attach(bufnr)
    local api = require "nvim-tree.api"

    local function opts(desc)
      return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- default mappings
    -- api.config.mappings.default_on_attach(bufnr)

    -- custom mappings
    vim.keymap.set('n', '<CR>', api.node.open.edit,    opts('Open'))
    vim.keymap.set('n', 's', api.node.open.horizontal, opts('Open: Horizontal Split'))
    vim.keymap.set('n', 'v', api.node.open.vertical,   opts('Open: Vertical Split'))
    vim.keymap.set('n', 't', api.node.open.tab,        opts('Open: New Tab'))

    vim.keymap.set('n', 'a', api.fs.create,    opts('Create'))
    vim.keymap.set('n', 'c', api.fs.copy.node, opts('Copy'))
    vim.keymap.set('n', 'p', api.fs.paste,     opts('Paste'))
    vim.keymap.set('n', 'r', api.fs.rename,    opts('Rename'))
    vim.keymap.set('n', 'd', api.fs.remove,    opts('Delete'))
    vim.keymap.set('n', 'D', api.fs.trash,     opts('Trash'))

    vim.keymap.set('n', '<', api.tree.change_root_to_parent, opts('Up'))
    vim.keymap.set('n', '>', api.tree.change_root_to_node, opts('Down'))
    vim.keymap.set('n', '?', api.tree.toggle_help,         opts('Help'))
  end

require('nvim-tree').setup {
  disable_netrw = true,
  hijack_cursor = true,
  sync_root_with_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  view = {
    adaptive_size = false,
    side = "left",
    width = 35,
    preserve_window_proportions = true,
  },
  filesystem_watchers = {
    enable = true,
  },
  renderer = {
    add_trailing = true,
    indent_width = 2,
    icons = {
      show = {
        file = false,
        folder = true,
        folder_arrow = false,
        git = true,
        modified = false,
      },
      glyphs = {
        default = "",
        symlink = "",
        folder = {
          default = "●",
          open = "●",
          empty = "",
          empty_open = "",
          symlink = "➜",
          symlink_open = "➜",
        },
        git = {
          unstaged = "",
          staged = "",
          unmerged = "",
          renamed = "➜",
          untracked = "✗",
          deleted = "",
          ignored = "",
        },
      },
    },
  },
  on_attach = nvim_tree_attach,
}
vim.keymap.set('n', '<leader>e', '<Cmd>NvimTreeToggle<CR>', { desc = 'Toggle Explorer', silent = true })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
