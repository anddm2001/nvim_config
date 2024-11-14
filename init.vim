" Установите vim-plug
call plug#begin('~/.local/share/nvim/plugged')

" Плагины
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'puremourning/vimspector' " Для отладки
Plug 'sheerun/vim-polyglot'

" Установка nvim-tree.lua
Plug 'nvim-tree/nvim-web-devicons' " Для отображения иконок
Plug 'nvim-tree/nvim-tree.lua'

Plug 'akinsho/toggleterm.nvim', { 'tag': '*' }

Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'simrat39/symbols-outline.nvim'
Plug 'preservim/tagbar'
Plug 'romgrk/barbar.nvim'

" Темы и подсветка
Plug 'morhetz/gruvbox'
Plug 'folke/tokyonight.nvim'
Plug 'navarasu/onedark.nvim'

call plug#end()

" ========================================
" Аббревиатура командной строки: :q! -> :qa!
" ========================================

cnoreabbrev <expr> q! getcmdtype() == ':' && getcmdline() == 'q!' ? 'qa!' : 'q!'

" Настройки
syntax on
" Включение отображения номеров строк и относительных номеров
set number
" set relativenumber
set tabstop=4
set shiftwidth=4
set expandtab
set background=dark
colorscheme gruvbox

set foldmethod=syntax
set nofoldenable

" Настройка CoC для Go
let g:coc_global_extensions = ['coc-go']

autocmd BufWritePre *.go :silent! lua vim.lsp.buf.formatting_sync()

" Настройка Vimspector
nmap <F5> <Plug>VimspectorContinue
nmap <F10> <Plug>VimspectorStepOver
nmap <F11> <Plug>VimspectorStepInto
nmap <F12> <Plug>VimspectorStepOut

" Настройки для coc.nvim
" Вставьте ниже ваши существующие настройки plug или coc

" Клавиши для навигации в списке автодополнения
inoremap <silent><expr> <TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <silent><expr> <S-TAB> pumvisible() ? "\<C-p>" : "\<S-TAB>"

" Подтверждение выбора автодополнения через Enter
inoremap <silent><expr> <CR> pumvisible() ? coc#_select_confirm() : "\<CR>"

" Переключение относительной нумерации с помощью <Leader>rn
nnoremap <Leader>rn :set relativenumber!<CR>

" Включение автосохранения при выборе предложения
let g:coc_enable_locationlist = 1

" Установить позицию Tagbar справа и ширину 30
let g:tagbar_left = 0
let g:tagbar_width = 30

" Отключить автозапуск Tagbar при старте Neovim
let g:tagbar_autofocus = 0

" Настройки автодополнения
set completeopt=menuone,noinsert,noselect

lua << EOF
local colorschemes = { "gruvbox", "tokyonight", "onedark" }
local current = 1

function SwitchColorScheme()
  current = current + 1
  if current > #colorschemes then
    current = 1
  end
  vim.cmd("colorscheme " .. colorschemes[current])
  print("Цветовая схема: " .. colorschemes[current])
end
EOF

lua << EOF
-- Функция для настройки привязок клавиш при присоединении nvim-tree
local function my_on_attach(bufnr)
  local api = require('nvim-tree.api')

  -- Устанавливаем стандартные привязки клавиш
  api.config.mappings.default_on_attach(bufnr)

  -- Настраиваемые опции для привязок клавиш
  local opts = { buffer = bufnr, noremap = true, silent = true, nowait = true }

  -- Привязки клавиш для открытия файлов в новой вкладке
  vim.keymap.set('n', '<CR>', api.node.open.tab, opts)
  vim.keymap.set('n', 'o', api.node.open.tab, opts)
  vim.keymap.set('n', '<2-LeftMouse>', api.node.open.tab, opts)
end
EOF

" Настройка nvim-tree.lua
lua << EOF
require'nvim-tree'.setup {
  on_attach = my_on_attach,
  disable_netrw       = true,
  hijack_netrw        = true,
  auto_reload_on_write = true,
  update_cwd          = true,
  diagnostics = {
    enable = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    }
  },
  update_focused_file = {
    enable      = true,
    update_cwd  = true,
    ignore_list = {}
  },
  system_open = {
    cmd  = nil,
    args = {}
  },
  filters = {
    dotfiles = false,
    custom  = {}
  },
  view = {
    width = 20,
    side = 'left'
  },
  renderer = {
    icons = {
      glyphs = {
        default = '',
        symlink = '',
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌"
        },
        folder = {
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        }
      }
    }
  }
}
EOF

" ========================================
" Настройка toggleterm.nvim
" ========================================
lua << EOF
 require("toggleterm").setup{
  size = 10,
  open_mapping = [[<C-\>]],
  direction = 'horizontal',
  close_on_exit = true,
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  terminal_mappings = false,
  persist_size = true,
}

-- Создаём единственный экземпляр терминала и сохраняем его в глобальной переменной
  local Terminal = require("toggleterm.terminal").Terminal
  if _G.my_terminal == nil then
    _G.my_terminal = Terminal:new({
      direction = "horizontal",
      size = 15,
      close_on_exit = true,
      hidden = true,
      on_open = function(term)
        -- Устанавливаем фокус на окно терминала
         vim.api.nvim_set_current_win(term.window)
        -- Входим в режим вставки
        vim.cmd("startinsert!")
      end,
      on_close = function(term)
      -- Дополнительные действия при закрытии терминала (опционально)
      end,
    })
   end

-- Функция для переключения терминала
function _G.focus_or_toggle_terminal()
  if _G.my_terminal then
    _G.my_terminal:toggle()
    if _G.my_terminal:is_open() then
      -- Используем vim.defer_fn для задержки выполнения команд
      vim.defer_fn(function()
        vim.api.nvim_set_current_win(_G.my_terminal.window)
        vim.cmd("startinsert!")
      end, 20) -- Задержка в миллисекундах (например, 20 мс)
    end
  else
    print("Terminal instance not found!")
  end
end
EOF

" ========================================
" Функции для фокусировки на определённых окнах
" ========================================
lua << EOF
-- Функция для фокусировки на окне по filetype
function FocusWindowByFiletype(filetype)
  local windows = vim.api.nvim_list_wins()
  for _, win in ipairs(windows) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
    if ft == filetype then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
  print("Окно с filetype '" .. filetype .. "' не найдено.")
end

-- Функции для фокусировки на конкретных окнах
   function FocusNvimTree()
     FocusWindowByFiletype('NvimTree')
   end

   function FocusMainEditor()
    local windows = vim.api.nvim_list_wins()
    for _, win in ipairs(windows) do
      local buf = vim.api.nvim_win_get_buf(win)
      local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
      if ft ~= 'NvimTree' and ft ~= 'toggleterm' then
        vim.api.nvim_set_current_win(win)
        return
      end
    end
    print("Основное окно редактора не найдено.")
   end

   function FocusTerminal()
    FocusWindowByFiletype('toggleterm')
   end

   -- Фокусировка на Tagbar
-- function FocusTagbar()
--  FocusWindowByFiletype('tagbar')
-- end

function FocusTagbar()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.api.nvim_buf_get_option(buf, 'filetype')
    if ft == 'tagbar' then
      vim.api.nvim_set_current_win(win)
      return
    end
  end
  print("Окно Tagbar не найдено.")
end

-- Функция для закрытия всех вкладок правее текущей
function CloseTabsToRight()
  local current_tab = vim.fn.tabpagenr()
  local total_tabs = vim.fn.tabpagenr('$')
  for tab = total_tabs, current_tab + 1, -1 do
    vim.cmd('tabclose ' .. tab)
  end
end

-- Функция для закрытия всех вкладок левее текущей
function CloseTabsToLeft()
  local current_tab = vim.fn.tabpagenr()
  for tab = current_tab - 1, 1, -1 do
    vim.cmd('tabclose ' .. tab)
  end
end
EOF

" ========================================
" Горячие клавиши
" ========================================

" В нормальном режиме
nnoremap <silent> <F1> :lua FocusNvimTree()<CR>
nnoremap <silent> <F2> :lua FocusMainEditor()<CR>
nnoremap <silent> <F3> :lua FocusTerminal()<CR>
nnoremap <silent> <F4> :lua _G.focus_or_toggle_terminal()<CR>
nnoremap <silent> <F5> :lua FocusTagbar()<CR>
nnoremap <silent> <F6> :TagbarToggle<CR>
nnoremap <silent> <F7> :registers<CR>

" В терминальном режиме
tnoremap <silent> <F1> <C-\><C-n>:lua FocusNvimTree()<CR>
tnoremap <silent> <F2> <C-\><C-n>:lua FocusMainEditor()<CR>
tnoremap <silent> <F3> <C-\><C-n>:lua FocusTerminal()<CR>
tnoremap <silent> <F4> <C-\><C-n>:lua _G.focus_or_toggle_terminal()<CR>
tnoremap <silent> <F5> <C-\><C-n>:lua FocusTagbar()<CR>
tnoremap <silent> <F6> <C-\><C-n>:TagbarToggle<CR>
tnoremap <silent> <F7> <C-\><C-n>:registers<CR>

" Копирование в системный буфер обмена с помощью Alt+C
" В визуальном режиме
vnoremap <A-c> "+y

" В нормальном режиме копирование строки
nnoremap <A-c> "+yy

" Вставка из системного буфера обмена с помощью Alt+V
" В нормальном режиме
nnoremap <A-v> "+p

" В режиме вставки
inoremap <A-v> <C-r><C-o>+

" В командном режиме
cnoremap <A-v> <C-r>+

" Вырезание в системный буфер обмена с помощью Alt+X
" В визуальном режиме
vnoremap <A-x> "+d

" В нормальном режиме вырезание строки
nnoremap <A-x> "+dd

" Назначение горячих клавиш для команд vim-go

" F8 - Перейти к определению (GoDef)
nnoremap <silent> <F8> :GoDef<CR>

" F9 - Открыть список объявлений в текущем файле (GoDecls)
nnoremap <silent> <F9> :GoDecls<CR>

" F10 - Открыть список объявлений в проекте (GoDeclsDir)
nnoremap <silent> <F10> :GoDeclsDir<CR>

" F11 - Показать все места использования символа (GoReferrers)
nnoremap <silent> <F11> :GoReferrers<CR>

" F12 - Показать все функции, которые вызывают текущую (GoCallers)
nnoremap <silent> <F12> :GoCallers<CR>

" Shift+F8 - Показать все функции, вызываемые из текущей (GoCallees)
nnoremap <silent> <S-F8> :GoCallees<CR>

" Переключение на следующий буфер
nnoremap <silent> <Tab> :BufferNext<CR>

" Переключение на предыдущий буфер
nnoremap <silent> <S-Tab> :BufferPrevious<CR>

" Закрытие текущего буфера
nnoremap <silent> <Leader>bd :BufferClose<CR>

" Закрыть текущую вкладку по Ctrl+W
nnoremap <silent> <C-w> :tabclose<CR>

" Закрыть все вкладки, кроме текущей, по Ctrl+Alt+W
nnoremap <silent> <C-A-w> :tabonly<CR>

" Назначение горячей клавиши Ctrl+Shift+W
nnoremap <silent> <C-S-w> :call CloseTabsToRight()<CR>

" Назначение горячей клавиши Ctrl+Shift+L
nnoremap <silent> <C-S-l> :call CloseTabsToLeft()<CR>

" Переключение цветовой схемы с помощью <Leader>cs
nnoremap <silent> <Leader>cs :lua SwitchColorScheme()<CR>

" ========================================
" Автоматическое открытие nvim-tree и toggleterm при запуске NeoVIM (IDE режим)
" ========================================
lua << EOF
function Open_IDE_Mode()
  -- Открыть файловый обозреватель
  require'nvim-tree.api'.tree.open()

  -- Открыть терминал
  _G.focus_or_toggle_terminal()

  -- Открыть Tagbar
  -- vim.cmd('TagbarOpen')

  -- Отложить настройку окон, чтобы они открылись корректно
  vim.defer_fn(function()
    -- Перемещаем фокус на nvim-tree
    FocusNvimTree()
  end, 100) -- Задержка 100 миллисекунд
end

-- Проверяем, есть ли аргументы при запуске NeoVim
if vim.fn.argc() == 0 then
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = Open_IDE_Mode
  })
end
EOF

lua << EOF
-- Функция для настройки режима IDE в новой вкладке
function TabOpen_IDE_Mode()
  -- Открыть файловый обозреватель NvimTree
  require('nvim-tree.api').tree.open()

  -- Переместить фокус на основное окно редактора
  FocusMainEditor()

  -- Открыть терминал
  _G.focus_or_toggle_terminal()
end

-- Автокоманда для запуска режима IDE при входе в новую вкладку
vim.api.nvim_create_autocmd("TabEnter", {
  callback = function()
    -- Проверяем, инициализирован ли режим IDE в текущей вкладке
    if vim.t.ide_mode_initialized == nil then
      vim.t.ide_mode_initialized = true
      -- Откладываем выполнение функции, чтобы вкладка успела полностью загрузиться
      vim.schedule(function()
        TabOpen_IDE_Mode()
      end)
    end
  end
})
EOF


" ========================================
" Автоматическое закрытие NeoVim при закрытии последних буферов
" ========================================

lua << EOF
vim.api.nvim_create_autocmd("BufDelete", {
  pattern = "*",
  callback = function()
    -- Определяем специальные типы файлов
    local special_filetypes = { ["NvimTree"] = true, ["toggleterm"] = true }

    -- Получаем список всех открытых буферов, которые отмечены как "buflisted"
    local buffers = vim.fn.getbufinfo({buflisted = 1})
    local non_special_buffers = 0

    -- Считаем количество буферов, которые не являются специальными
    for _, buf_info in ipairs(buffers) do
      if not special_filetypes[buf_info.filetype] then
        non_special_buffers = non_special_buffers + 1
      end
    end

    -- Если не осталось не-специальных буферов, закрываем NeoVim
    if non_special_buffers == 0 then
      vim.cmd('qa!')
    end
  end
})
EOF

" Настройка горячих клавиш для nvim-tree.lua
nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>e :NvimTreeFocus<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>f :NvimTreeFindFile<CR>


