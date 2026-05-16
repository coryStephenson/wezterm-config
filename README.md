# wezterm-config
My WezTerm Config 

## On Ubuntu Desktop VM in VirtualBox

```console
sudo apt install flatpak
sudo apt install gnome-software-plugin-flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
# Restart system
flatpak install flathub org.wezfurlong.wezterm
cd ~
cat > .bash_aliases
alias wezterm='flatpak run org.wezfurlong.wezterm'
# Press Ctrl + D for EOF
source ~/.bash_aliases
cd .config
mkdir wezterm
cd wezterm
cat > wezterm.lua
# Paste contents of wezterm.lua from this GitHub repo
# Press Ctrl + D for EOF
wezterm
```


