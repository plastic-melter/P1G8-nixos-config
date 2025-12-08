{ inputs, outputs, lib, config, pkgs, ... }: {

#############################################
############## P1 G8 CONFIG #################
#############################################

#let pkgs-unstable = inputs.hyprland.inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system}; in { 

nix = {
  package = pkgs.nixVersions.latest;
  extraOptions = ''
    experimental-features = nix-command flakes
  '';
  settings = {
    trusted-users = [ "root" "joe" ];
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };
};

imports = [
  ./hardware-configuration.nix
  ./cachix.nix
];

nixpkgs.config = {
  allowUnfree = true;
  allowBroken = false;
  allowInsecure = false;
};

programs = {
  zsh.enable = true;
  dconf.enable = true;
  steam = {
    enable = true;
  };
  seahorse.enable = true;
  adb.enable = true;
  gamescope.enable = true;
  xwayland.enable = true;
  ydotool.enable = true;
  hyprland = {
    enable = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  };
  wayfire = {
    enable = true;
    xwayland.enable = true;
    plugins = with pkgs.wayfirePlugins; [
      wcm
      wayfire-plugins-extra
    ];
  };
};

boot = {
  kernelPackages = pkgs.linuxPackages_latest;
  loader.grub = {
    enable = true;
    device = "nodev";
    useOSProber = false;
    enableCryptodisk = true;
    efiSupport = true;
    default = "2";
    extraConfig = ''
      timeout=-1
      GRUB_GFXMODE=2560x1600x128,auto
      menuentry "Reboot" {
        reboot
      }
      menuentry "Poweroff" {
        halt
      }
    '';
    extraEntries = ''
    ### WINDOWS — INTERNAL P1 DRIVE
    menuentry "Windows 11 (Odin)" --class windows --class os {
    insmod part_gpt
    insmod fat
    search --no-floppy --fs-uuid --set=root 32C3-FBCE
    chainloader /efi/Microsoft/Boot/bootmgfw.efi
    }
    ### MANJARO LINUX — BASE ENTRY
    menuentry "Manjaro Linux" --class manjaro --class os {
    insmod part_gpt
    insmod ext2
    search --no-floppy --fs-uuid --set=root 8a372059-10f1-48ea-ad90-3dee0fad4b28
    linux /boot/vmlinuz-6.1-x86_64 root=UUID=8a372059-10f1-48ea-ad90-3dee0fad4b28 rw quiet apparmor=1 security=apparmor udev.log_priority=3
    initrd /boot/amd-ucode.img /boot/initramfs-6.1-x86_64.img
    }
    ### MANJARO LINUX — ADVANCED MENU
    submenu "Advanced options for Manjaro Linux" {
    menuentry "Manjaro (normal)" {
      insmod part_gpt
      insmod ext2
      search --no-floppy --fs-uuid --set=root 8a372059-10f1-48ea-ad90-3dee0fad4b28
      linux /boot/vmlinuz-6.1-x86_64 root=UUID=8a372059-10f1-48ea-ad90-3dee0fad4b28 rw quiet apparmor=1 security=apparmor udev.log_priority=3
      initrd /boot/amd-ucode.img /boot/initramfs-6.1-x86_64.img
    }
    menuentry "Manjaro (Kernel 6.1.12-1)" {
      insmod part_gpt
      insmod ext2
      search --no-floppy --fs-uuid --set=root 8a372059-10f1-48ea-ad90-3dee0fad4b28
      linux /boot/vmlinuz-6.1-x86_64 root=UUID=8a372059-10f1-48ea-ad90-3dee0fad4b28 rw quiet apparmor=1 security=apparmor udev.log_priority=3
      initrd /boot/amd-ucode.img /boot/initramfs-6.1-x86_64.img
    }
    menuentry "Manjaro (fallback initramfs)" {
      insmod part_gpt
      insmod ext2
      search --no-floppy --fs-uuid --set=root 8a372059-10f1-48ea-ad90-3dee0fad4b28
      linux /boot/vmlinuz-6.1-x86_64 root=UUID=8a372059-10f1-48ea-ad90-3dee0fad4b28 rw quiet apparmor=1 security=apparmor udev.log_priority=3
      initrd /boot/initramfs-6.1-x86_64-fallback.img
    }
    menuentry "Memory Test (Manjaro)" {
      insmod part_gpt
      insmod ext2
      search --no-floppy --fs-uuid --set=root 8a372059-10f1-48ea-ad90-3dee0fad4b28
      linux /boot/memtest86+/memtest.efi
    }
    }
    '';
  };
  loader.efi.canTouchEfiVariables = true;
  loader.grub.theme = pkgs.stdenv.mkDerivation {
    pname = "distro-grub-themes";
    version = "3.1";
    src = pkgs.fetchFromGitHub {
      owner = "AdisonCavani";
      repo = "distro-grub-themes";
      rev = "v3.1";
      hash = "sha256-ZcoGbbOMDDwjLhsvs77C7G7vINQnprdfI37a9ccrmPs=";
    };
    installPhase = "cp -r customize/thinkpad $out";
  };
};

swapDevices = [{device = "/swapfile"; size = 32000;}];

security = {
  rtkit.enable = true;
  pam.services.hyprland.enableGnomeKeyring = true;
};

virtualisation = {
  libvirtd.enable = true;
  virtualbox.host.enable = true;
};

systemd.services.libvirtd.stopIfChanged = false;

networking = {
  hostName = "P1G8";
  networkmanager = {
    enable = true;
    unmanaged = [ "enp177s0" "enp177s0u1c2" ];
  };
  useDHCP = false;
  interfaces.wlp0s20f3.useDHCP = true;
  interfaces.enp177s0.useDHCP = false;
  interfaces.enp177s0u1c2 = {    # electric eel adapter 2025-12-04
    ipv4.addresses = [{
      address = "169.254.1.1";   # or "192.168.1.100"
      prefixLength = 16;         # or 24 for 192.168.x.x
    }];
    useDHCP = false;
  };
}; 

systemd.network.wait-online.enable = false;
systemd.services.NetworkManager-wait-online.enable = false;
systemd.services."systemd-networkd-wait-online".enable = false;

time.timeZone = "America/Los_Angeles";

i18n = {
  defaultLocale = "en_US.UTF-8";
};

console = {
  font = "Lat2-Terminus16";
  keyMap = "us";
};

fonts = {
  packages = with pkgs; [ carlito dejavu_fonts ipafont kochi-substitute liberation_ttf nerd-fonts.symbols-only noto-fonts-cjk-sans source-code-pro ttf_bitstream_vera ];
  fontconfig.defaultFonts = {
    monospace = [
      "DejaVu Sans Mono"
      "IPAGothic"
    ];
    sansSerif = [
      "DejaVu Sans"
      "IPAPGothic"
    ];
    serif = [
      "DejaVu Serif"
      "IPAPMincho"
    ];
  };
};

environment.variables = {
  QT_QPA_PLATFORMTHEME = "qt5ct";
  XDG_ICON_FALLBACK = "/etc/nixos/dotfiles/images/blankicon.png";
};

environment.sessionVariables = {
  WLR_RENDERER = "vulkan";
  WLR_NO_HARDWARE_CURSORS = "1";
  __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  LIBVA_DRIVER_NAME = "nvidia";
  GBM_BACKENDS_PATH = "/run/opengl-driver/lib/gbm";
  HYPR_PLUGIN_DIR = pkgs.symlinkJoin {
    name = "hyprland-plugins";
    paths = with pkgs.hyprlandPlugins; [
      #hyprexpo
      #...plugins
    ];
  };
};

nixpkgs.config.qt5 = {
  enable = true;
  platformTheme = "qt5ct";
  style = {
    package = pkgs.kvantum-catppuccin;
    name = "kvantum";
  };
};

services.syncthing = {
  enable = true;
  user = "joe";
  group = "users";
  dataDir = "/home/joe/.local/share/syncthing";
};

services = {
  udisks2.enable = true;
  xserver = {
    videoDrivers = [ "nvidia" ];
    enable = true;
    xkb.layout = "us";
    xkb.model = "us";
    desktopManager = {
      runXdgAutostartIfNone = true;
    };
  };
  libinput = {
    enable = true;
    touchpad = { 
      disableWhileTyping = true;
      naturalScrolling = true;
    };
    mouse = {
     accelProfile = "flat";
     accelSpeed = "0.0";
    };
  };
  fstrim.enable = true;
  fwupd.enable = true;
  tlp.enable = true;
  tlp.settings = { 
    START_CHARGE_THRESH_BAT0 = 90; 
    STOP_CHARGE_THRESH_BAT0 = 95; 
  };
  openssh.enable = true;
  udev.extraRules = ''
  # GCC adapter
    SUBSYSTEM=="usb", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="0666"
  # Teensy 4.1
    # Teensy boards (PJRC)
    ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04*", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"
    ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789a]*", ENV{MTP_NO_PROBE}="1"

    # USB serial
    KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04*", MODE:="0666"

    # hidraw access
    KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04*", MODE:="0666"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04*", MODE:="0666"

    # NXP boards also used by Teensy 4.x bootloader
    KERNEL=="hidraw*", ATTRS{idVendor}=="1fc9", ATTRS{idProduct}=="013*", MODE:="0666"
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="1fc9", ATTRS{idProduct}=="013*", MODE:="0666"
  '';
  printing.enable = true;
  gnome.gnome-keyring.enable = true;
  blueman.enable = true;
  pulseaudio.enable = false;
  pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
    #wireplumber.extraConfig."90-disable-hsp-hfp" = {
    #  "wireplumber.settings" = {
    #    "bluetooth.disabled-profiles" = [
    #      "hsp_hf"
    #      "hsp_ag"
    #      "hfp_hf"
    #      "hfp_ag"
    #    ];
    #  };
    #};
    #wireplumber.extraConfig."20-force-sbc" = {
    #  "wireplumber.settings" = {
    #    "bluetooth.codecs" = [ "sbc" ];
    #  };
    #};
  };
  displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      theme = "catppuccin-mocha-mauve";
      package = pkgs.kdePackages.sddm;
    };
    sessionPackages = [ pkgs.hyprland ];
    defaultSession = "hyprland";
    autoLogin = {
      enable = true;
      user = "joe";
    };
  };
};

powerManagement = {
# cpufreq = {
#    min = 800000;
#    max = 4770000;
#  };
  cpuFreqGovernor = "ondemand";
};

hardware = {
  nvidia = {
    modesetting.enable = true;
    open = true; # req'd for Blackwell
    nvidiaSettings = true;
    powerManagement.enable = false;
    #package = config.boot.kernelPackages.nvidiaPackages.stable;
    package = config.boot.kernelPackages.nvidiaPackages.stable // {
      open = config.boot.kernelPackages.nvidiaPackages.stable.open.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          (pkgs.fetchpatch {
            name = "get_dev_pagemap.patch";
            url = "https://github.com/NVIDIA/open-gpu-kernel-modules/commit/3e230516034d29e84ca023fe95e284af5cd5a065.patch";
            hash = "sha256-BhL4mtuY5W+eLofwhHVnZnVf0msDj7XBxskZi8e6/k8=";
          })
        ];
      });
    };
    #prime = {
    #  sync.enable = false;
    #  offload.enable = false;
    #  intelBusId = "PCI:0:2:0";
    #  nvidiaBusId = "PCI:1:0:0";
    #};
  };
  cpu.intel = {
    updateMicrocode = true;
  };
  bluetooth = {
    enable = true;
    hsphfpd.enable = false;
  };
  graphics = {
    enable = true;
    enable32Bit = true;
  };
  enableAllFirmware = true;
  trackpoint = {
    emulateWheel = true;
    speed = 97; # 97 default
    sensitivity = 128; # 128 default
  };
};

xdg = {
  portal = {
    enable = true;
    extraPortals = with pkgs; [xdg-desktop-portal-gtk];
  };
};

security = {
  polkit.enable = true;
  sudo.enable = false;
  doas = {
    enable = true;
    wheelNeedsPassword = false;
    extraRules = [{
      groups = [ "doas" ];
      noPass = true;
      keepEnv = true;
      users = [ "joe" ];
    }];
  };
};

users = {
  defaultUserShell = pkgs.zsh;
  users.joe = {
    isNormalUser = true;
    extraGroups = [
      "adbusers"	# access to android debug stuff
      "dialout"		# access to serial ports
      "libvirtd"	# access to libvirt VM management
      "audio"		# access to audio devices
      "disk"		# access to raw disk devices
      "video"		# access to video devices
      "power"		# access to power management
      "plugdev"		# access to removable devices
      "network"		# access to network interface
      "wheel"		# access to sudo
      "input"		# access to input devices
      "uinput"		# access to virtual input devices
      "vboxusers"	# access to VirtualBox features
    ];
  };
}; 

environment.systemPackages = with pkgs; [ # system-level apps

# HARDWARE + DRIVERS + EXTERNAL DEVICES
  acpid # watch ACPI events
  alsa-utils # sound utils
  android-tools # contrains ADB, fastboot, etc
  brightnessctl # control laptop display backlight
  jmtpfs # allows for Android MTP; use instead of mtpfs
  lm_sensors # tons of hardware sensors
  lshw # list hardware inventory
  pciutils # contains PCI tools like lspci
  powertop # Intel-only power tuning/analyzer
  udisks2 # for mounting disks from userland

# UTILS
  bash # shell
  bc # calculations
  btop # like htop but nicer
  cachix # binary cache
  cpufrequtils # cpu frequency control/query
  curl # download web stuff
  dislocker # unlock Bitlocker encryption
  file # determines file type/info
  git # distributed version control system
  htop # view resource usage
  id3v2 # view/edit mp3 metadata
  inetutils # network tools such as telnet
  iotop # view disk usage/processes
  killall # allows for killing processes by name
  moreutils # useful UNIX tools: ts, sponge, vidir, etc.
  neovim # vim with more goodness
  nixos-option # query NixOS module options
  ntfs3g # allows to read/write NTFS
  p7zip # 7z/rar/zip compression tool
  ranger # TUI file browser
  s-tui # terminal TUI for CPU temp/power/freq
  stress # hardware stress tool
  tmux # terminal multiplexer
  traceroute # traces network hops
  unzip # extracting .zip files
  vim # the best text editor
  wget # network downloader
  
# LIBRARIES
  libarchive # tools for tar, zip, etc.
  libguestfs-with-appliance # view/modify VM disk images
  libnotify # desktop notification library
  libsForQt5.qtstyleplugin-kvantum # kvantum = qt config tool
  libsForQt5.qt5ct # qt config tool
  libsForQt5.qtstyleplugin-kvantum # kvantum qt config tool

# LOGIN STUFF FOR USERS
  catppuccin-sddm # nice sddm themes

# AGS stuff
  ags
  astal.astal3
  astal.hyprland
  astal.mpris
  astal.battery
  astal.wireplumber
  astal.network

# PACKAGE OVERRIDES
  (catppuccin-sddm.override {
    flavor = "macchiato";
    accent = "mauve";
    font  = "Noto Sans";
    fontSize = "14";
    background = "/etc/nixos/dotfiles/wallpapers/apple-dark.jpg";
    loginBackground = false;
    userIcon = true;
  })
];

################################################
########## DO NOT EVER CHANGE THIS #############
################################################
system.stateVersion = "25.05";
################################################
}########## END OF CONF.NIX # ##################
################################################
