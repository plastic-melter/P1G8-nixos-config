{ inputs, config, pkgs, lib, ... }:
{

#################################################
################## HOME.NIX #####################
#################################################

home = {
  stateVersion = "25.05"; # DO NOT EVER EDIT THIS
  username = "joe";
  homeDirectory = "/home/joe";
};

home.file = {
  ".config/wofi".source = ./dotfiles/wofi;
  ".config/yazi".source = ./dotfiles/yazi;
  ".config/waybar".source = ./dotfiles/waybar;
  ".config/ags" = {
    source = ./dotfiles/ags;
    recursive = true;
  };
  ".config/hypr".source = ./dotfiles/hypr;
  ".config/eww" = {
    source = ./dotfiles/eww;
    recursive = true;
  };
  ".config/wlogout".source = ./dotfiles/wlogout;
  ".config/plutonium".source = ./dotfiles/plutonium;
  ".config/scripts".source = ./dotfiles/scripts;
  ".config/wallpapers".source = ./dotfiles/wallpapers;
  ".config/nwg-drawer".source = ./dotfiles/nwg-drawer;
  ".config/foot".source = ./dotfiles/foot;
  ".config/wezterm".source = ./dotfiles/wezterm;
  ".config/user-dirs.conf".text = ''
    enabled=True
  '';
  ".config/user-dirs.dirs".text = ''
    XDG_DESKTOP_DIR="/home/joe/Desktop"
    XDG_DOCUMENTS_DIR="/home/joe/Documents"
    XDG_DOWNLOAD_DIR="/home/joe/Downloads"#
    XDG_MUSIC_DIR="/home/joe/Music"
    XDG_PICTURES_DIR="/home/joe/Pictures"
    XDG_PUBLICSHARE_DIR="/home/joe/Public"
    XDG_TEMPLATES_DIR="/home/joe/Templates"
    XDG_VIDEOS_DIR="/home/joe/Videos"
    XDG_BACKUP_DIR="/home/joe/Backups"
    XDG_STORAGE_DIR="/home/joe/Storage"
  '';
};

manual = {
  html.enable = false;
  json.enable = false;
  manpages.enable = false;
};

programs.git = {
  enable = true;
  package = pkgs.git;
  settings = {
    user.name = "plastic-melter";
    user.email = "140357149+plastic-melter@users.noreply.github.com";
  };
};

programs.neovim = {
  enable = true;
  viAlias = true;
  vimAlias = true;
  defaultEditor = true;
  plugins = with pkgs.vimPlugins; [
    nvim-treesitter.withAllGrammars
    telescope-nvim
    plenary-nvim
    lualine-nvim
    nvim-web-devicons
    gitsigns-nvim
    indent-blankline-nvim
    neoscroll-nvim
    toggleterm-nvim
  ];
  extraLuaConfig = ''
    vim.cmd('colorscheme slate')
    vim.cmd([[
      hi Normal guibg=NONE ctermbg=NONE
      hi NormalFloat guibg=NONE ctermbg=NONE
      hi SignColumn guibg=NONE ctermbg=NONE
      highlight Cursor guifg=black guibg=#aaffff
      highlight iCursor guifg=black guibg=#aaffff
      highlight Search guifg=black guibg=#ffb366
    ]])
    vim.opt.number = true
    vim.opt.relativenumber = false
    vim.opt.cursorline = true
    vim.opt.ignorecase = true
    vim.opt.smartcase = true
    vim.opt.hlsearch = true
    vim.opt.incsearch = true
    vim.opt.tabstop = 2
    vim.opt.softtabstop = 2
    vim.opt.shiftwidth = 2
    vim.opt.expandtab = true
    vim.opt.autoindent = true
    vim.opt.mouse = 'a'
    vim.opt.clipboard = 'unnamedplus'
    vim.opt.termguicolors = true
    vim.opt.ttyfast = true
    vim.opt.compatible = false
    vim.opt.list = true
    vim.opt.listchars = { tab = '│ ', trail = '·', nbsp = '␣' }
    vim.opt.wildmode = 'longest,list'
    vim.opt.foldmethod = 'marker'
    vim.opt.guicursor = 'n-v-c:block-Cursor,i-ci-ve:ver25-iCursor,r-cr:hor20-Cursor'
    vim.cmd('filetype plugin indent on')
    vim.cmd('syntax on')
    require('nvim-treesitter.configs').setup({
      highlight = { enable = true, additional_vim_regex_highlighting = false },
      indent = { enable = true },
    })
    require('lualine').setup({
      options = {
        theme = 'auto',
        component_separators = { left = " ", right = " " },
        section_separators = { left = " ", right = " " },
      },
    })
    require('telescope').setup({
      defaults = { layout_config = { horizontal = { preview_width = 0.6 } } },
    })
    vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { desc = 'Find files' })
    vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = 'Live grep' })
    vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { desc = 'Buffers' })
    require('gitsigns').setup({
      signs = {
        add = { text = '│' },
        change = { text = '│' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    })
    require('ibl').setup({
      indent = { char = '│' },
      scope = { enabled = false },
    })
    require('neoscroll').setup({
      mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>', '<C-y>', '<C-e>', 'zt', 'zz', 'zb'},
      hide_cursor = true,
      stop_eof = true,
      respect_scrolloff = false,
      cursor_scrolls_alone = true,
    })
    require('toggleterm').setup({
      size = 20,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      persist_size = true,
      direction = 'float',
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = { border = 'curved', winblend = 0 },
    })
    vim.keymap.set('n', '<C-Space>', function()
      vim.fn.system('wl-copy', vim.fn.getreg('"'))
    end, { desc = 'Copy to clipboard' })
  '';
};

wayland.windowManager.hyprland = {
  enable = true;
  xwayland.enable = true;
  systemd.enable = false;
  package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
  #plugins = [
  #  inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
  #];
};

programs.zsh = {
  enable = true;
  plugins = [
    {
      name = "powerlevel10k";
      src = pkgs.zsh-powerlevel10k;
      file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
    }
  ];
  initContent = lib.mkOrder 550 ''
    bindkey -e
    P10K_INSTANT_PROMPT="$XDG_CACHE_HOME/p10k-instant-prompt-''${(%):-%n}.zsh"
    [[ ! -r "$P10K_INSTANT_PROMPT" ]] || source "$P10K_INSTANT_PROMPT"
  '';
  localVariables = {
    POWERLEVEL9K_SHORTEN_STRATEGY = "truncate_middle";
    POWERLEVEL9K_SHORTEN_DIR_LENGHTH = "2";
    POWERLEVEL9K_PROMPT_ON_NEWLINE = false;
    POWERLEVEL9K_PROMPT_ADD_NEWLINE = false;
    #POWERLEVEL9K_PROMPT_LEFT_SEGMENT_SEPARATOR = "$'\uEB70'";
    #POWERLEVEL9K_PROMPT_RIGHT_SEGMENT_SEPARATOR = "$'\uEBF'";
    POWERLEVEL9K_LEFT_PROMPT_ELEMENTS = [
      "custom_nix"
      "dir"
    ];
    POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS = [
 #     "status"
 #     "time"
    ];
    POWERLEVEL9K_CUSTOM_NIX = "echo 󱄅";
    POWERLEVEL9K_CUSTOM_NIX_FOREGROUND = "014";
    POWERLEVEL9K_CUSTOM_NIX_BACKGROUND = "239";
    POWERLEVEL9K_DIR_FOREGROUND = "133";
    POWERLEVEL9K_DIR_BACKGROUND = "236";
    POWERLEVEL9K_STATUS_OK_FOREGROUND = "046";
    POWERLEVEL9K_STATUS_OK_BACKGROUND = "000";
    POWERLEVEL9K_STATUS_ERROR_FOREGROUND = "203";
    POWERLEVEL9K_STATUS_ERROR_BACKGROUND = "000";
    POWERLEVEL9K_TIME_FOREGROUND = "105";
    POWERLEVEL9K_TIME_BACKGROUND = "233";
    EDITOR = "vi";
  };
  #alias
  shellAliases = {
    games = "yazi /home/joe/Backups/Games/quick-access";
    dotsync = "doas /etc/nixos/dotfiles/scripts/nixos-git-sync.sh";
    gens = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
    yeet = "/etc/nixos/dotfiles/scripts/yeet.sh";
    megayeet = "/etc/nixos/dotfiles/scripts/megayeet.sh";
    elona = "wine /home/joe/Backups/Games/quick-access/elona/customgx-2.28/elonaplus2.28/elonapluscgx.exe";
    sudo = "doas";
    fetch = "fastfetch";
    sys = "doas vim /etc/nixos/configuration.nix";
    home = "vim /etc/nixos/home.nix";
    flake = "doas vim /etc/nixos/flake.nix";
    dots = "yazi /etc/nixos/dotfiles";
    scripts = "yazi /etc/nixos/dotfiles/scripts";
    clc = "clear";
    kms = "/etc/nixos/dotfiles/scripts/kms.sh";
    kys = "pkill";
    notes = "vim ~/.notes.md";
    colors = "vim /etc/nixos/dotfiles/colors";
    lowres = "hyprctl keyword monitor eDP-1,1680x1050,0x0,1 && hyprctl keyword monitor HDMI-A-1,1920x1080,1680x0,1";
    highres = "hyprctl keyword monitor eDP-1,2560x1600,0x0,1 && hyprctl keyword monitor HDMI-A-1,3840x2160,2560x0,1";
    homeclean = "env --chdir=/home/joe /etc/nixos/dotfiles/scripts/homeclean.sh";
  };
};

dconf.settings = {
  "org/virt-manager/virt-manager/connections" = {
    autoconnect = ["qemu:///system"];
    uris = ["qemu:///system"];
  };
  "org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    gtk-theme = "Arc-Dark"; 
    icon-theme = "Papirus-Dark";
  };
};

services.playerctld.enable = true;

services.syncthing.enable = true; # autostart service on user login; rest of syncthing is in conf.nix

services.dunst = {
  enable = true;
  settings = {
    global = {
      timeout = 2;
      width = "(0, 600)";
      height = 200;
      offset = "0x30";
      origin = "top-center";
      corner_radius = 15;
      notification_limit = 5;
      idle_threshold = 0;
      progress_bar = true;
      progress_bar_height = 15;
      progress_bar_horizontal_alignment = "center";
      progress_bar_corner_radius = 3;
      progress_bar_min_width = 150;
      progress_bar_max_width = 350;
      progress_bar_frame_width = 2;
      separator_height = 3;
      separator_color = "auto";
      sort = "false";
      layer = "overlay";
      line_height = 0;
      format = "<b>%s</b>\n%b";
      padding = 5;
      horizontal_padding = 5;
      icon_corner_radius = 5;
      text_icon_padding = 5;
      frame_width = 4;
      frame_color = "#5E81AC";
      background_color = "#181b28";
      foreground_color = "#ffffd8";
      font = "NotoSansCJK 18";
      min_icon_size = 128;
      max_icon_size = 128;
      background = "#090909B5";
    };
  };
};

xdg.userDirs = {
  enable = false;
  #createDirectories = false;
  #extraConfig = {
  #  XDG_AUTOMOUNTED_BACKUPS_DIR = "/home/joe/Backups";
  #};
};

xdg.configFile."qt5ct/qt5ct.conf" = {
  force = true;
  text = ''
[Appearance]
style=Kvantum
icon_theme=breeze
  '';
};

xdg.configFile."xfce4/helpers.rc".text = ''
  TerminalEmulator=wezterm
'';

xdg.configFile."qt6ct/qt6ct.conf" = {
  force = true;
  text = ''
[Appearance]
style=Kvantum
icon_theme=breeze
  '';
};

xdg.desktopEntries = {
  firefox-personal = {
    name = "Firefox (Personal)";
    exec = "firefox --no-remote -P Personal";
    terminal = false;
    icon = "firefox";
    categories = [ "Network" "WebBrowser" ];
  };
  firefox-work = {
    name = "Firefox (Odin)";
    exec = "firefox --no-remote -P Ofin";
    terminal = false;
    icon = "firefox";
    categories = [ "Network" "WebBrowser" ];
  };
  bwr = {
    name = "Blue Wish Resurrection Plus";
    genericName = "BWR";
    exec = "WINEDLLOVERRIDES=winemenubuilder.exe=d wine /home/joe/Backups/Games/quick-access/BWR/BWR_PLUS1.11/BWRP1.11.exe";
    icon = "/home/joe/Backups/Games/quick-access/BWR/BWR_PLUS1.11/htm_data/title_bwrp.gif";
    terminal = true;
    categories = [ "Game" ];
    comment = "Blue Wish Resurrection Plus 1.11";
    type = "Application";
  };
  imv = {
    name = "imv";
    genericName = "imv";
    exec = "imv %f";
    terminal = false;
    categories = [ "Graphics" ];
    mimeType = [ "image/png" "image/jpeg" "image/jpg" "image/gif" "image/webp" ];
  };
  seihou1 = {
    name = "西方1";
    genericName = "seihou1";
    exec = "wine /home/joe/Backups/Games/quick-access/Seihou1/seihou1.exe";
    icon = "/etc/nixos/dotfiles/images/seihou1.jpg";
    terminal = false;
    categories = [ "Game" ];
    comment = "秋霜玉 (Shuusou Gyoku)";
    type = "Application";
  };
  seihou2 = {
    name = "西方2";
    genericName = "seihou2";
    exec = "wine /home/joe/Backups/Games/quick-access/Seihou2/seihou2.exe";
    icon = "/etc/nixos/dotfiles/images/seihou2.jpg";
    terminal = false;
    categories = [ "Game" ];
    comment = "稀翁玉 (Kioh Gyoku)";
    type = "Application";
  };
  seihou3 = {
    name = "西方3";
    genericName = "seihou3";
    exec = "wine /home/joe/Backups/Games/quick-access/Seihou3/seihou3.exe";
    icon = "/etc/nixos/dotfiles/images/seihou3.jpg";
    terminal = false;
    categories = [ "Game" ];
    comment = "幡紫竜 (Banshiryuu)";
    type = "Application";
  };
  th06 = {
    name = "東方06";
    genericName = "th06";
    exec = "wine /home/joe/Backups/Games/quick-access/th06/th06english/th06e.exe";
    icon = "/etc/nixos/dotfiles/images/th6.png";
    terminal = false;
    categories = [ "Game" ];
    comment = "Embodiment of Scarlet Devil";
    type = "Application";
  };
  th07 = {
    name = "東方07";
    genericName = "th07";
    exec = "wine /home/joe/Backups/Games/quick-access/th07/th07/th07patched.exe";
    icon = "/etc/nixos/dotfiles/images/th7.png";
    terminal = false;
    categories = [ "Game" ];
    comment = "Perfect Cherry Blossom";
    type = "Application";
  };
  th075 = {
    name = "東方07.5";
    genericName = "th07.5";
    exec = "wine /home/joe/Backups/Games/quick-access/th07.5/th07.5/th075.exe";
    icon = "/etc/nixos/dotfiles/images/th7.5.png";
    terminal = false;
    categories = [ "Game" ];
    comment = "Immaterial and Missing Power";
    type = "Application";
  };
  th08 = {
    name = "東方08";
    genericName = "th08";
    exec = "wine /home/joe/Backups/Games/quick-access/th08/th08/th08.exe";
    icon = "/etc/nixos/dotfiles/images/th8.png";
    terminal = false;
    categories = [ "Game" ];
    comment = "Imperishable Night";
    type = "Application";
  };
  th09 = {
    name = "東方09";
    genericName = "th09";
    exec = "wine /home/joe/Backups/Games/quick-access/th09/th09/th09.exe";
    icon = "/etc/nixos/dotfiles/images/th9.png";
    terminal = false;
    categories = [ "Game" ];
    comment = "Phantasmagoria of Flower View";
    type = "Application";
  };
  th095 = {
    name = "東方09.5";
    genericName = "th09.5";
    exec = "wine /home/joe/Backups/Games/quick-access/th09.5/th09.5/th095.exe";
    icon = "/etc/nixos/dotfiles/images/th9.5.png";
    terminal = false;
    categories = [ "Game" ];
    comment = "Shoot the Bullet";
    type = "Application";
  };
  th10 = {
    name = "東方10";
    genericName = "th10";
    exec = "wine /home/joe/Backups/Games/quick-access/th10/th10/th10.exe";
    icon = "/etc/nixos/dotfiles/images/th10.png";
    terminal = false;
    categories = [ "Game" ];
    comment = "Mountain of Faith";
    type = "Application";
  };
  th105 = {
    name = "東方10.5";
    genericName = "th10.5";
    exec = "wine /home/joe/Backups/Games/quick-access/th10.5/th10.5/th105.exe";
    icon = "/etc/nixos/dotfiles/images/th10.5.png";
    terminal = false;
    categories = [ "Game" ];
    comment = "Scarlet Weather Rhapsody";
    type = "Application";
  };
  th11 = {
    name = "東方11";
    genericName = "th11";
    exec = "wine /home/joe/Backups/Games/quick-access/th11/th11/th11.exe";
    icon = "/etc/nixos/dotfiles/images/th11.png";
    terminal = false;
    categories = [ "Game" ];
    comment = "Subterranean Animism";
    type = "Application";
  };
  th12 = {
    name = "東方12";
    genericName = "th12";
    exec = "wine /home/joe/Backups/Games/quick-access/th12/th12/th12.exe";
    icon = "/etc/nixos/dotfiles/images/th12.png";
    terminal = false;
    categories = [ "Game" ];
    comment = "Undefined Fantastic Object";
    type = "Application";
  };
  th123 = {
    name = "東方12.3";
    genericName = "th12.3";
    exec = "wine /home/joe/Backups/Games/quick-access/th12.3/th12.3/th123.exe";
    icon = "/etc/nixos/dotfiles/images/th12.3.jpg";
    terminal = false;
    categories = [ "Game" ];
    comment = "Hisoutensoku";
    type = "Application";
  };
  th125 = {
    name = "東方12.5";
    genericName = "th12.5";
    exec = "wine /home/joe/Backups/Games/quick-access/th12.5/th12.5/th125.exe";
    icon = "/etc/nixos/dotfiles/images/th12.5.png";
    terminal = false;
    categories = [ "Game" ];
    comment = "Double Spoiler";
    type = "Application";
  };
  th128 = {
    name = "東方12.8";
    genericName = "th12.8";
    exec = "wine /home/joe/Backups/Games/quick-access/th12.8/th12.8/th128.exe";
    icon = "/etc/nixos/dotfiles/images/th12.8.png";
    terminal = false;
    categories = [ "Game" ];
    comment = "Fairy Wars";
    type = "Application";
  };
  th13 = {
    name = "東方13";
    genericName = "th13";
    exec = "wine /home/joe/Backups/Games/quick-access/th13/th13/th13.exe";
    icon = "/etc/nixos/dotfiles/images/th13.png";
    terminal = false;
    categories = [ "Game" ];
    comment = "Ten Desires";
    type = "Application";
  };
  th135 = {
    name = "東方13.5";
    genericName = "th13.5";
    exec = "wine /home/joe/Backups/Games/quick-access/th13.5/th13.5/th135.exe";
    icon = "/etc/nixos/dotfiles/images/th13.5.jpg";
    terminal = false;
    categories = [ "Game" ];
    comment = "Hopeless Masquerade";
    type = "Application";
  };
  th14 = {
    name = "東方14";
    genericName = "th14";
    exec = "wine /home/joe/Backups/Games/quick-access/th14/th14/th14.exe";
    icon = "/etc/nixos/dotfiles/images/th14.jpg";
    terminal = false;
    categories = [ "Game" ];
    comment = "Double Dealing Character";
    type = "Application";
  };
  th143 = {
    name = "東方14.3";
    genericName = "th14.3";
    exec = "wine /home/joe/Backups/Games/quick-access/th14.3/th14.3/th143.exe";
    icon = "/etc/nixos/dotfiles/images/th14.3.jpg";
    terminal = false;
    categories = [ "Game" ];
    comment = "Impossible Spell Card";
    type = "Application";
  };
  th145 = {
    name = "東方14.5";
    genericName = "th14.5";
    exec = "wine /home/joe/Backups/Games/quick-access/th14.5/th14.5/th145.exe";
    icon = "/etc/nixos/dotfiles/images/th14.5.jpg";
    terminal = false;
    categories = [ "Game" ];
    comment = "Urban Legend in Limbo";
    type = "Application";
  };
  th15 = {
    name = "東方15";
    genericName = "th15";
    exec = "wine /home/joe/Backups/Games/quick-access/th15/th15/th15.exe";
    icon = "/etc/nixos/dotfiles/images/th15.png";
    terminal = false;
    categories = [ "Game" ];
    comment = "Legacy of Lunatic Kingdom";
    type = "Application";
  };
  th155 = {
    name = "東方15.5";
    genericName = "th15.5";
    exec = "wine /home/joe/Backups/Games/quick-access/th15.5/th15.5/th155.exe";
    icon = "/etc/nixos/dotfiles/images/th15.5.jpg";
    terminal = false;
    categories = [ "Game" ];
    comment = "Antimony of Common Flowers";
    type = "Application";
  };
  th16 = {
    name = "東方16";
    genericName = "th16";
    exec = "wine /home/joe/Backups/Games/quick-access/th16/th16/th16/th16.exe";
    icon = "/etc/nixos/dotfiles/images/th16.png";
    terminal = false;
    categories = [ "Game" ];
    comment = "Hidden Star in Four Seasons";
    type = "Application";
  };
  th165 = {
    name = "東方16.5";
    genericName = "th16.5";
    exec = "wine /home/joe/Backups/Games/quick-access/th16.5/th16.5/th165.exe";
    icon = "/etc/nixos/dotfiles/images/th16.5.jpg";
    terminal = false;
    categories = [ "Game" ];
    comment = "Violet Detector";
    type = "Application";
  };
  th17 = {
    name = "東方17";
    genericName = "th17";
    exec = "wine /home/joe/Backups/Games/quick-access/th17/th17/th17.exe";
    icon = "/etc/nixos/dotfiles/images/th17.png";
    terminal = false;
    categories = [ "Game" ];
    comment = "Wily Beast and Weakest Creature";
    type = "Application";
  };
  th175 = {
    name = "東方17.5";
    genericName = "th17.5";
    exec = "wine /home/joe/Backups/Games/quick-access/th17.5/th17.5/game.exe";
    icon = "/etc/nixos/dotfiles/images/th17.5.jpg";
    terminal = false;
    categories = [ "Game" ];
    comment = "Sunken Fossil World";
    type = "Application";
  };
  th18 = {
    name = "東方18";
    genericName = "th18";
    exec = "wine /home/joe/Backups/Games/quick-access/th18/th18/th18.exe";
    icon = "/etc/nixos/dotfiles/images/th18.jpg";
    terminal = false;
    categories = [ "Game" ];
    comment = "Unconnected Marketeers";
    type = "Application";
  };
  th185 = {
    name = "東方18.5";
    genericName = "th18.5";
    exec = "wine /home/joe/Backups/Games/quick-access/th18.5/th18.5/th185.exe";
    icon = "/etc/nixos/dotfiles/images/th18.5.png";
    terminal = false;
    categories = [ "Game" ];
    comment = "100th Black Market";
    type = "Application";
  };
  th19 = {
    name = "東方19";
    genericName = "th19";
    exec = "wine /home/joe/Backups/Games/quick-access/th19/th19/th19.exe";
    icon = "/etc/nixos/dotfiles/images/th19.png";
    terminal = false;
    categories = [ "Game" ];
    comment = "Unfinished Dream of All Living Ghost";
    type = "Application";
  };
  th20 = {
    name = "東方20";
    genericName = "th20";
    exec = "wine /home/joe/Backups/Games/quick-access/th20/th20.exe";
    icon = "/etc/nixos/dotfiles/images/th20.png";
    terminal = false;
    categories = [ "Game" ];
    comment = "Fossilized Wonders";
    type = "Application";
  };
  exceed3rd = {
    name = "eXceed 3rd - Black Package";
    genericName = "eXceed3";
    exec = "wine /home/joe/Backups/Games/quick-access/exceed3bp/eXceed3rd-BR.exe";
    icon = "/etc/nixos/dotfiles/images/exceed3.png";
    terminal = false;
    comment = "eXeed 3d - JADE PENETRATE - BLACK PACKAGE";
    type = "Application";
    categories = [ "Game" ];
  };
  brda = {
    name = "Blue Revolver";
    genericName = "BRDA";
    exec = "/etc/nixos/dotfiles/scripts/BRDA.sh";
    icon = "/home/joe/Backups/Games/quick-access/BRDA/Blue.Revolver.v1.52/Blue.Revolver.v1.52/Soundtrack/mp3/Cover.jpg";
    terminal = false;
    categories = [ "Game" ];
    comment = "DRM-free copy!";
    type = "Application";
  };
  hyprpicker = {
    name = "hyprpicker";
    genericName = "color-picker";
    exec = "foot -e hyprpicker";
    icon = "/etc/nixos/dotfiles/images/picker.png";
    terminal = true;
    categories = [ "Utility" ];
    comment = "Color picker tool from hyprwm";
    type = "Application";
  };
  radeontop = {
    name = "GPU Monitor";
    genericName = "radeontop";
    exec = "foot -e radeontop";
    icon = "/etc/nixos/dotfiles/images/gpu.png";
    terminal = false;
    categories = [ "Utility" ];
    comment = "Radeon GPU monitor (TUI)";
    type = "Application";
  };
  zenmonitor = {
    name = "Zenmonitor"; 
    icon = "/etc/nixos/dotfiles/images/amd.png";
    exec = "zenmonitor";
    categories = [ "Utility" ];
    type = "Application";
  };
  pavucontrol = {
    name = "Pavucontrol";
    exec = "pavucontrol";
    icon = "/etc/nixos/dotfiles/images/mixer.png";
    terminal = false;
    categories = [ "Utility" ];
    comment = "Pulseaudio volume control / mixer";
    type = "Application";
  }; 
  qt5ct = {
    name = "qt5 config tool";
    exec = "qt5ct";
    icon = "/etc/nixos/dotfiles/images/qtlogo.png";
    terminal = false;
    categories = [ "Utility" ];
    comment = "GUI configuration tool for qt5";
    type = "Application";
  }; 
  qt6ct = {
    name = "qt6 config tool";
    exec = "qt6ct";
    icon = "/etc/nixos/dotfiles/images/qtlogo.png";
    terminal = false;
    categories = [ "Utility" ];
    comment = "GUI configuration tool for qt6";
    type = "Application";
  }; 
  htop = {
    name = "htop";
    exec = "foot -w 1500x750-e htop";
    icon = "/etc/nixos/dotfiles/images/htop.png";
  };
############### HIDDEN ##################
  footclient = {
    name = "Foot Client";
    noDisplay = true;
    settings = {
      Hidden = "true";
    };
  };
  footserver = {
    name = "Foot Server";
    noDisplay = true;
    settings = {
      Hidden = "true";
    };
  };
  protontricks = {
    name = "Protontricks";
    noDisplay = true;
    settings = {
      Hidden = "true";
    };
  };
  kbd-layout-viewer5 = {
    name = "Keyboard layout viewer";
    noDisplay = true;
    settings = {
      Hidden = "true";
    };
  };
  kvantum = {
    name = "kvantum";
    noDisplay = true;
    settings = {
      Hidden = "true";
    };
  };
  xterm = {
    name = "XTerm";
    noDisplay = true;
    settings = {
      Hidden = "true";
    };
  };
  android-file-transfer = {
    name = "Android File Transfer";
    noDisplay = true;
    settings = {
      Hidden = "true";
    };
  };
};

home.sessionVariables = {
  TERMINAL = "wezterm";
  TERM_PROGRAM = "wezterm";
  GI_TYPELIB_PATH = "/run/current-system/sw/lib/girepository-1.0"; #AGS
  EDITOR = "nvim";
  VISUAL = "nvim";
};

systemd.user.sessionVariables = {
  GTK_THEME = "Arc-Dark";
  XDG_ICON_FALLBACK = "/etc/nixos/dotfiles/images/blankicon.png";
  QT_QPA_PLATFORM = "wayland";
  QT_QPA_PLATFORMTHEME = "qt5ct";
  QT6_QPA_PLATFORMTHEME = "qt6ct";
  SDL_VIDEODRIVER = "wayland";
  XDG_SESSION_TYPE = "wayland";
  GTK_USE_PORTAL = "0";
  LIBINPUT_ATTR_TRACKPOINT_ACCEL = "0.5";
};

systemd.user.targets.tray = {
  Unit = {
    Description = "Home Manager System Tray";
    Requires = [ "graphical-session-pre.target" ];
  };
};

systemd.user.services.udiskie = {
  Unit = {
    Description = "udiskie automounter";
  };
  Service = {
    ExecStart = "${pkgs.udiskie}/bin/udiskie --smart-tray";
  };
  Install = {
    WantedBy = [ "default.target" ];
  };
};

systemd.user.services.hourly-chime = {
  Unit.Description = "Hourly time notification";
  Service = {
    Type = "oneshot";
    ExecStart = "/etc/nixos/dotfiles/scripts/hourly-chime.sh";
  };
};

systemd.user.timers.hourly-chime = {
  Unit.Description = "Hourly chime timer";
  Timer = {
    OnCalendar = "hourly";
    Persistent = true;
  };
  Install.WantedBy = [ "timers.target" ];
};

programs = { 
  foot.enable = true;
  obs-studio = {
    enable = true;
  };
  direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
};

home.packages = with pkgs; [ # user-only apps

  # PROGRAMS
  arduino # arduino suite incl. GUI
  arduino-cli # CLI arduino tools
  audacious # music player
  bolt-launcher # OSRS RuneLite launcher
  discord # electron app for discord
  firefox # the best web browser
  gimp # GNU image manipulation program
  grayjay # youtube frontend
  kdePackages.kcolorchooser # hex color tool GUI
  kdePackages.kdenlive # GUI video editor
  libreoffice-fresh # office app suite
  obsidian # cross-platform notes program
  platformio # arduino TUI + utils
  prusa-slicer # 3DP slicer
  qbittorrent # peer-to-peer file sharing
  qalculate-gtk # GUI calculator
  spotify # music streaming
  tagainijisho # japanese dictionary
  vlc # video player
  webcord # webkit app for discord, less proprietary
  wezterm # dope-ass terminal emulator
  xfce.thunar # GUI file manager
  yazi # TUI file manager
  zoom-us # video chat software

  # UTILITIES
  bluetooth_battery # fetch info form BT devices
  cdrdao # burn CDs
  cdrkit # burn CDs
  cliphist # wayland clipboard history manager
  eww # widgets and stuff
  fastfetch # quickly fetch general system info
  fd # better file finding for telescope
  ffmpeg # video re-encoding CLI
  gnome-bluetooth # GUI for bluetooth devices
  imagemagick # image editing CLI
  imv # image viewer
  mission-center # system monitoring GUI
  networkmanagerapplet # nm-applet tray utility
  pavucontrol # audio control GUI
  playerctl # audio playback control utility
  ripgrep # nvim: required for telescope live_grep
  wofi # app launcher
  xfce.tumbler # image previews in file manager
  zsh-powerlevel10k # fancy ZSH PS1

  # WAYLAND, HYPRLAND, RICE
  catppuccin-kvantum # qt theme, apply with kvantum
  hyprdim # dims inactive windows
  hypridle # auto idle screen lock, suspend, etc
  hyprland-workspaces # workspace integration for bars
  hyprlock # session locker
  hyprnome # GNOME-like workspace switching logic
  hyprpaper # wallpaper util
  hyprpicker # color picker tool
  hyprshot # screenshot util
  nwg-clipman # clipboard manager for wayland
  nwg-dock-hyprland # dock for hyprland
  nwg-drawer # app launcher
  nwg-icon-picker # icon selection tool
  nwg-launchers # lightweight program launchers
  nwg-look # GUI theme/config tool
  nwg-menu # basically a start menu
  waybar # wayland status bar
  wdisplays # wayland display settings GUI
  wev # identify keystrokes in wayland
  wlogout # wayang logout menu
  wlr-randr # like xrandr but for wayland
  wl-clipboard # enable copy-paste in wayland

  # GAMING
  dolphin-emu # GameCube/Wii emulator
  lutris # game manager like steam
  mame # arcade emulator
  nsnake # terminal snake game
  protontricks # allows for Steam proton prefixes
  wineWowPackages.waylandFull # wine for wayland
  winetricks # install DLLs/etc into wine prefixes

];

qt = {
  enable = true;
  platformTheme.name = "qt5ct";
  #style.package = pkgs.catppuccin-kvantum;
  style.name = "kvantum";
};

gtk = {
  enable = true;
  theme = {
    name = "Arc-Dark";
    package = pkgs.arc-theme;
  };
  iconTheme = {
    name = "Papirus-Dark";
    package = pkgs.papirus-icon-theme;
  };
};

################################################
}           # END OF HOME.NIX # 
################################################
