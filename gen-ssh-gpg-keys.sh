stty sane # prevent the ^M on enter issue
read -p "Name: " name
read -p "Email: " email

echo "-----------------------  SSH KEY  ------------------------"

echo "\n" | ssh-keygen -t ed25519 -C "$email" -N "" > /dev/null

eval "$(ssh-agent -s)" > /dev/null

ssh-add ~/.ssh/id_ed25519 > /dev/null 2>&1

cat ~/.ssh/id_ed25519.pub

echo "-----------------------  GPG KEY  ------------------------"

gpg --quick-generate-key "$name <$email>" rsa4096 default never > /dev/null

gpgkey=$(gpg --list-secret-keys --keyid-format LONG | grep -B 2 $name | grep 'sec\s*rsa4096' | sed 's/\//\ /g' | awk -F " " 'NR==1{print $3}') > /dev/null 2>&1

gpg --armor --export $gpgkey > /dev/null

git config --global user.signingkey $gpgkey > /dev/null

echo "----------------------------------------------------------"
