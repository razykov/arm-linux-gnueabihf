**usage:** `make [target]`

**targets:**
```
    help                - print this message
    all                 - same as build (default target)
    build               - build and install all packages
    build.<package>     - build and install <package>
                            not work if depencieses isn't installed
    download            - download sources for all packages
    download.<package>  - download sources for <package>
    clean               - delete generated files for all packages
    clean.<package>     - delete generated files for <package>
    updpkgsums          - run updpkgsums for each package
    updpkgsums.<package>- run updpkgsums for <package>
    srcinfo             - update .SRCINFO file for each package
    srcinfo.<package>   - update .SRCINFO file for <package>
    zip                 - zip Makefile and packages exclude git files and generated files
    remove              - delete all packages from system using pacman
```
**packages:**

* binutils
* gcc-stage1
* glibc-headers
* gcc-stage2
* glibc
* gcc
