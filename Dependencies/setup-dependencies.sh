# Absolute path to this script.
SCRIPT=$(readlink -f $0)
# Absolute path this script is in.
SCRIPTPATH=`dirname $SCRIPT`

cd $SCRIPTPATH

# LIBPNG
if [ ! -d "libpng" ]; then

    if [ ! -d "libpng-src" ]; then
        git clone https://github.com/glennrp/libpng.git libpng-src
    fi

    mkdir libpng && cd libpng-src
    
    mkdir build && cd build && cmake .. \
        -DCMAKE_SYSTEM_NAME=Darwin \
        -DCMAKE_OSX_ARCHITECTURES=arm64 \
        -DCMAKE_OSX_SYSROOT=$(xcrun --sdk xros --show-sdk-path) \
        -DCMAKE_INSTALL_PREFIX=$SCRIPTPATH/libpng
    
    make && make install && make clean && cd ../..
fi

rm -fr libpng-src

# OPENSSL
if [ ! -d "openssl" ]; then

    if [ ! -d "openssl-src" ]; then
        git clone https://github.com/openssl/openssl.git openssl-src
    fi

    mkdir openssl && cd openssl-src

    ./Configure ios64-cross \
      no-shared \
      --prefix=$SCRIPTPATH/openssl \
      -isysroot $(xcrun --sdk xros --show-sdk-path)
    
    make && make install && make clean && cd ..
fi

rm -fr openssl-src

# ZLIB
if [ ! -d "zlib" ]; then

    if [ ! -d "zlib-src" ]; then
        git clone https://github.com/madler/zlib.git zlib-src
    fi
    
    mkdir zlib && cd zlib-src
    
    SDKROOT=$(xcrun --sdk xros --show-sdk-path) \
    CC="clang -isysroot $SDKROOT -arch arm64" \
    ./configure \
      --static \
      --prefix=$SCRIPTPATH/zlib
    
    make && make install && make clean && cd ..
fi

rm -fr zlib-src

# DCMTK
if [ ! -d "dcmtk" ]; then

    if [ ! -d "dcmtk-src" ]; then
        git clone https://github.com/DCMTK/dcmtk.git dcmtk-src
    fi
    
    mkdir dcmtk && cd dcmtk-src
    
    sed -i '' 's/ dcm2pdf//g' dcmdata/apps/CMakeLists.txt
    
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
fi

rm -fr dcmtk-src
