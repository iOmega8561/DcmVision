if [[ -z "${SDKROOT}" || -z "${SCRIPTPATH}" || -z "$PARALLEL" ]]; then
    exit 1
fi

cd "$SCRIPTPATH"

if [ ! -d "libpng-src" ]; then
    git clone https://github.com/glennrp/libpng.git libpng-src
fi

cd libpng-src

mkdir build && cd build && cmake .. \
    -DCMAKE_SYSTEM_NAME=Darwin \
    -DCMAKE_OSX_ARCHITECTURES=arm64 \
    -DCMAKE_OSX_SYSROOT="$SDKROOT" \
    -DCMAKE_INSTALL_PREFIX="$SCRIPTPATH/libpng"

make -j$PARALLEL && mkdir "$SCRIPTPATH/libpng"
make install && make clean && cd ../..

rm -fr libpng-src
