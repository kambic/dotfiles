
kwriteconfig6 --file kdeglobals \
  --group General \
  --key TerminalApplication kitty

kwriteconfig6 --file kdeglobals \
  --group General \
  --key TerminalService org.kde.kitty.desktop

mkdir -p ~/.local/share/kio/servicemenus
nano ~/.local/share/kio/servicemenus/kitty-here.desktop



[Desktop Entry]
Type=Service
MimeType=inode/directory;
Actions=kitty_here;
X-KDE-ServiceTypes=KonqPopupMenu/Plugin

[Desktop Action kitty_here]
Name=Open Terminal Here
Exec=kitty --directory %f
Icon=kitty


kreadconfig6 --file kdeglobals --group General --key TerminalApplication

