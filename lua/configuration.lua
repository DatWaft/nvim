-- =================
-- CONFIGURATION.LUA
-- =================
-- Created by: datwaft [github.com/datwaft]

-- ===================
-- Variable definition
-- ===================
   local configuration_folder = "$HOME/.config/nvim/"
--- ==================
--- Header declaration
--- ==================
   require('vimp')

-- ====================
-- NeoVim Configuration
-- ====================
   vim.g.python3_host_prog = '/usr/bin/python3'
   vim.g.python_host_prog = '/usr/bin/python'
-- ====================
-- Visual configuration
-- ====================
   -- Line numbers
   -- ============
      do local number = true
         vim.o.number = number
         vim.wo.number = number
      end
      do local relativenumber = true
         vim.o.relativenumber = relativenumber
         vim.wo.relativenumber = relativenumber
      end
   -- Syntax highlighting
   -- ===================
      -- Enable plugin syntax
      vim.cmd [[ filetype plugin indent on ]]
      -- Enable syntax highlighting
      vim.cmd [[ syntax enable ]]
   -- Search highlighting
   -- ===================
      vim.o.incsearch = true
      vim.o.hlsearch = false
   -- Split configuration
   -- ===================
      -- Auto resize splits when window is resized
      vim.cmd [[ autocmd VimResized * wincmd = ]]
   -- Conceal configuration
   -- =====================
      vim.wo.concealcursor = ''
   -- Status
   -- ======
      vim.o.showmode = false
-- ======================
-- Terminal configuration
-- ======================
   -- Activate mouse
   vim.o.mouse = 'a'
-- ====================
-- Editor configuration
-- ====================
   -- File configuration
   -- ==================
      -- Don't write backups
      vim.o.backup = false
      vim.o.writebackup = false
      -- No swap file
      do local swapfile = false
         vim.o.swapfile = swapfile
         vim.bo.swapfile = swapfile
      end
   -- Encoding configuration
   -- ======================
      vim.o.encoding = 'utf-8'
   -- Indentation configuration
   -- =========================
      -- Use spaces instead of tabs
      do local expandtab = true
        vim.o.expandtab = expandtab
        vim.bo.expandtab = expandtab
      end
      -- More intelligent tabulation
     vim.o.smarttab = true
      -- Number of spaces that a <Tab> counts for
      do local tabstop = 3
        vim.o.tabstop = tabstop
        vim.bo.tabstop = tabstop
      end
      -- Number of spaces used for autoindent
      do local shiftwidth = vim.o.tabstop
        vim.o.shiftwidth = shiftwidth
        vim.bo.shiftwidth = shiftwidth
      end
      -- Number of spaces a <Tab> counts for
      do local softtabstop = vim.o.tabstop
        vim.o.softtabstop = softtabstop
        vim.bo.softtabstop = softtabstop
      end
      -- Copy indent from current line when starting a new line
      do local autoindent = true
        vim.o.autoindent = autoindent
        vim.bo.autoindent = autoindent
      end
   -- Wrapping configuration
   -- ======================
      -- TODO
   -- Format configuration
   -- ====================
      -- Set format options
      do local formatoptions = 'qj'
         vim.o.formatoptions = formatoptions
         vim.bo.formatoptions = formatoptions
      end
   -- Spellcheking configuration
   -- ==========================
      -- Set languages
      do local spelllang = 'en,es'
         vim.o.spelllang = spelllang
         vim.bo.spelllang = spelllang
      end
   -- Undo persistance
   -- ================
      vim.o.undodir = configuration_folder .. "undodir.vim"
      do local undofile = true
         vim.o.undofile = undofile
         vim.bo.undofile = undofile
      end
-- ========================
-- Completion configuration
-- ========================
   -- Insert-mode completion
   -- ======================
      -- The case of the completion is inferred
      vim.o.infercase = true
      -- Function to check if there is a space behind de cursor
      function check_back_space()
         local col = vim.fn.col('.') - 1
         local line = vim.fn.getline('.')
         local char = string.sub(line, col, col)
         return col == 0 or string.find(char, '%s')
      end
      -- Using <Tab> for triggering completion
      vimp.inoremap({'silent', 'expr'}, '<Tab>', function()
         if vim.fn.pumvisible() == 1 then
            return [[<C-n>]]
         elseif vim.fn['coc#expandableOrJumpable']() then
            return [[<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])<CR>]]
         elseif check_back_space() then
            return [[<Tab>]]
         else
            return vim.fn['coc#refresh']()
         end
      end)
      -- Using <Tab> and <S-Tab> for navigating completion list
      vimp.inoremap({'expr'}, '<S-Tab>', function()
         if vim.fn.pumvisible() == 1 then
            return [[<C-p>]]
         else
            return [[<S-Tab>]]
         end
      end)
      -- Using <space> to confirm completion
      vimp.inoremap({'silent', 'expr'}, '<space>', function()
         if vim.fn.pumvisible() == 1 then
            return vim.fn['coc#_select_confirm']()
         else
            return [[<space>]]
         end
      end)
   -- Command-mode completion
   -- =======================
      -- Enable wildmenu
      vim.o.wildmenu = true
      -- Set wildmenu opening character to <Tab>
      vim.o.wildcharm = 9
      -- Wildmenu ignores case
      vim.o.wildignorecase = true
      -- Use <space> to confirm completion
      vim.cmd [[ cnoremap <expr> <space> wildmenumode() ? "\<C-y>" : "\<space>" ]]
-- =====================
-- Command configuration
-- =====================
   -- Search and replace
   -- ==================
      -- Ignore case in search patterns
      vim.o.ignorecase = true
      -- Smart case in search patterns
      vim.o.smartcase = true
   -- Substitution
   -- ============
      -- Always use global substitution
      vim.o.gdefault = true
-- =============
-- Miscellaneous
-- =============
   -- Toggle pasting
   vim.o.pastetoggle = '<F3>'
   -- Better diffing
   vim.o.diffopt = 'filler,internal,algorithm:histogram,indent-heuristic'
   -- Backspace
   vim.o.backspace = 'indent,eol,start'
   -- Lazyredraw
   vim.o.lazyredraw = true
   -- Hidden
   vim.o.hidden = true
   -- Easy jumps to another file
   vim.o.path = vim.o.path .. '**'
   -- Autoread when file changes on disk
   do local autoread = true
      vim.o.autoread = autoread
      vim.bo.autoread = autoread
   end
   vim.cmd [[ autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' && !bufexists("[Command Line]") | checktime | endif ]]
   -- Notification after change on disk
   vim.cmd [[ autocmd FileChangedShellPost * echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None]]
   -- Open file on last position
   if vim.fn.has('autocmd') == 1 then
      vim.cmd [[ au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif ]]
   end
   -- Open file unfolded
   vim.cmd [[ au BufRead * normal zR ]]
-- ============
-- Text Objects
-- ============
   -- TODO
-- =================
-- Keyboard bindings
-- =================
   -- TODO
