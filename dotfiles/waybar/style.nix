{colorscheme}:
with colorscheme.colors; let
  OSLogo = builtins.fetchurl rec {
    name = "OSLogo-${sha256}.png";
    sha256 = "14mbpw8jv1w2c5wvfvj8clmjw0fi956bq5xf9s2q3my14far0as8";
    url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/master/logo/nix-snowflake.svg";
  };
in ''
* {
    border: none;
    border-radius: 0px;
    font-family: "DejaVu Sans Mono", FontAwesome, "Noto Sans CJK"; 
    font-size: 14px;
    font-style: normal;
    min-height: 0;
}

window#waybar {
    background: rgba(12, 14, 15, 0.85);
    border-bottom: 0px;
    color: #cdd6f4;
}

#workspaces {
    background-color: rgba(12, 14, 15, 0.9);
    color: #cdd6f4;
    padding: 6px 15px;
    margin: 0px 3px;
    border-radius: 8px;
    border-bottom: 2px solid #5D4A78;
}

#workspaces button {
    padding: 0px 5px;
    margin: 5px 4px;
    border-radius: 6px;
    color: #7f849c;
    background-color: transparent;
    transition: all 0.2s ease;
    border: 1px solid #45475a;
}

#workspaces button.active { 
    color: #1e1e2e;
    background: linear-gradient(135deg, #bdc6e4, #a6adc8);
    border: 1px solid #89b4fa;
}

#workspaces button:hover {
    background-color: #313244;
}

#clock, #battery, #network, #pulseaudio, #temperature, #cpu, #memory,
#custom-diskuse, #custom-p1g8power, #custom-energy, #custom-cooling,
#tray, #backlight {
    color: #cdd6f4;
    background-color: rgba(12, 14, 15, 0.9);
    border-radius: 8px;
    padding: 0px 15px;
    margin: 0px 3px;
    border-bottom: 2px solid #5D4A78;
}

#battery.warning:not(.charging) {
    color: #f9e2af;
}

#battery.critical:not(.charging) {
    color: #f38ba8;
}

#custom-launcher {
    color: #5af0ff;
    background-color: rgba(12, 14, 15, 0.9);
    border-radius: 8px;
    margin: 0px 3px;
    padding: 0px 10px;
    font-size: 22px;
    border-bottom: 2px solid #5D4A78;
}

#window {
    background: rgba(12, 14, 15, 0.9);
    padding: 0px 20px;
    border-radius: 8px;
    margin-top: 5px;
    margin-bottom: 5px;
    font-weight: normal;
    font-style: normal;
    border-bottom: 2px solid #5D4A78;
}
''
