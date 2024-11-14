# INSTALL NEOVIM

## ubuntu

`sudo apt update`

`sudo apt install neovim -y`

### ubuntu install last version neovim

`sudo add-apt-repository ppa:neovim-ppa/stable`
`sudo apt update`
`sudo apt install neovim -y`

## macos

`/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`

`brew install neovim`

## INSTALL vim-plug

`curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim`

## CONFIGURE NEOVIM

`mkdir -p ~/.config/nvim`
`cp init.vim ~/.config/nvim/init.vim`

## INSTALL GOLANG

### ubuntu

`sudo apt update && sudo apt install golang-go -y`

### macos

`brew install go`

check install golang: `go version`

install gopls: `go install golang.org/x/tools/gopls@latest`

`echo 'export PATH=$PATH:$(go env GOPATH)/bin' >> ~/.bashrc`
`source ~/.bashrc`

install delve (debugger for golang apps): `go install github.com/go-delve/delve/cmd/dlv@latest`

In neovim command: `:CocInstall coc-go` && `:PlugInstall`

#### Установка шрифтов с поддержкой иконок

Для корректного отображения иконок файлов и папок рекомендуется установить шрифты, поддерживающие иконки, такие как Nerd Fonts.

Как установить Nerd Fonts:
Перейдите на сайт Nerd Fonts.

Выберите понравившийся шрифт. Например, FiraCode Nerd Font.

Скачайте и установите шрифт согласно инструкции на сайте:

##### Для macOS: Распакуйте скачанный файл и дважды кликните по нему, затем нажмите "Установить шрифт".

##### Для Ubuntu:

Распакуйте скачанный файл.

Скопируйте файлы шрифтов в директорию `~/.local/share/fonts/` или `/usr/share/fonts/`.

Обновите кеш шрифтов:

`fc-cache -fv`

Настройте ваш терминал или NeoVIM на использование установленного шрифта.

##### Switching between coloschemas

`:colorscheme dracula`
