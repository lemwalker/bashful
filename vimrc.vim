set nocompatible

"set lazyredraw
set encoding=utf-8
syntax on
set t_Co=256
set background=dark
"colorscheme default "murphy

set number
set ruler
set cursorline

set autoindent
set smartindent
set smarttab
set shiftwidth=4
set tabstop=4       " Number of spaces a tab counts for in the file
set expandtab       " Replaces tabs with spaces
"set softtabstop     " This causes issues on WSL (as of 20190401)
"set ruler
set ttyfast     "screen updates smoother. assumes fast connection
"set showcmd
set list
set listchars=tab:→\ ,trail:·
set laststatus=2
set statusline=\ %F\ %w\ \ cwd:\ %r%{getcwd()}\ \ \ %=\ %m%r%h\ %04l:%-4c\ %02Bx
set hlsearch "highlight matches
set wildmenu
set ignorecase " case insensitive search
set smartcase  " searching uppercase char forces case-sensitive
set visualbell
set mouse=a

if &diff
    " ignore whitespace in vimdiff
    set diffopt+=iwhite
endif


" Highlighting
"   124:Red             210:light-Red           217:bright-Red
"   202:orange          208:light-orange        214:bright-orange
"   185:yellow          190:light-yellow        228:bright-yellow
"   40 :green           77 :light-green         120:bright-green
"   27 :blue            75 :light-blue          81 :bright-blue
"   44 :cyan            87 :light-cyan          123:bright-cyan
"   165:magenta         176:light-magenta       219:bright-magenta
"   16 :Black           213:white               233:Almost black
"   236:Dark Gray       242:darkish-Gray        244:medium-Gray
"   245:lightish-Gray   247:light-gray


hi StatusLine   ctermfg=16      ctermbg=71      cterm=None
hi StatusLineNC ctermfg=242     ctermbg=236     cterm=None
hi CursorLine   term=None       cterm=None
hi CursorLineNr ctermfg=230     ctermbg=None    cterm=None
hi Directory    ctermfg=76      ctermbg=None    cterm=None
hi LineNr       ctermfg=244     ctermbg=None    cterm=None
hi VertSplit    ctermfg=236     ctermbg=236     cterm=None
hi NonText      ctermfg=40      ctermbg=None    cterm=None
hi Cursor       ctermfg=124     ctermbg=None    cterm=None
hi SpecialKey   ctermfg=87      ctermbg=None    cterm=None
hi FoldColumn   ctermfg=247     ctermbg=None    cterm=Bold
hi DiffAdd      ctermfg=16      ctermbg=120     cterm=None
hi DiffDelete   ctermfg=16      ctermbg=217     cterm=None
hi DiffText     ctermfg=124     ctermbg=250     cterm=None
hi DiffChange   ctermfg=16      ctermbg=229     cterm=None

hi Search       ctermfg=236     ctermbg=226     cterm=None
hi Todo         ctermfg=233     ctermbg=118     cterm=Bold
hi ErrorMsg     ctermfg=124     ctermbg=252     cterm=None
hi WarningMsg   ctermfg=124     ctermbg=None    cterm=None
hi Identifier   ctermfg=71      ctermbg=None    cterm=Bold
hi Statement    ctermfg=75      ctermbg=None    cterm=None
hi Type         ctermfg=75      ctermbg=None    cterm=None
hi Constant     ctermfg=208     ctermbg=None    cterm=None
hi Comment      ctermfg=244     ctermbg=None    cterm=None
hi preproc      ctermfg=247     ctermbg=none    cterm=bold
hi String       ctermfg=208     ctermbg=None    cterm=None
hi Character    ctermfg=202     ctermbg=None    cterm=None
hi Number       ctermfg=176     ctermbg=None    cterm=None
hi Special      ctermfg=228     ctermbg=None    cterm=None
hi Operator     ctermfg=208     ctermbg=None    cterm=Bold
hi Error        ctermfg=16      ctermbg=124     cterm=Bold
hi Ignore       ctermfg=244     ctermbg=236     cterm=Bold
hi Underline    ctermfg=244     ctermbg=None    cterm=None

hi Pmenu        ctermfg=White       ctermbg=DarkGray    cterm=None
hi PmenuSel     ctermfg=None        ctermbg=Gray        cterm=Bold
hi PmenuSbar    ctermfg=DarkGray    ctermbg=DarkGray    cterm=None
hi PmenuThumb   ctermfg=Gray        ctermbg=Gray        cterm=None

