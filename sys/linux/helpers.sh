PKG_TYPE=
if [ -x "$(command -v apt-get)" ]; then
  PKG_TYPE="apt"
elif [ -x "$(command -v brew)" ]; then
  PKG_TYPE="brew"

elif [ -x "$(command -v pkg)" ]; then
  PKG_TYPE="pkg"

elif [ -x "$(command -v pacman)" ]; then
  PKG_TYPE="pacman"

elif [ -x "$(command -v dnf)" ]; then
  PKG_TYPE="dnf"

else
  echo "Unknown package manager"
  exit -1
fi

install_pkg() {
  if [ "$PKG_TYPE" == "apt" ] ; then
    sudo apt-get install $* -y
  elif [ "$PKG_TYPE" == "brew" ]; then
    brew install $*
  elif [ "$PKG_TYPE" == "pkg" ]; then
    sudo pkg install $*
  elif [ "$PKG_TYPE" == "pacman" ]; then
    sudo pacman -S $*
  elif [ "$PKG_TYPE" == "dnf" ]; then
    sudo dnf install -y $*
  else
    echo "Unknown package manager!"
    exit -1
  fi
}

check_update_pkg() {
  if [ "$PKG_TYPE" == "apt" ] ; then
    sudo apt update
  elif [ "$PKG_TYPE" == "brew" ]; then
    echo "check_update_pkg: not suppported"
  elif [ "$PKG_TYPE" == "pkg" ]; then
    echo "check_update_pkg: not suppported"
  elif [ "$PKG_TYPE" == "pacman" ]; then
    echo "check_update_pkg: not suppported"
  elif [ "$PKG_TYPE" == "dnf" ]; then
    sudo dnf check-update
  else
    echo "Unknown package manager!"
    exit -1
  fi
}
