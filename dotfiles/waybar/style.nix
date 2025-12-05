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
    /*font-family: LigaSFMono Nerd Font, Iosevka, FontAwesome, Noto Sans CJK;*/
    font-family: FontAwesome, Noto Sans CJK; 
    font-size: 16px;
    font-style: normal;
    min-height: 0;
}

window#waybar {
    background: rgba(20, 20, 35, 0);
    border-bottom: 0px solid #0c0e0f;
    color: #582441;
}

#workspaces {
    background-color: #0c0e0f;
    color: #cdd6f4;
    padding: 6px 15px 6px 15px;
    margin: 0px 1px 0px 1px;
    border-radius: 5px;
    border-bottom: 3px solid #5D4A78;
}

#taskbar {
    padding: 0px 4px 0px 4px;
    margin: 0px 15px 0px 15px;
    border-radius: 10px;
    background: #060820;
    border: 1px solid #A25B89;
}

#workspaces button {
    padding: 0px 3px 0px 3px;
    margin: 7px 5px 7px 5px;
    border-radius: 30px;
    border-bottom: 1px solid #0c0e0f;
    color: #2f354a;
    background-color: #2f354a;
    transition: all 0.3s ease-in-out;
    border-bottom: 1px solid #FDDEFF;
    border-top: 1px solid #FDDEFF;
    border-left: 1px solid #FDDEFF;
    border-right: 1px solid #FDDEFF;
}

#workspaces button.active { 
    padding: 0px 3px 0px 3px;
    margin: 7px 5px 7px 5px;
    border-radius: 30px;
    border: 1px solid #0c0e0f;
    transition: all 0.3s ease-in-out;
    border: 1px solid #696969;
    color: #bdc6e4;
    background-color: #bdc6e4;
    background-size: 400% 400%;
    transition: all 0.3s ease-in-out;
}

#workspaces button:hover {
}

#tray {
    border-radius: 5px;
    margin: 0px 5px 0px 5px;
    background-color: #0c0e0f;
    padding: 0px 20px 0px 20px;
    border-bottom: 3px solid #5D4A78;
}

#clock {
    color: #cdd6f4;
    background-color: #0c0e0f;
    border-radius: 5px;
    margin: 0px 5px 0px 5px;
    padding: 0px 20px 0px 20px;
    font-weight: bold;
    border-bottom: 3px solid #5D4A78;
}


#battery {
    background-color: #0c0e0f;
    color: #cdd6f4;
    padding: 0px 20px 0px 20px;
    margin: 0px 5px 0px 5px;
    border-radius: 5px;
    border-bottom: 3px solid #5D4A78;
}

#battery.charging {
    color: #cdd6f4;
    background-color: #0c0e0f;
    padding: 0px 20px 0px 20px;
    margin: 0px 5px 0px 5px;
    border-radius: 5px;
    border-bottom: 3px solid #5D4A78;
}

#battery.warning:not(.charging) {
    background-color: #0c0e0f;
    border-radius: 5px;
    color: #9ece6a;
    padding: 0px 20px 0px 20px;
    margin: 0px 5px 0px 5px;
    border-bottom: 3px solid #5D4A78;
}

#backlight {
    background-color: #0c0e0f;
    color: #cdd6f4;
    border-radius: 5px 5px 5px 5px;
    padding: 0px 20px 0px 20px;
    margin: 0px 5px 0px 5px;
    border-bottom: 3px solid #5D4A78;
}

#network {
    color: #cdd6f4;
    background-color: #0c0e0f;
    border-radius: 5px;
    padding: 0px 20px 0px 20px;
    margin: 0px 5px 0px 5px;
    border-bottom: 3px solid #5D4A78;
}

#pulseaudio {
    color: #cdd6f4;
    background-color: #0c0e0f;
    border-radius: 5px 5px 5px 5px;
    padding: 0px 20px 0px 20px;
    font-weight: bold;
    margin: 0px 5px 0px 5px;
    border-bottom: 3px solid #5D4A78;
}

#pulseaudio.muted {
    color: #cdd6f4;
    border-radius: 5px 5px 5px 5px;
    padding: 0px 20px 0px 20px;
    margin: 0px 5px 0px 5px;
    font-weight: bold;
    border-bottom: 3px solid #5D4A78;
}

#custom-launcher {
    color: #5af0ff;
    background-color: #0c0e0f;
    border-radius: 5px 5px 5px 5px;
    margin: 0px 5px 0px 5px;
    padding: 0px 10px 0px 10px;
    font-size: 26px;
    border-bottom: 3px solid #5D4A78;
}

#custom-launcher button:hover {
    background-color: #FB4934;
    color: transparent;
    border-radius: 8px;
    margin-right: -10px;
    margin-left: 0px;
    border-bottom: 3px solid #5D4A78;
}

#custom-playerctl {
    color: #cdd6f4;
    background-color: #0c0e0f;
    padding: 0px 10px 0px 17px;
    margin: 0px 5px 0px 5px;
    border-radius: 5px;
    font-weight: normal;
    font-size: 24px;
    font-style: normal;
    border-bottom: 3px solid #5D4A78;
}

#custom-playerlabel {
    color: #cdd6f4;
    background-color: #0c0e0f;
    padding: 0px 20px 0px 20px;
    border-radius: 5px;
    margin: 0px 5px 0px 5px;
    font-weight: normal;
    font-style: normal;
    margin: 0px 5px 0px 5px;
    border-bottom: 3px solid #5D4A78;
}

#window {
    background: #0c0e0f;
    padding: 0px 20px 0px 20px;
    border-radius: 5px;
    /*border-left: solid 1px #282738;*/
    /*border-right: solid 1px #282738;*/
    margin-top: 5px;
    margin-bottom: 5px;
    font-weight: normal;
    font-style: normal;
    border-bottom: 3px solid #5D4A78;
}

#custom-wf-recorder {
    padding: 0px 20px 0px 20px;
    color: #e5809e;
    margin-right: 5px;
    margin-left: 5px;
    background-color: #1E1E2E;
    border-bottom: 3px solid #5D4A78;
}

#temperature {
    color: #cdd6f4;
    background-color: #0c0e0f;
    border-radius: 5px;
    margin-right: 5px;
    margin-left: 5px;
    font-weight: bold;
    padding: 0px 20px 0px 20px;
    border-bottom: 3px solid #5D4A78;
}

#cpu {
    background-color: #0c0e0f;
    color: #cdd6f4;
    border-radius: 5px;
    margin-right: 5px;
    margin-left: 5px;
    padding: 0px 20px 0px 20px;
    font-weight: bold;
    border-bottom: 3px solid #5D4A78;
}

#memory {
    background-color: #0c0e0f;
    color: #cdd6f4;
    border-radius: 5px;
    padding: 0px 20px 0px 20px;
    margin-right: 5px;
    margin-left: 5px;
    font-weight: bold;
    border-bottom: 3px solid #5D4A78;
}

#custom-diskuse {
    background-color: #0c0e0f;
    color: #cdd6f4;
    border-radius: 5px;
    margin-right: 5px;
    margin-left: 5px;
    padding: 0px 20px 0px 20px;
    font-weight: bold;
    border-bottom: 3px solid #5D4A78;
}

#custom-p1g8power {
    background-color: #0c0e0f;
    color: #cdd6f4;
    border-radius: 5px;
    margin-right: 5px;
    margin-left: 5px;
    padding: 0px 20px 0px 20px;
    font-weight: bold;
    border-bottom: 3px solid #5D4A78;
}

#custom-hyprpicker {
    background-color: #0c0e0f;
    border-radius: 5px;
    margin: 0px 5px 0px 5px;
    padding: 0px 20px 0px 20px;
    font-weight: bold;
    border-bottom: 3px solid #5D4A78;
}

#custom-energy {
    background-color: #0c0e0f;
    color: #cdd6f4;
    font-weight: bold;
    border-radius: 5px;
    margin: 0px 5px 0px 5px;
    padding: 0px 20px 0px 20px;
    border-bottom: 3px solid #5D4A78;
}

#custom-cooling {
    background-color: #0c0e0f;
    color: #cdd6f4;
    font-weight: bold;
    border-radius: 5px;
    margin: 0px 5px 0px 5px;
    padding: 0px 10px 0px 20px;
    border-bottom: 3px solid #5D4A78;
}

''
