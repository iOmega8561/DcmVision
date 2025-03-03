if [[ -z "${SDKROOT}" || -z "${SCRIPTPATH}" || -z "$PARALLEL" ]]; then
    exit 1
fi

cd "$SCRIPTPATH"

if [[ ! -d "libpng"  || ! -d "openssl" || ! -d "zlib" ]]; then
    exit 1
fi

if [ ! -d "dcmtk-src" ]; then
    git clone https://github.com/DCMTK/dcmtk.git dcmtk-src
fi

cd dcmtk-src

sed -i '' 's/ dcm2pdf//g' dcmdata/apps/CMakeLists.txt

mkdir build && cd build && cmake .. \
    -DBUILD_SHARED_LIBS=OFF \
    -DCMAKE_SYSTEM_NAME=Darwin \
    -DCMAKE_OSX_ARCHITECTURES=arm64 \
    -DCMAKE_OSX_SYSROOT="$SDKROOT" \
    -DCMAKE_INSTALL_PREFIX="$SCRIPTPATH/dcmtk" \
    -DPNG_LIBRARY="$SCRIPTPATH/libpng/lib/libpng.a" \
    -DPNG_PNG_INCLUDE_DIR="$SCRIPTPATH/libpng/include" \
    -DOPENSSL_ROOT_DIR="$SCRIPTPATH/libssl" \
    -DOPENSSL_LIBRARIES="$SCRIPTPATH/libssl/lib/libssl.a;$SCRIPTPATH/libssl/lib/libcrypto.a" \
    -DOPENSSL_INCLUDE_DIR="$SCRIPTPATH/libssl/include" \
    -DZLIB_LIBRARY="$SCRIPTPATH/zlib/lib/libz.a" \
    -DZLIB_INCLUDE_DIR="$SCRIPTPATH/zlib/include" \
    -DCMAKE_EXE_LINKER_FLAGS="-lz"

make -j$PARALLEL && mkdir "$SCRIPTPATH/dcmtk"
make install && make clean && cd ../..

rm -fr dcmtk-src
