set nocompatible

"set lazyredraw
set encoding=utf-8
syntax on
set t_Co=256
set background=dark
"colorscheme default
set number
set ruler
set cursorline

set autoindent
set smartindent
set smarttab
set shiftwidth=4
set tabstop=4       " Number of spaces a tab counts for in the file
set expandtab       " Replaces tabs with spaces
set backspace=indent,eol,start
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
"set mouse=a

if &diff
    " ignore whitespace in vimdiff
    set diffopt+=iwhite
endif

" Highlighting
hi Normal       ctermfg=253         ctermbg=235     cterm=None
hi LineNr       ctermfg=244         ctermbg=None    cterm=None
hi Comment      ctermfg=244         ctermbg=None    cterm=None
hi Underline    ctermfg=244         ctermbg=None    cterm=None
hi CursorLineNr ctermfg=230         ctermbg=None    cterm=None
hi Number       ctermfg=177         ctermbg=None    cterm=None
hi NonText      ctermfg=43          ctermbg=None    cterm=None
hi Statement    ctermfg=43          ctermbg=None    cterm=None
hi Operator     ctermfg=43          ctermbg=None    cterm=Bold
hi Identifier   ctermfg=39          ctermbg=None    cterm=Bold
hi Type         ctermfg=39          ctermbg=None    cterm=None
hi WarningMsg   ctermfg=161         ctermbg=None    cterm=None
hi Cursor       ctermfg=161         ctermbg=None    cterm=None
hi Character    ctermfg=202         ctermbg=None    cterm=None
hi FoldColumn   ctermfg=208         ctermbg=None    cterm=Bold
hi String       ctermfg=208         ctermbg=None    cterm=None
hi Special      ctermfg=208         ctermbg=None    cterm=None
hi Constant     ctermfg=228         ctermbg=None    cterm=None
hi SpecialKey   ctermfg=228         ctermbg=None    cterm=None
hi PreProc      ctermfg=228         ctermbg=None    cterm=Bold
hi Visual       ctermfg=None        ctermbg=None    cterm=Reverse
hi Ignore       ctermfg=244         ctermbg=236     cterm=Bold
hi CursorLine   ctermfg=None        ctermbg=235     cterm=None
hi MatchParen   ctermfg=253         ctermbg=23      cterm=None
hi Error        ctermfg=16          ctermbg=131     cterm=Bold
hi Pmenu        ctermfg=250         ctermbg=241     cterm=None
hi PmenuSel     ctermfg=None        ctermbg=244     cterm=Bold
hi VertSplit    ctermfg=236         ctermbg=236     cterm=None
hi StatusLine   ctermfg=244         ctermbg=237     cterm=None
hi StatusLineNC ctermfg=241         ctermbg=235     cterm=None
hi PmenuSbar    ctermfg=241         ctermbg=241     cterm=None
hi PmenuThumb   ctermfg=244         ctermbg=244     cterm=None
hi Todo         ctermfg=142         ctermbg=241     cterm=Reverse
hi Search       ctermfg=16          ctermbg=228     cterm=None
hi ErrorMsg     ctermfg=131         ctermbg=252     cterm=None
hi HelpNote     ctermfg=43          ctermbg=22      cterm=None
hi DiffAdd      ctermfg=16          ctermbg=120     cterm=None
hi DiffDelete   ctermfg=16          ctermbg=217     cterm=None
hi DiffText     ctermfg=131         ctermbg=250     cterm=None
hi DiffChange   ctermfg=16          ctermbg=229     cterm=None


" statusline
set statusline=
" set color
set statusline+=%#StatusLineNC#
set statusline+=(%n)\ %y\ %#StatusLine# " %n-buffer number, %y file type
"   " F file path ,file name , tail (basename)
set statusline+=\ %(%F%{&mod?'*':'\ '}%)\   " %F-file path with trailing asterisk when file is modified
"set statusline+=\ %-60(%F%{&mod?'*':'\ '}%)\ 
" read only flag
"set statusline+=%{&ro?'-':'\ '}
"" single-byte mode indicator
"set statusline+=%{mode()=='n'?'N':''}
"set statusline+=%{mode()=='i'?'I':''}
"set statusline+=%{mode()=='v'?'V':''}
" Right section - cursor info
set statusline+=%=
set statusline+=\ %64(%{getcwd()}%)\   " pwd
"" Syntax attributes. Useful for tweaking, but distracting
"set statusline+=[
"set statusline+=%14.14(%{synIDattr(synIDtrans(synID(line(\".\"),col(\".\"),0)),\"name\")}%)\ 
"set statusline+=%-14.14(%{synIDattr(synID(line(\".\"),col(\".\"),0),\"name\")}%)\ 
"set statusline+=]
"" file encoding
"set statusline+=%-10(\[%{&fenc}\]%)\ 
"set statusline+=%{'\['.(&fenc!=''?&fenc:&enc).'\]'}\ 
"set statusline+=Line\ %l\ of\ %L\ 
"set statusline+=%L\ 
" percent of file
"set statusline+=%p%%\ 
" line and column of cursor %4d:%-3d , l , c
"set statusline+=%#StatusLine#\ 
set statusline+=%#StatusLineNC#
set statusline+=%4l:%-3c
" current character in hexadecimal
set statusline+=%#StatusLineNC#\ 
set statusline+=%02Bx\ 

"" simple statusline
"set statusline=\ %F\ %w\ %=\ %m%r%h\ \|\ %4l:%-3c\ \|%02Bx\|\ 

