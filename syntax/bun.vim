" vim-bun -- syntax support for bun in (n)vim
"
" Partially referenced from https://github.com/fatih/vim-go
"
" note that a lot of the syntax/builtins aren't actually support *yet*


" Quit when a (custom) syntax file was already loaded
if exists("b:current_syntax")
  finish
endif

syn case match

syn keyword     bunImport            import    contained
syn keyword     bunVar               var       contained
syn keyword     bunConst             const     contained

hi def link     bunImport            Statement
hi def link     bunVar               Keyword
hi def link     bunConst             Keyword
hi def link     bunDeclaration       Keyword

" Keywords within functions
syn keyword     bunStatement         return break continue
syn keyword     bunConditional       if else switch select
syn keyword     bunLabel             case default
syn keyword     bunRepeat            for

hi def link     bunStatement         Statement
hi def link     bunConditional       Conditional
hi def link     bunLabel             Label
hi def link     bunRepeat            Repeat

" Predefined types
syn keyword     bunType              chan map bool string error
syn keyword     bunSignedInts        int
syn keyword     bunFloats            float

hi def link     bunType              Type
hi def link     bunSignedInts        Type
hi def link     bunFloats            Type

" Predefined functions and values
syn keyword     bunBuiltins                 print println printf len first last rest
syn keyword     bunBoolean                  true false
syn keyword     bunPredefinedIdentifiers    nil iota

hi def link     bunBuiltins                 Identifier
hi def link     bunBoolean                  Boolean
hi def link     bunPredefinedIdentifiers    bunBoolean

" Comments; their contents
syn keyword     bunTodo              contained TODO FIXME XXX BUG
syn cluster     bunCommentGroup      contains=bunTodo

syn region      bunComment           start="#" end="$" contains=bunGenerate,@bunCommentGroup,@Spell

hi def link     bunComment           Comment
hi def link     bunTodo              Todo


" Go escapes
syn match       bunEscapeOctal       display contained "\\[0-7]\{3}"
syn match       bunEscapeC           display contained +\\[abfnrtv\\'"]+
syn match       bunEscapeX           display contained "\\x\x\{2}"
syn match       bunEscapeU           display contained "\\u\x\{4}"
syn match       bunEscapeBigU        display contained "\\U\x\{8}"
syn match       bunEscapeError       display contained +\\[^0-7xuUabfnrtv\\'"]+

hi def link     bunEscapeOctal       bunSpecialString
hi def link     bunEscapeC           bunSpecialString
hi def link     bunEscapeX           bunSpecialString
hi def link     bunEscapeU           bunSpecialString
hi def link     bunEscapeBigU        bunSpecialString
hi def link     bunSpecialString     Special
hi def link     bunEscapeError       Error

" Strings and their contents
syn cluster     bunStringGroup       contains=bunEscapeOctal,bunEscapeC,bunEscapeX,bunEscapeU,bunEscapeBigU,bunEscapeError
" if bun#config#HighlightStringSpellcheck()
"   syn region      bunString            start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=@bunStringGroup,@Spell
"   syn region      bunRawString         start=+`+ end=+`+ contains=@Spell
" else
"   syn region      bunString            start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=@bunStringGroup
"   syn region      bunRawString         start=+`+ end=+`+
" endif

" TODO: format strings

hi def link     bunString            String
hi def link     bunRawString         String

" Characters; their contents
syn cluster     bunCharacterGroup    contains=bunEscapeOctal,bunEscapeC,bunEscapeX,bunEscapeU,bunEscapeBigU
syn region      bunCharacter         start=+'+ skip=+\\\\\|\\'+ end=+'+ contains=@bunCharacterGroup

hi def link     bunCharacter         Character

" Regions
syn region      bunParen             start='(' end=')' transparent
syn region    bunBlock             start="{" end="}" transparent fold

" import
syn region    bunImport            start='import (' end=')' transparent fold contains=bunImport,bunString,bunComment

" var, const
syn region    bunVar               start='var ('   end='^\s*)$' transparent fold
                      \ contains=ALLBUT,bunParen,bunBlock,bunFunction,bunTypeName,bunReceiverType,bunReceiverVar,bunParamName,bunParamType,bunSimpleParams,bunPointerOperator
syn region    bunConst             start='const (' end='^\s*)$' transparent fold
                      \ contains=ALLBUT,bunParen,bunBlock,bunFunction,bunTypeName,bunReceiverType,bunReceiverVar,bunParamName,bunParamType,bunSimpleParams,bunPointerOperator

" Single-line var, const, and import.
syn match       bunSingleDecl        /\%(import\|var\|const\) [^(]\@=/ contains=bunImport,bunVar,bunConst

" Integers
syn match       bunDecimalInt        "\<-\=\(0\|[1-9]_\?\(\d\|\d\+_\?\d\+\)*\)\%([Ee][-+]\=\d\+\)\=\>"
syn match       bunDecimalError      "\<-\=\(_\(\d\+_*\)\+\|\([1-9]\d*_*\)\+__\(\d\+_*\)\+\|\([1-9]\d*_*\)\+_\+\)\%([Ee][-+]\=\d\+\)\=\>"
syn match       bunHexadecimalInt    "\<-\=0[xX]_\?\(\x\+_\?\)\+\>"
syn match       bunHexadecimalError  "\<-\=0[xX]_\?\(\x\+_\?\)*\(\([^ \t0-9A-Fa-f_)]\|__\)\S*\|_\)\>"
syn match       bunOctalInt          "\<-\=0[oO]\?_\?\(\o\+_\?\)\+\>"
syn match       bunOctalError        "\<-\=0[0-7oO_]*\(\([^ \t0-7oOxX_/)\]\}\:;]\|[oO]\{2,\}\|__\)\S*\|_\|[oOxX]\)\>"
syn match       bunBinaryInt         "\<-\=0[bB]_\?\([01]\+_\?\)\+\>"
syn match       bunBinaryError       "\<-\=0[bB]_\?[01_]*\([^ \t01_)]\S*\|__\S*\|_\)\>"

hi def link     bunDecimalInt        Integer
hi def link     bunDecimalError      Error
hi def link     bunHexadecimalInt    Integer
hi def link     bunHexadecimalError  Error
hi def link     bunOctalInt          Integer
hi def link     bunOctalError        Error
hi def link     bunBinaryInt         Integer
hi def link     bunBinaryError       Error
hi def link     Integer             Number

" Floating point
syn match       bunFloat             "\<-\=\d\+\.\d*\%([Ee][-+]\=\d\+\)\=\>"
syn match       bunFloat             "\<-\=\.\d\+\%([Ee][-+]\=\d\+\)\=\>"

hi def link     bunFloat             Float

" Comments; their contents
syn keyword     bunTodo              contained NOTE
hi def link     bunTodo              Todo

" syn match bunVarArgs /\.\.\./

" Operators;
" single-char operators:                - + % < > ! & | ^ * =
" and corresponding two-char operators: -= += %= <= >= != &= |= ^= *= ==
syn match bunOperator /[-+%<>!&|^*=]=\?/
syn match bunOperator /:=\|||\|++\|--/
hi def link     bunOperator          Operator

" Functions;
syn match bunDeclaration       /\<func\>/ nextgroup=bunFunction,bunSimpleParams skipwhite skipnl
syn match bunFunction          /\w\+/ nextgroup=bunSimpleParams contained skipwhite skipnl
syn match bunSimpleParams      /(\%(\w\|\_s\|[*\.\[\],\{\}<>-]\)*)/ contained contains=bunParamName,bunType nextgroup=bunFunctionReturn skipwhite skipnl
syn match bunFunctionReturn   /(\%(\w\|\_s\|[*\.\[\],\{\}<>-]\)*)/ contained contains=bunParamName,bunType skipwhite skipnl
syn match bunParamName        /\w\+\%(\s*,\s*\w\+\)*\ze\s\+\%(\w\|\.\|\*\|\[\)/ contained nextgroup=bunParamType skipwhite skipnl
" syn match bunParamType        /\%([^,)]\|\_s\)\+,\?/ contained nextgroup=bunParamName skipwhite skipnl
"                       \ contains=bunVarArgs,bunType,bunSignedInts,bunFloats,bunDeclType,bunBlock
hi def link   bunParamName      Identifier
hi def link     bunFunction          Function

" Function calls;
" syn match bunFunctionCall      /\w\+\ze(/ contains=bunBuiltins,bunDeclaration
" hi def link     bunFunctionCall      Type

" Fields;
" if bun#config#HighlightFields()
"   " 1. Match a sequence of word characters coming after a '.'
"   " 2. Require the following but dont match it: ( \@= see :h E59)
"   "    - The symbols: / - + * %   OR
"   "    - The symbols: [] {} <> )  OR
"   "    - The symbols: \n \r space OR
"   "    - The symbols: , : .
"   " 3. Have the start of highlight (hs) be the start of matched
"   "    pattern (s) offsetted one to the right (+1) (see :h E401)
"   syn match       bunField   /\.\w\+\
"         \%(\%([\/\-\+*%]\)\|\
"         \%([\[\]{}<\>\)]\)\|\
"         \%([\!=\^|&]\)\|\
"         \%([\n\r\ ]\)\|\
"         \%([,\:.]\)\)\@=/hs=s+1
" endif
" hi def link    goField              Identifier

" Variable Assignments
syn match bunVarAssign /\v[_.[:alnum:]]+(,\s*[_.[:alnum:]]+)*\ze(\s*([-^+|^\/%&]|\*|\<\<|\>\>|\&\^)?\=[^=])/
hi def link   bunVarAssign         Special

" Variable Declarations
syn match bunVarDefs /\v\w+(,\s*\w+)*\ze(\s*:\=)/
hi def link   bunVarDefs           Special

let b:current_syntax = "bun"
