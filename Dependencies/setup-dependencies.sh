# Absolute path to this script.
SCRIPT=$(readlink -f $0)
# Absolute path this script is in.
SCRIPTPATH=`dirname $SCRIPT`

cd $SCRIPTPATH

# LIBPNG
git clone https://github.com/glennrp/libpng.git libpng-src
mkdir libpng && cd libpng-src

mkdir build && cd build && cmake .. \
  -DCMAKE_SYSTEM_NAME=Darwin \
  -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DCMAKE_OSX_SYSROOT=$(xcrun --sdk xros --show-sdk-path) \
  -DCMAKE_INSTALL_PREFIX=$SCRIPTPATH/libpng
  
make && make install && make clean && cd ../..

# OPENSSL
git clone https://github.com/openssl/openssl.git openssl-src
mkdir openssl && cd openssl-src

./Configure ios64-cross \
  no-shared \
  --prefix=$SCRIPTPATH/openssl \
  -isysroot $(xcrun --sdk xros --show-sdk-path)
  
make && make install && make clean && cd ..

# ZLIB
git clone https://github.com/madler/zlib.git zlib-src
mkdir zlib && cd zlib-src

SDKROOT=$(xcrun --sdk xros --show-sdk-path) \
CC="clang -isysroot $SDKROOT -arch arm64" \
./configure \
  --static \
  --prefix=$SCRIPTPATH/zlib

make && make install && make clean && cd ..

# DCMTK
# git clone https://github.com/DCMTK/dcmtk.git dcmtk-src
mkdir dcmtk && cd dcmtk-src

mkdir build && cd build && cmake .. \
  -DBUILD_SHARED_LIBS=OFF \
  -DCMAKE_SYSTEM_NAME=Darwin \
  -DCMAKE_OSX_ARCHITECTURES=arm64 \
  -DCMAKE_OSX_SYSROOT=$(xcrun --sdk xros --show-sdk-path) \
  -DCMAKE_INSTALL_PREFIX=$SCRIPTPATH/dcmtk \
  -DPNG_LIBRARY=$SCRIPTPATH/libpng/lib/libpng.a \
  -DPNG_PNG_INCLUDE_DIR=$SCRIPTPATH/libpng/include \
  -DOPENSSL_ROOT_DIR=$SCRIPTPATH/libssl \
  -DOPENSSL_LIBRARIES="$SCRIPTPATH/libssl/lib/libssl.a;$SCRIPTPATH/libssl/lib/libcrypto.a" \
  -DOPENSSL_INCLUDE_DIR=$SCRIPTPATH/libssl/include \
  -DZLIB_LIBRARY=$SCRIPTPATH/zlib/lib/libz.a \
  -DZLIB_INCLUDE_DIR=$SCRIPTPATH/zlib/include \
  -DCMAKE_EXE_LINKER_FLAGS="-lz"

make && make install && make clean && cd ../..
