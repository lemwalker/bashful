set number
"colorscheme grayvim "murphy
colorscheme default
set background=dark
"highlight LineNr ctermfg=lightGrey
"highlight CursorLineNr ctermfg=White ctermbg=Black


set t_Co=256
set ttyfast     "screen updates smoother. assumes fast connection

set listchars=tab:→\ ,trail:·
set laststatus=2
set statusline=\ %F\ %w\ \ cwd:\ %r%{getcwd()}\ \ \ %=\ %m%r%h\ %04l:%-4c\ %02Bx
set list
set tabstop=4       "number of spaces a tab counts for in the file
set softtabstop=4   "number of spaces a tab counts for in insert mode
set expandtab       "replaces tab character with spaces. use :set noexpandtab to turn off

if &diff
" ignore whitespace in vimdiff
set diffopt+=iwhite
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" https://github.com/vim-scripts/256-grayvim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi Normal       ctermfg=253         ctermbg=235         cterm=None
hi Cursor       ctermfg=124         ctermbg=None        cterm=None
hi SpecialKey   ctermfg=87          ctermbg=None        cterm=Bold
hi Directory    ctermfg=71          ctermbg=None        cterm=None
hi ErrorMsg     ctermfg=124         ctermbg=252         cterm=None
hi PreProc      ctermfg=244         ctermbg=None        cterm=Bold
hi Search       ctermfg=16          ctermbg=226         cterm=None
hi Type         ctermfg=75          ctermbg=None        cterm=Bold " 75 (keywords)
hi Statement    ctermfg=75          ctermbg=None        cterm=None
hi Identifier   ctermfg=71          ctermbg=None        cterm=Bold " 105
hi Comment      ctermfg=244         ctermbg=None        cterm=None
hi DiffText     ctermfg=124         ctermbg=250         cterm=None  "red on grey
hi DiffAdd      ctermfg=16          ctermbg=120         cterm=None  "black on light-green
hi DiffDelete   ctermfg=16          ctermbg=219         cterm=None  "black on light-red
hi DiffChange   ctermfg=16          ctermbg=229         cterm=None  "black on light-yellow
hi Constant     ctermfg=208         ctermbg=None        cterm=None
hi String       ctermfg=215         ctermbg=None        cterm=None  " 208 (dark orange)
hi Number       ctermfg=176         ctermbg=None        cterm=None
hi Todo         ctermfg=16          ctermbg=118         cterm=Bold
hi Error        ctermfg=16          ctermbg=124         cterm=Bold
hi Special      ctermfg=193         ctermbg=None        cterm=Bold  " sh: [[ ]] sql: FROM, WHERE, INTO, ON
hi Operator     ctermfg=208         ctermbg=None        cterm=Bold
hi Ignore       ctermfg=244         ctermbg=236         cterm=Bold
hi Underline    ctermfg=244         ctermbg=None        cterm=None

hi FoldColumn   ctermfg=247         ctermbg=None        cterm=Bold
hi StatusLine   ctermfg=16          ctermbg=71         cterm=None  " line at the bottom
hi StatusLineNC ctermfg=244         ctermbg=236         cterm=None  " non-active status line
hi VertSplit    ctermfg=178         ctermbg=234         cterm=Bold

hi LineNr       ctermfg=247         ctermbg=235         cterm=Bold
"hi def link LineNr Normal

hi NonText      ctermfg=87          ctermbg=None        cterm=Bold
hi WarningMsg   ctermfg=196         ctermbg=None        cterm=None

hi Pmenu        ctermfg=White       ctermbg=DarkGray    cterm=None
hi PmenuSel     ctermfg=None        ctermbg=Gray        cterm=Bold
hi PmenuSbar    ctermfg=DarkGray    ctermbg=DarkGray    cterm=None
hi PmenuThumb   ctermfg=Gray        ctermbg=Gray        cterm=None

autocmd FileType sql  setlocal shiftwidth=2 softtabstop=2 expandtab
" sql specific

"syn keyword sqlSpecial contained dual
"syn match   sqlFunction     "\<\(abs\|avg\|count\|max\|min\|sum\)(\@="
"syn match   sqlFunction     "\<\(abs\|acos\|asin\|atan2\?\|avg\|cardinality\)(\@="
"syn match   sqlFunction     "\<\(to_char\|to_date\|to_number\|total\|trim\|trunc\|typeof\)(\@="
"syntax keyword sqlFunction     abs avg count max min sum
"hi sqlStatement  ctermfg=208         ctermbg=None   cterm=Bold  " SELECT INSERT UPDATE COMMIT SET
"hi sqlKeyword    ctermfg=208         ctermbg=None   cterm=Bold  " FROM ON JOIN
"hi sqlOperator   ctermfg=208         ctermbg=None   cterm=None  " DISTINCT AND OR 'NOT IN'
"hi sqlSpecial    ctermfg=178         ctermbg=None   cterm=Bold  " NULL TRUE FALSE
"hi sqlType       ctermfg=111         ctermbg=None   cterm=None  " VARCHAR2 NUMBER
"hi sqlComment    ctermfg=244         ctermbg=None   cterm=None
"hi sqlString     ctermfg=71          ctermbg=None   cterm=None  "
"hi sqlNumber     ctermfg=75          ctermbg=None   cterm=None  "
"hi def link sqlFunction Function
"hi link sqlFunction Function

" sh specific
"   -- Colors to use w dark theme
"   white      : 253
"   red        : 203
"   light-red  : 210
"   orange     : 208
"   lightorange: 220
"   yellow     : 178
"   lightyellow: 193
"   green      : 71
"   light-green: 83
"   blue       : 75
"   lightblue  : 87
"   purple     : 176
"   cyan       : 37
"   light-cyan : 116
"   grey       : 246
"

hi shSpecial        ctermfg=193 ctermbg=None    cterm=None
hi shConditional    ctermfg=176 ctermbg=None    cterm=None
hi shFunction       ctermfg=193 ctermbg=None    cterm=None
"  shFunctionName
hi shOperator       ctermfg=193 ctermbg=None    cterm=None
hi shKeyword        ctermfg=87  ctermbg=None    cterm=None
hi shStatement      ctermfg=87  ctermbg=None    cterm=None
hi shVariable       ctermfg=253 ctermbg=None    cterm=None
hi shShellVariables ctermfg=75  ctermbg=None    cterm=None
hi shCommandSub     ctermfg=210 ctermbg=None    cterm=None
hi shComment        ctermfg=71  ctermbg=None    cterm=None
"hi shSingleQuote    ctermfg=220 ctermbg=None    cterm=None

hi def link shTodo          Todo
hi def link shError         Error
hi def link shString        String
hi def link shCharacter     shString
hi def link shNumber        Number
hi dirColorsColor0 ctermfg=16  ctermbg=231

hi def link shSetList       shOperator
hi def link shAlias         shShellVariables
hi def link shFunctionKey   shFunction
"hi def link shDoubleQuote   shString


