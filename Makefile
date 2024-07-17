prefix ?= /usr/local
bindir = $(prefix)/bin
CONFIG_DIR=$(HOME)/.config/scripts/theme-switcher

build:
	swift build -c release --disable-sandbox

install: build
	install -d "$(bindir)"
	install ".build/release/theme-switcher" "$(bindir)"
	mkdir -p $(CONFIG_DIR)
	cp set_theme.sh $(CONFIG_DIR)
	cp set_theme.fish $(CONFIG_DIR)

uninstall:
	rm -rf "$(bindir)/theme-switcher"

clean:
	rm -rf .build

.PHONY: build install uninstall clean
