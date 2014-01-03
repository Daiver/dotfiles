if has('vim_starting')
   set nocompatible               " Be iMproved
   set runtimepath+=~/.vim/bundle/neobundle.vim/
 endif

 call neobundle#rc(expand('~/.vim/bundle/'))

colorscheme wombat256mod

 " Let NeoBundle manage NeoBundle
 NeoBundleFetch 'Shougo/neobundle.vim'
 NeoBundle 'Shougo/vimfiler.vim'

 NeoBundle 'Shougo/unite.vim'
 NeoBundle 'Shougo/neocomplete.vim'

 " Recommended to install
 NeoBundle 'Shougo/vimproc', {'build' : {'unix' : 'make -f make_unix.mak'}}
 let g:neocomplete#enable_at_startup = 1
 " \     'windows' : 'make -f make_mingw32.mak',
 " \     'cygwin' : 'make -f make_cygwin.mak',
 " \     'mac' : 'make -f make_mac.mak',
 " \     'unix' : 'make -f make_unix.mak',
 " \    },
 " \ }

 " My Bundles here:
 " Refer to |:NeoBundle-examples|.
 "
 " Note: You don't set neobundle setting in .gvimrc!

 " ...

 filetype plugin indent on     " Required!
 "
 " Brief help
 " :NeoBundleList          - list configured bundles
 " :NeoBundleInstall(!)    - install(update) bundles
 " :NeoBundleClean(!)      - confirm(or auto-approve) removal of unused bundles

 " Installation check.
 NeoBundleCheck

 syntax on "Включить подсветку синтаксиса
 set nu "Включаем нумерацию строк
 set mousehide "Спрятать курсор мыши когда набираем текст
 set mouse=a "Включить поддержку мыши
 set termencoding=utf-8 "Кодировка терминала
 set novisualbell "Не мигать 
 set t_vb= "Не пищать! (Опции 'не портить текст', к сожалению, нету)
 "Удобное поведение backspace
 "set backspace=indent,eol,start whichwrap+=<,>,[,]
 ""Вырубаем черточки на табах
 set showtabline=0
 "Колоночка, чтобы показывать плюсики для скрытия блоков кода:
 "set foldcolumn=1
 "
 ""Переносим на другую строчку, разрываем строки
 set wrap
 set linebreak

 set tabstop=4 
 set shiftwidth=4
 set smarttab
 set expandtab "Ставим табы пробелами
 set softtabstop=4 "4 пробела в табе
 "Автоотступ
 "set autoindent
 "
 "
