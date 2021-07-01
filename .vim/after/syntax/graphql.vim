
syn region graphqlComment    start=+"""+ end=+"""+ contains=@Spell extend

syn keyword graphqlScalarExplict scalar nextgroup=graphqlScalarExplict skipwhite
syn keyword graphqlImplements type enum schema interface implements nextgroup=graphqlImplements skipwhite

hi def link graphqlScalarExplict graphqlBoldPurple 
hi def link graphqlImplements graphqlBold
hi def link graphqlTypeExplict graphqlBold 

hi graphqlBold term=bold cterm=bold ctermfg=DarkMagenta
hi graphqlBoldPurple ctermfg=DarkMagenta 
