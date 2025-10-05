# Dotfiles Makefile with Backup

STOW = stow
PACKAGES = bash zsh config local
DATE := $(shell date +%Y%m%d-%H%M%S)
BACKUP_DIR := $(HOME)/dotfiles-backup-$(DATE)

.PHONY: help stow unstow restow adopt status diff backup

help:
	@echo "Dotfiles Makefile"
	@echo ""
	@echo "Usage:"
	@echo "  make stow           # Stow all packages"
	@echo "  make unstow         # Unstow all packages"
	@echo "  make restow         # Restow all packages"
	@echo "  make adopt          # Adopt unmanaged files into dotfiles (with backup)"
	@echo "  make status         # Show non-symlinks and unmanaged files"
	@echo "  make diff           # Show differences between live files and dotfiles"
	@echo "  make backup         # Backup any conflicting files before adopt/stow"

stow:
	@for pkg in $(or $(PKG),$(PACKAGES)); do \
		echo "🔗 Stowing $$pkg"; \
		$(STOW) $$pkg; \
	done

unstow:
	@for pkg in $(or $(PKG),$(PACKAGES)); do \
		echo "🧹 Unstowing $$pkg"; \
		$(STOW) -D $$pkg; \
	done

restow:
	@for pkg in $(or $(PKG),$(PACKAGES)); do \
		echo "♻️ Restowing $$pkg"; \
		$(STOW) --restow $$pkg; \
	done

adopt: backup
	@for pkg in $(or $(PKG),$(PACKAGES)); do \
		echo "📥 Adopting $$pkg (with backup)"; \
		$(STOW) --adopt $$pkg; \
	done

backup:
	@echo "💾 Backing up files that will be replaced..."
	@mkdir -p "$(BACKUP_DIR)"
	@for pkg in $(or $(PKG),$(PACKAGES)); do \
		find $$pkg -type f | while read file; do \
			target="$(HOME)/$$(echo "$$file" | sed "s|^$$pkg/||")"; \
			if [ -e "$$target" ] && [ ! -L "$$target" ]; then \
				dest_dir="$(BACKUP_DIR)/$$(dirname "$$target" | sed "s|^$$HOME/||")"; \
				mkdir -p "$$dest_dir"; \
				cp -p "$$target" "$$dest_dir/"; \
				echo "  🧯 Backed up $$target → $$dest_dir/"; \
			fi; \
		done \
	done
