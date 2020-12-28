install_pkg() {
    # This could def use community support
    if [ -x "$(command -v apt-get)" ]; then
        sudo apt-get install $1 -y

    elif [ -x "$(command -v brew)" ]; then
        brew install $1

    elif [ -x "$(command -v pkg)" ]; then
        sudo pkg install $1

    elif [ -x "$(command -v pacman)" ]; then
        sudo pacman -S $1

    elif [ -x "$(command -v dnf)" ]; then
        sudo dnf install -y $1

    else
        echo "Unknown package manager"
        exit -1
    fi
}
