###################################################################
#                                                                 #
# Makefile for automatization AUR arm-linux-gnueabihf maintenance #
# author: Vyacheslav Razykov <v.razykov@gmail.com>                #
#                                                                 #
# run 'make help' for help                                        #
#                                                                 #
###################################################################

.DEFAULT_GOAL:=all

RM=/usr/bin/rm --force --recursive
CP=/usr/bin/cp --recursive
MKDIR=/usr/bin/mkdir -p
MKPKG=/usr/bin/makepkg
TOOLCHAIN=arm-linux-gnueabihf
GEN_FILES=pkg src *.tar.xz *.tar.xz *.tar.xz.sig *.pkg.tar.zst
PACK_LIST=binutils gcc-stage1 glibc-headers gcc-stage2 glibc gcc
TAR_FILES=Makefile $(TOOLCHAIN)-*


##<    help		- print this message
.PHONY: help
help: Makefile
	@echo 'usage: make [target]'
	@echo
	@echo 'targets:'
	@sed -n 's/^##<//p' $<
	@echo
	@echo 'packages:'
	@echo '    $(PACK_LIST)'

##<    all			- same as build (default target)
.PHONY: all
all: build
	@

%_exc: $(addprefix %.,$(PACK_LIST))
	@

##<    build		- build and install all packages
.PHONY: build
build: build_exc
	@

##<    build.<package>	- build and install <package>
##<    			    not work if depencieses isn't installed
.PHONY: build.%
build.%:
	@cd $(TOOLCHAIN)-$*; \
	( echo 'y'; echo 'y' ) | $(MKPKG) --install

##<    download		- download sources for all packages
.PHONY: download
download: download_exc
	@

##<    download.<package>	- download sources for <package>
.PHONY: download.<package>
download.%:
	@cd $(TOOLCHAIN)-$*; \
	$(MKPKG) --verifysource --force

##<    clean		- delete generated files for all packages
.PHONY: clean
clean: clean_exc
	@

##<    clean.<package>	- delete generated files for <package>
.PHONY: clean.%
clean.%:
	@echo 'Package $(TOOLCHAIN)-$* clean'
	@cd $(TOOLCHAIN)-$*; \
	$(RM) $(GEN_FILES)

##<    updpkgsums		- run updpkgsums for each package
.PHONY: updpkgsums
updpkgsums: updpkgsums_exc
	@

##<    updpkgsums.<package>- run updpkgsums for <package>
.PHONY: updpkgsums.%
updpkgsums.%:
	@echo 'Package $(TOOLCHAIN)-$* checksums update'
	@cd $(TOOLCHAIN)-$*; \
	updpkgsums

##<    srcinfo		- update .SRCINFO file for each package
.PHONY: srcinfo
srcinfo: updsrcinfo_exc
	@

##<    srcinfo.<package>	- update .SRCINFO file for <package>
.PHONY: srcinfo.%
updsrcinfo.%:
	@echo 'Package $(TOOLCHAIN)-$* .SRCINFO update'
	@cd $(TOOLCHAIN)-$*; \
	$(MKPKG) --printsrcinfo > .SRCINFO

##<    zip			- zip Makefile and packages exclude git files and generated files
.PHONY: zip
zip:
	@echo '$(TOOLCHAIN).tar.gz created'
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

##<    remove		- delete all packages from system using pacman
.PHONY: remove
remove:
	sudo pacman --remove --noconfirm \
	     $(shell pacman -Qq $(addprefix $(TOOLCHAIN)-,$(PACK_LIST)) )
