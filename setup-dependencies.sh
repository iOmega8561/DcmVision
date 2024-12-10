# Absolute path to this script.
SCRIPT=$(readlink -f $0)
# Absolute path this script is in.
SCRIPTPATH=`dirname $SCRIPT`

# LIBPNG
git clone https://github.com/glennrp/libpng.git
mkdir libpng-build && cd libpng

mkdir build && cd build && cmake .. \
  -DCMAKE_SYSTEM_NAME=Darwin \
  -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DCMAKE_OSX_SYSROOT=$(xcrun --sdk xros --show-sdk-path) \
  -DCMAKE_INSTALL_PREFIX=$SCRIPTPATH/libpng-build
  
make && make install && make clean && cd ../..

# OPENSSL
git clone https://github.com/openssl/openssl.git
mkdir openssl-build && cd openssl

./Configure ios64-cross \
  no-shared \
  --prefix=$SCRIPTPATH/openssl-build \
  -isysroot $(xcrun --sdk xros --show-sdk-path)
  
make && make install && make clean && cd ..

# ZLIB
git clone https://github.com/madler/zlib.git
mkdir zlib-build && cd zlib

SDKROOT=$(xcrun --sdk xros --show-sdk-path) \
CC="clang -isysroot $SDKROOT -arch arm64" \
./configure \
  --static \
  --prefix=$SCRIPTPATH/zlib-build

make && make install && make clean && cd ..

# DCMTK
# git clone https://github.com/DCMTK/dcmtk.git
mkdir dcmtk-build && cd dcmtk

mkdir build && cd build && cmake .. \
  -DBUILD_SHARED_LIBS=OFF \
  -DCMAKE_SYSTEM_NAME=Darwin \
  -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DCMAKE_OSX_SYSROOT=$(xcrun --sdk xros --show-sdk-path) \
  -DCMAKE_INSTALL_PREFIX=$SCRIPTPATH/dcmtk-build \
  -DPNG_LIBRARY=$SCRIPTPATH/libpng-build/lib/libpng.a \
  -DPNG_PNG_INCLUDE_DIR=$SCRIPTPATH/libpng-build/include \
  -DOPENSSL_ROOT_DIR=$SCRIPTPATH/libssl-build \
  -DOPENSSL_LIBRARIES="$SCRIPTPATH/libssl-build/lib/libssl.a;$SCRIPTPATH/libssl-build/lib/libcrypto.a" \
  -DOPENSSL_INCLUDE_DIR=$SCRIPTPATH/libssl-build/include \
  -DZLIB_LIBRARY=$SCRIPTPATH/zlib-build/lib/libz.a \
  -DZLIB_INCLUDE_DIR=$SCRIPTPATH/zlib-build/include \
  -DCMAKE_EXE_LINKER_FLAGS="-lz"

make && make install && make clean && cd ../..
