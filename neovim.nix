{neovim, lib, vimPlugins, vimUtils, stdenv, fetchFromGitHub, tabnine}:

let
  deoplete-tabnine-orig = vimUtils.buildVimPluginFrom2Nix {
    pname = "deoplete-tabnine";
    version = "2019-04-08";
    src = fetchFromGitHub {
      owner = "tbodt";
      repo = "deoplete-tabnine";
      rev = "050a3bfd4f5ff065b1fe864748557b2d7e439b48";
      sha256 = "0gk6d33v2j3cydvq4678brz0885pd91vj19ivbr7i24ymyhfg9ky";
    };
  };
  deoplete-tabnine = deoplete-tabnine-orig.overrideAttrs(old: {
    postPatch = ''
      substituteInPlace rplugin/python3/deoplete/sources/tabnine.py \
        --replace "path = get_tabnine_path(binary_dir)" "path = '${lib.getBin tabnine}/bin/TabNine'"
      substituteInPlace rplugin/python3/deoplete/sources/tabnine.py \
        --replace "os.path.join(self._install_dir, 'tabnine.log')" ""
      substituteInPlace rplugin/python3/deoplete/sources/tabnine.py \
        --replace "'--log-file-path'," ""
    '';
  });
in
neovim.override {
  vimAlias = true;
  viAlias = true;

  configure = {
    plug.plugins = with vimPlugins; [
      awesome-vim-colorschemes
      PreserveNoEOL
      vim-lastplace
      vim-airline
      vim-gitgutter
      vim-fugitive
      vim-easy-align
      vim-better-whitespace
      editorconfig-vim
      neomake
      nerdtree
      nerdtree-git-plugin
      fzfWrapper
      fzf-vim
      pony-vim-syntax
      vim-terraform
      vim-go
      syntastic
      deoplete-nvim
      deoplete-go
      deoplete-rust
      deoplete-tabnine
      vim-nix
    ];

    customRC = ''
      " Sets how many lines of history VIM has to remember
      set history=500

      " Enable filetype plugins
      filetype indent plugin on

      " Enable syntax highlighting
      syntax enable

      set nocompatible

      " Set to auto read when a file is changed from the outside
      set autoread

      " A buffer becomes hidden when it is abandoned
      set hidden

      " Did for editconfig primarily (needs verification)
      set fixendofline

      " Turn on the Wild menu
      set wildmenu

      " Show command
      set showcmd

      " Highlight search results
      set hlsearch

      " Makes search act like search in modern browsers
      set incsearch

      " Ignore case when searching
      set ignorecase

      " When searching try to be smart about cases
      set smartcase

      " Configure backspace so it acts as it should act
      set backspace=indent,eol,start
      set whichwrap+=<,>,h,l

      " Don't redraw while executing macros (good performance config)
      set lazyredraw

      " For regular expressions turn magic on
      set magic

      " Show matching brackets when text indicator is over them
      set showmatch

      " How many tenths of a second to blink when matching brackets
      set mat=2

      " Auto indent
      set autoindent

      " Smart indent
      set smartindent

      " Wrap lines
      set wrap

      " Use spaces instead of tabs
      set expandtab

      " Be smart when using tabs
      set smarttab

      " 1 tab == 2 spaces
      set shiftwidth=2
      set tabstop=2

      set nostartofline

      " Always show current position
      set ruler

      " Highlight cursor line
      set cursorline

      " Always show the status line
      set laststatus=2

      " No annoying sound on errors
      set noerrorbells
      set novisualbell
      set t_vb=
      set tm=500

      " Linebreak on 500 characters
      set lbr
      set tw=500

      " Add a bit extra margin to the left
      set foldcolumn=1

      " Unfold things a bit
      set foldlevel=10

      " Set utf8 as standard encoding and en_US as the standard language
      set encoding=utf8
      scriptencoding utf-8

      " Use Unix as the standard file type
      set ffs=unix,dos,mac

      " Turn backup off
      set nobackup
      set nowb
      set noswapfile

      " Turn mouse on
      set mouse=a

      " Height of the command bar
      set cmdheight=2

      " Show line number
      set number

      set foldmethod=syntax

      " Copy to clipboard
      vnoremap  <leader>y  "+y
      nnoremap  <leader>Y  "+yg_
      nnoremap  <leader>y  "+y
      nnoremap  <leader>yy "+yy

      " Paste from clipboard
      nnoremap <leader>p "+p
      nnoremap <leader>P "+P
      vnoremap <leader>p "+p
      vnoremap <leader>P "+P<Paste>

      " Deoplete complete on Tab
      inoremap <silent><expr><TAB>  pumvisible() ? deoplete#mappings#close_popup() : "\<TAB>"

      map <C-p> :FZF<CR>
      map <C-n> :NERDTreeToggle<CR>
      map <A-a> :ChefFindAny<CR>

      let g:deoplete#enable_at_startup = 1

      colorscheme jellybeans

      let g:NERDTreeShowHidden=1
      let g:PreserveNoEOL = 1

      let g:syntastic_always_populate_loc_list = 1
      let g:syntastic_auto_loc_list = 1
      let g:syntastic_check_on_open = 1
      let g:syntastic_check_on_wq = 0

      let g:syntastic_go_checkers = ['golint', 'govet', 'golangci-lint']
      let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }

      let g:terraform_align=1
      let g:terraform_fold_sections=1
      let g:terraform_remap_spacebar=1
      let g:terraform_fmt_on_save=1

      let g:go_highlight_types = 1
      let g:go_highlight_build_constraints = 1
      let g:go_highlight_generate_tags = 1
      let g:go_highlight_fields = 1

      " (Optional)Remove Info(Preview) window
      set completeopt-=preview

      " (Optional)Hide Info(Preview) window after completions
      autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
      autocmd InsertLeave * if pumvisible() == 0|pclose|endif
  '';

  };
}
