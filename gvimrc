if has('gui_macvim')
  macmenu Edit.Find.Find\.\.\. key=<nop>
  " Command F to search
  map <D-f> /
  " Ctrl-F page forward
  map <c-f> <c-f>
endif
