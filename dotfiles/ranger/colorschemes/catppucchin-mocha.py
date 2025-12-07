# Catppuccin Mocha colorscheme for ranger
# Save to ~/.config/ranger/colorschemes/catppuccin-mocha.py

from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import *

class catppuccin_mocha(ColorScheme):
    progress_bar_color = 137  # Lavender
    
    def use(self, context):
        fg, bg, attr = default_colors
        
        # Catppuccin Mocha colors
        rosewater = 217
        flamingo = 216
        pink = 212
        mauve = 183
        red = 210
        maroon = 167
        peach = 215
        yellow = 186
        green = 151
        teal = 117
        sky = 153
        sapphire = 116
        blue = 111
        lavender = 147
        
        text = 231
        subtext1 = 189
        subtext0 = 181
        overlay2 = 152
        overlay1 = 145
        overlay0 = 138
        surface2 = 102
        surface1 = 95
        surface0 = 59
        base = 234
        mantle = 233
        crust = 232
        
        if context.reset:
            return default_colors
        
        elif context.in_browser:
            if context.selected:
                attr = reverse
            else:
                attr = normal
            
            if context.empty or context.error:
                fg = red
            
            if context.border:
                fg = overlay0
            
            if context.media:
                if context.image:
                    fg = yellow
                else:
                    fg = peach
            
            if context.container:
                fg = mauve
            
            if context.directory:
                attr |= bold
                fg = blue
            
            elif context.executable and not \
                    any((context.media, context.container)):
                attr |= bold
                fg = green
            
            if context.socket:
                fg = pink
                attr |= bold
            
            if context.fifo or context.device:
                fg = yellow
                if context.device:
                    attr |= bold
            
            if context.link:
                fg = teal if context.good else red
            
            if context.tag_marker and not context.selected:
                attr |= bold
                if fg in (red, peach):
                    fg = white
                else:
                    fg = red
            
            if not context.selected and (context.cut or context.copied):
                fg = overlay0
                attr |= bold
            
            if context.main_column:
                if context.selected:
                    attr |= bold
                if context.marked:
                    attr |= bold
                    fg = yellow
            
            if context.badinfo:
                if attr & reverse:
                    bg = red
                else:
                    fg = red
        
        elif context.in_titlebar:
            attr |= bold
            if context.hostname:
                fg = lavender
            elif context.directory:
                fg = blue
            elif context.tab:
                if context.good:
                    fg = green
            elif context.link:
                fg = teal
        
        elif context.in_statusbar:
            if context.permissions:
                if context.good:
                    fg = green
                elif context.bad:
                    fg = red
            
            if context.marked:
                attr |= bold | reverse
                fg = yellow
            
            if context.message:
                if context.bad:
                    attr |= bold
                    fg = red
            
            if context.loaded:
                bg = self.progress_bar_color
        
        if context.text:
            if context.highlight:
                attr |= reverse
        
        if context.in_taskview:
            if context.title:
                fg = blue
            
            if context.selected:
                attr |= reverse
            
            if context.loaded:
                if context.selected:
                    fg = self.progress_bar_color
                else:
                    bg = self.progress_bar_color
        
        return fg, bg, attr
