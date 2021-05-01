SHELL=/bin/bash
DOTFILES = .alacritty.yml .asdf .tool-versions .tmux.conf .vim .vimrc .zplug .zshrc .zsh_prompt

.PHONY: clean $(DOTFILES)

all: clean install
install: alacritty tmux tool-versions asdf vim zsh
clean: $(foreach f, $(DOTFILES), remove-$(f))

alacritty: $(foreach f, $(filter .alacritty.yml, $(DOTFILES)), link-$(f))

tmux: $(foreach f, $(filter .tmux.conf, $(DOTFILES)), link-$(f))

tool-versions: $(foreach f, $(filter .tool-versions, $(DOTFILES)), link-$(f))

asdf:
ifeq (,$(wildcard $(HOME)/.asdf))
	git clone https://github.com/asdf-vm/asdf.git $(HOME)/.asdf
endif
	@. $(HOME)/.asdf/asdf.sh && asdf plugin add golang || true
	@. $(HOME)/.asdf/asdf.sh && asdf install

vim: $(foreach f, $(filter .vimrc, $(DOTFILES)), link-$(f)) vim-plug

vim-plug:
ifeq (,$(wildcard $(HOME)/.vim))
	curl -fLo $(HOME)/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	vim +PlugInstall +qal
endif

zsh: $(foreach f, $(filter .zsh%, $(DOTFILES)), link-$(f)) zplug

zplug:
ifeq (,$(wildcard $(HOME)/.zplug))
	git clone https://github.com/zplug/zplug $(HOME)/.zplug
endif

link-%: %
	@echo "link $(shell echo $<) -> $(HOME)/$<"
	@ln -snf $(shell pwd)/$(shell echo $<) $(HOME)/$<

remove-%: %
	@echo "remove $(HOME)/$<"
	@rm -rf $(HOME)/$<
