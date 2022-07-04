RM=/usr/bin/rm --force --recursive
CP=/usr/bin/cp --recursive
MKDIR=/usr/bin/mkdir -p
MKPKG=/usr/bin/makepkg
TOOLCHAIN=arm-linux-gnueabihf
GEN_FILES=pkg src *.tar.xz *.tar.xz *.tar.xz.sig *.pkg.tar.zst
PACK_LIST=binutils gcc-stage1 glibc-headers gcc-stage2 glibc gcc
TAR_FILES=Makefile $(TOOLCHAIN)-*


all: build
	@

%_exc: $(addprefix %.,$(PACK_LIST))
	@

build: build_exc
	@

build.%:
	@cd $(TOOLCHAIN)-$*; \
	( echo "y"; echo "y" ) | $(MKPKG) --install

download: download_exc
	@

download.%:
	@cd $(TOOLCHAIN)-$*; \
	$(MKPKG) --verifysource --force

clean: clean_exc
	@

clean.%:
	@echo "Package $(TOOLCHAIN)-$* clean"
	@cd $(TOOLCHAIN)-$*; \
	$(RM) $(GEN_FILES)

updpkgsums: updpkgsums_exc
	@

updpkgsums.%:
	@echo "Package $(TOOLCHAIN)-$* checksums update"
	@cd $(TOOLCHAIN)-$*; \
	updpkgsums

srcinfo: updsrcinfo_exc
	@

updsrcinfo.%:
	@echo "Package $(TOOLCHAIN)-$* .SRCINFO update"
	@cd $(TOOLCHAIN)-$*; \
	$(MKPKG) --printsrcinfo > .SRCINFO

selfpack:
	@echo "$(TOOLCHAIN).tar.gz created"
	@$(RM) $(TOOLCHAIN).tar.gz
	@tar --create --gzip \
             --exclude="src"           \
             --exclude="pkg"           \
             --exclude=".git"          \
             --exclude=".gitignore"    \
             --exclude=".gitmodules"   \
             --exclude="*.tar.xz"      \
             --exclude="*.tar.xz.sig"  \
             --exclude="*.pkg.tar.zst" \
             --transform 's,^,$(TOOLCHAIN)/,' \
             --file $(TOOLCHAIN).tar.gz $(TAR_FILES)

remove:
	sudo pacman --remove --noconfirm \
	     $(shell pacman -Qq $(addprefix $(TOOLCHAIN)-,$(PACK_LIST)) )

tmp:
	@echo "$(notdir $(shell pwd))"
