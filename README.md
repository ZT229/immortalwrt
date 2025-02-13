  1. Run `git clone --depth 1 -b nx30pro --single-branch https://github.com/ZT229/immortalwrt.git nx30pro` to clone the source code.
  2. Run `cd nx30pro` to enter source directory.
  3. Run `git pull && ./scripts/feeds update -a && ./scripts/feeds install -a` update source code and package then install package
  4. Run `make menuconfig` to select your preferred configuration for the toolchain, target system & firmware packages.
  5. Run "make download -j8" predownlooad packages
  5. Run `make -j8` to build your firmware. 
