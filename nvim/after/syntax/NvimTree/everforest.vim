if !exists('g:colors_name') || g:colors_name !=# 'everforest'
    finish
endif
if index(g:everforest_loaded_file_types, 'NvimTree') ==# -1
    call add(g:everforest_loaded_file_types, 'NvimTree')
else
    finish
endif
let s:configuration = everforest#get_configuration()
let s:palette = everforest#get_palette(s:configuration.background, s:configuration.colors_override)
" syn_begin: NvimTree {{{
" https://github.com/kyazdani42/nvim-tree.lua
if !s:configuration.transparent_background
  call everforest#highlight('NvimTreeNormal', s:palette.fg, s:palette.bg_dim)
  call everforest#highlight('NvimTreeEndOfBuffer', s:palette.bg_dim, s:palette.bg_dim)
  call everforest#highlight('NvimTreeVertSplit', s:palette.bg0, s:palette.bg0)
  call everforest#highlight('NvimTreeCursorLine', s:palette.none, s:palette.bg0)
endif
highlight! link NvimTreeSymlink Fg
highlight! link NvimTreeFolderName Green
highlight! link NvimTreeRootFolder Grey
highlight! link NvimTreeFolderIcon Orange
highlight! link NvimTreeEmptyFolderName Green
highlight! link NvimTreeOpenedFolderName Green
highlight! link NvimTreeExecFile Fg
highlight! link NvimTreeOpenedFile Fg
highlight! link NvimTreeSpecialFile Fg
highlight! link NvimTreeImageFile Fg
highlight! link NvimTreeMarkdownFile Fg
highlight! link NvimTreeIndentMarker Grey
highlight! link NvimTreeGitDirty Yellow
highlight! link NvimTreeGitStaged Blue
highlight! link NvimTreeGitMerge Orange
highlight! link NvimTreeGitRenamed Purple
highlight! link NvimTreeGitNew Aqua
highlight! link NvimTreeGitDeleted Red
highlight! link NvimTreeLspDiagnosticsError RedSign
highlight! link NvimTreeLspDiagnosticsWarning YellowSign
highlight! link NvimTreeLspDiagnosticsInformation BlueSign
highlight! link NvimTreeLspDiagnosticsHint GreenSign
" syn_end
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
