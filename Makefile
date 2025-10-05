# Dotfiles Makefile

STOW = stow
PACKAGES = bash zsh config local

.PHONY: help all stow unstow restow adopt

help:
	@echo "Dotfiles Stow Makefile"
	@echo "Usage:"
	@echo "  make stow        # Stow all packages"
	@echo "  make unstow      # Unstow all packages"
	@echo "  make restow      # Restow all packages (force refresh)"
	@echo "  make adopt       # Adopt existing files into repo"
	@echo "  make stow PKG=package  # Stow one package"

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

adopt:
	@for pkg in $(or $(PKG),$(PACKAGES)); do \
		echo "📥 Adopting $$pkg"; \
		$(STOW) --adopt $$pkg; \
	done
