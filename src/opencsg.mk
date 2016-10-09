# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := opencsg
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.2
$(PKG)_CHECKSUM := d952ec5d3a2e46a30019c210963fcddff66813efc9c29603b72f9553adff4afb
$(PKG)_SUBDIR   := OpenCSG-$($(PKG)_VERSION)
$(PKG)_FILE     := OpenCSG-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.opencsg.org/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc freeglut glew qt

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.opencsg.org/#download' | \
    grep 'OpenCSG-' | \
    $(SED) -n 's,.*OpenCSG-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)/src' && '$(PREFIX)/$(TARGET)/qt/bin/qmake' src.pro
    $(MAKE) -C '$(1)/src' -j '$(JOBS)'
    $(INSTALL) -m644 '$(1)/include/opencsg.h' '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/lib/libopencsg.a' '$(PREFIX)/$(TARGET)/lib/'

    cd '$(1)/example' && '$(PREFIX)/$(TARGET)/qt/bin/qmake' example.pro
    $(MAKE) -C '$(1)/example' -j '$(JOBS)'
    $(INSTALL) -m755 '$(1)/example/release/opencsgexample.exe' '$(PREFIX)/$(TARGET)/bin/test-opencsg.exe'
endef

define $(PKG)_BUILD_SHARED
    cd '$(1)/src' && '$(PREFIX)/$(TARGET)/qt/bin/qmake' CONFIG+=dll src.pro

    # make the names match MXE/cygwin standard convention, overriding qmake
    $(SED) -i 's,opencsg1.dll,libopencsg-1.dll,' '$(1)/src/Makefile.Release' 
    $(SED) -i 's,libopencsg1.a,libopencsg.dll.a,' '$(1)/src/Makefile.Release' 
    $(SED) -i 's,opencsg1.dll,libopencsg-1.dll,' '$(1)/src/Makefile' 
    $(SED) -i 's,libopencsg1.a,libopencsg.dll.a,' '$(1)/src/Makefile' 
    $(SED) -i 's,opencsg1.dll,libopencsg-1.dll,' '$(1)/src/Makefile.Debug' 
    $(SED) -i 's,libopencsg1.a,libopencsg.dll.a,' '$(1)/src/Makefile.Debug' 

    $(MAKE) -C '$(1)/src' -j '$(JOBS)'

    $(INSTALL) -m644 '$(1)/include/opencsg.h' '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/lib/libopencsg-1.dll' '$(PREFIX)/$(TARGET)/bin/'
    $(INSTALL) -m644 '$(1)/lib/libopencsg.dll.a' '$(PREFIX)/$(TARGET)/lib/'

    cd '$(1)/example' && '$(PREFIX)/$(TARGET)/qt/bin/qmake' example.pro
    $(MAKE) -C '$(1)/example' -j '$(JOBS)'
    $(INSTALL) -m755 '$(1)/example/release/opencsgexample.exe' '$(PREFIX)/$(TARGET)/bin/test-opencsg.exe'
endef
