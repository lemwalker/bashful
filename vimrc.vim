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

set textwidth=0 " prevent wrapping after 78 columns

set splitright      "new files open on the right of the vertical split
set ttyfast     "screen updates smoother. assumes fast connection
"set showcmd
set list
set listchars=tab:→\ ,trail:·
set laststatus=2
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


" statusline
"set statusline=\ %F\ %w\ \ cwd:\ %r%{getcwd()}\ \ \ %=\ %m%r%h\ %04l:%-4c\ %02Bx

set statusline=
" Left section - file info
set statusline+=%#cDrk#\ 
"set statusline+=%-10(\[%{&fenc}\]%)\ 
set statusline+=%{'\['.(&fenc!=''?&fenc:&enc).'\]'}\ 
set statusline+=%24(%t%)

" modified flag
set statusline+=%{&mod?'*':'\ '}
" read only flag
set statusline+=%{&ro?'-':'\ '}
" single-byte mode indicator
set statusline+=%{mode()=='n'?'·':''}
set statusline+=%{mode()=='i'?'^':''}
set statusline+=%{mode()=='v'?'>':''}\ 
" Center section. set hi based on Insert/Normal  mode  or File mod flag %m
set statusline+=%#cGry#
set statusline+=\ %-12.48(%{getcwd()}%)\ 
set statusline+=%=
" Right section - cursor info
set statusline+=%#cDrk#\ 
" Syntax attributes. Useful for tweaking, but distracting
"set statusline+=%11.11(%{synIDattr(synIDtrans(synID(line(\".\"),col(\".\"),0)),\"name\")}%)\ 
"set statusline+=%-14.14(%{synIDattr(synID(line(\".\"),col(\".\"),0),\"name\")}%)\ 
set statusline+=%4l:%-3c\|\ 
set statusline+=%02Bx\ 

" Highlighting
"   124:Red             210:light-Red           217:bright-Red
"   202:orange          208:light-orange        214:bright-orange
"   185:yellow          190:light-yellow        228:bright-yellow
"   40 :green           77 :light-green         120:bright-green
"   63 :blue            75 :light-blue          81 :bright-blue
"   44 :cyan            87 :light-cyan          123:bright-cyan
"   165:magenta         176:light-magenta       219:bright-magenta
"   16 :Black           213:white               233:Almost black
"   236:Dark Gray       242:darkish-Gray        244:medium-Gray
"   245:lightish-Gray   247:light-gray

" two tone hilighting groups
hi def link cNml Normal
hi cRed ctermbg=52  ctermfg=217 cterm=none
hi cGrn ctermbg=22  ctermfg=157 cterm=none
hi cBlu ctermbg=17  ctermfg=147 cterm=none

hi cYlw ctermbg=100 ctermfg=227 cterm=none
hi cMag ctermbg=53  ctermfg=213 cterm=none
hi cCyn ctermbg=23  ctermfg=123 cterm=none

hi cOrn ctermbg=130 ctermfg=214 cterm=none
hi cMud ctermbg=94  ctermfg=222 cterm=none
hi cPlm ctermbg=89  ctermfg=211 cterm=none
hi cTrd ctermbg=64  ctermfg=193 cterm=none
hi cPur ctermbg=54  ctermfg=183 cterm=none
hi cBlg ctermbg=24  ctermfg=153 cterm=none

hi cDrk ctermbg=240 ctermfg=248 cterm=none
hi cGry ctermbg=248 ctermfg=240 cterm=none

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
hi Visual       cterm=reverse   ctermfg=none    ctermbg=none

hi Search       ctermfg=236     ctermbg=226     cterm=None
"hi Search       cterm=reverse,underline  ctermfg=none ctermbg=none
hi Todo         ctermfg=233     ctermbg=118     cterm=Bold
hi HelpNote     ctermfg=157     ctermbg=22      cterm=None
hi ErrorMsg     ctermfg=124     ctermbg=252     cterm=None
hi WarningMsg   ctermfg=124     ctermbg=None    cterm=None
hi MatchParen   ctermfg=23      ctermbg=252     cterm=Reverse
hi Identifier   ctermfg=71      ctermbg=None    cterm=Bold
hi Statement    ctermfg=75      ctermbg=None    cterm=None
hi Type         ctermfg=75      ctermbg=None    cterm=None
hi Constant     ctermfg=208     ctermbg=None    cterm=None
hi Comment      ctermfg=244     ctermbg=None    cterm=None
hi PreProc      ctermfg=247     ctermbg=None    cterm=Bold
hi String       ctermfg=208     ctermbg=None    cterm=None
hi Character    ctermfg=202     ctermbg=None    cterm=None
hi Number       ctermfg=176     ctermbg=None    cterm=None
hi Special      ctermfg=228     ctermbg=None    cterm=None
hi Operator     ctermfg=208     ctermbg=None    cterm=Bold
hi Error        ctermfg=16      ctermbg=124     cterm=Bold
hi Ignore       ctermfg=244     ctermbg=236     cterm=Bold
hi Underline    ctermfg=244     ctermbg=None    cterm=None
"hi Underlined   ctermfg=63          ctermbg=None        cterm=None
"hi Title        ctermfg=63          ctermbg=None        cterm=None
"hi Delimiter    ctermfg=247         ctermbg=None        cterm=None

hi Pmenu        ctermfg=White       ctermbg=DarkGray    cterm=None
hi PmenuSel     ctermfg=None        ctermbg=Gray        cterm=Bold
hi PmenuSbar    ctermfg=DarkGray    ctermbg=DarkGray    cterm=None
hi PmenuThumb   ctermfg=Gray        ctermbg=Gray        cterm=None

