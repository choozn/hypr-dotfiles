backupfolder="hypr_backup_$(date +'%Y-%m-%d_%H-%M-%S')"
backuppath="$HOME/.config/$backupfolder"
mkdir $backuppath
cp -r $HOME/.config/hypr/ $backuppath/hypr/
cp $HOME/.zshrc $backuppath/.zshrc
cp -r $HOME/.config/alacritty $backuppath/alacritty
