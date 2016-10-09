# This file is part of MXE.
# See index.html for further information.

PKG             := lib3mf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 20160218T183543.gita466df4
$(PKG)_CHECKSUM := 28703467797e39e590d8fbdcc43b726286603c8862649b814d11c043e7b6dce1
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/t-paul/lib3mf/archive/a466df47231c02298dde295adb6075b0fc649eba/$($(PKG)_FILE)
$(PKG)_SUBDIR   := lib3mf-a466df47231c02298dde295adb6075b0fc649eba
$(PKG)_DEPS     := gcc

define $(PKG)_BUILD
    $(MAKE) -C '$(1)'/Project/Lib3MFGCC -j '$(JOBS)' \
        AR=$(TARGET)-ar \
        CC=$(TARGET)-gcc \
        CXX="$(TARGET)-g++ -v" \
        LD=$(TARGET)-g++ \
        INSTALL_ROOT='$(PREFIX)/$(TARGET)' \
        INSTALL_BUILD_TYPE=Release \
        OUT_RELEASE=bin/Release/lib3MF.a \
        release_static
    $(MAKE) -C '$(1)'/Project/Lib3MFGCC \
        AR=$(TARGET)-ar \
        CC=$(TARGET)-gcc \
        CXX=$(TARGET)-g++ \
        LD=$(TARGET)-g++ \
        INSTALL_ROOT='$(PREFIX)/$(TARGET)' \
        INSTALL_BUILD_TYPE=Release \
        OUT_RELEASE=bin/Release/lib3MF.a \
        install
endef
