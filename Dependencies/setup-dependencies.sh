set -e

# Absolute path to this script.
SCRIPT=$(readlink -f $0)
# Absolute path this script is in.
SCRIPTPATH=`dirname $SCRIPT`

#Change this to "os" to build for Apple Vision Pro (real device)
XRSDK=simulator

cd $SCRIPTPATH

# LIBPNG
if [ ! -d "libpng" ]; then

    if [ ! -d "libpng-src" ]; then
        git clone https://github.com/glennrp/libpng.git libpng-src
    fi

    cd libpng-src
    
    mkdir build && cd build && cmake .. \
        -DCMAKE_SYSTEM_NAME=Darwin \
        -DCMAKE_OSX_ARCHITECTURES=arm64 \
        -DCMAKE_OSX_SYSROOT=$(xcrun --sdk xr$XRSDK --show-sdk-path) \
        -DCMAKE_INSTALL_PREFIX=$SCRIPTPATH/libpng
    
    make && mkdir "$SCRIPTPATH/libpng"
    make install && make clean && cd ../..
fi

rm -fr libpng-src

# OPENSSL
if [ ! -d "openssl" ]; then

    if [ ! -d "openssl-src" ]; then
        git clone https://github.com/openssl/openssl.git openssl-src
    fi

    cd openssl-src

    ./Configure ios64-cross \
        no-shared \
        --prefix=$SCRIPTPATH/openssl \
        -isysroot $(xcrun --sdk xr$XRSDK --show-sdk-path)
    
    make && mkdir "$SCRIPTPATH/openssl"
    make install && make clean && cd ..
fi

rm -fr openssl-src

# ZLIB
if [ ! -d "zlib" ]; then

    if [ ! -d "zlib-src" ]; then
        git clone https://github.com/madler/zlib.git zlib-src
    fi
    
    cd zlib-src
    
    SDKROOT=$(xcrun --sdk xr$XRSDK --show-sdk-path) \
    CC="clang -isysroot $SDKROOT -arch arm64" \
    ./configure \
        --static \
        --prefix=$SCRIPTPATH/zlib
    
    make && mkdir "$SCRIPTPATH/zlib"
    make install && make clean && cd ..
fi

rm -fr zlib-src

# DCMTK
if [ ! -d "dcmtk" ]; then

    if [ ! -d "dcmtk-src" ]; then
        git clone https://github.com/DCMTK/dcmtk.git dcmtk-src
    fi
    
    cd dcmtk-src
    
    sed -i '' 's/ dcm2pdf//g' dcmdata/apps/CMakeLists.txt
    
    mkdir build && cd build && cmake .. \
        -DBUILD_SHARED_LIBS=OFF \
        -DCMAKE_SYSTEM_NAME=Darwin \
        -DCMAKE_OSX_ARCHITECTURES=arm64 \
        -DCMAKE_OSX_SYSROOT=$(xcrun --sdk xr$XRSDK --show-sdk-path) \
        -DCMAKE_INSTALL_PREFIX=$SCRIPTPATH/dcmtk \
        -DPNG_LIBRARY=$SCRIPTPATH/libpng/lib/libpng.a \
        -DPNG_PNG_INCLUDE_DIR=$SCRIPTPATH/libpng/include \
        -DOPENSSL_ROOT_DIR=$SCRIPTPATH/libssl \
        -DOPENSSL_LIBRARIES="$SCRIPTPATH/libssl/lib/libssl.a;$SCRIPTPATH/libssl/lib/libcrypto.a" \
        -DOPENSSL_INCLUDE_DIR=$SCRIPTPATH/libssl/include \
        -DZLIB_LIBRARY=$SCRIPTPATH/zlib/lib/libz.a \
        -DZLIB_INCLUDE_DIR=$SCRIPTPATH/zlib/include \
        -DCMAKE_EXE_LINKER_FLAGS="-lz"
    
    make && mkdir "$SCRIPTPATH/dcmtk"
    make install && make clean && cd ../..
fi

rm -fr dcmtk-src

# VTK
if [ ! -d "vtk-compiletools" ]; then
    
    if [ ! -d "vtk-src" ]; then
        git clone https://gitlab.kitware.com/vtk/vtk vtk-src
    fi

    mkdir -p vtk-src/build-ct

    cmake -S $SCRIPTPATH/vtk-src \
        -B $SCRIPTPATH/vtk-src/build-ct \
        -DVTK_BUILD_COMPILE_TOOLS_ONLY=ON \
        -DCMAKE_INSTALL_PREFIX=$SCRIPTPATH/vtk-compiletools
    
    mkdir "$SCRIPTPATH/vtk-compiletools"
    
    cmake --build $SCRIPTPATH/vtk-src/build-ct \
          --config Release \
          --target install
fi

if [ ! -d "vtk" ]; then

    mkdir -p vtk-src/build && cd vtk-src/build
    
    for i in {1..2}; do
        cmake -GNinja .. \
            -DCMAKE_JOB_SERVER_LAUNCH=ON \
            -DBUILD_SHARED_LIBS=OFF \
            -DCMAKE_SYSTEM_NAME=Darwin \
            -DCMAKE_OSX_ARCHITECTURES=arm64 \
            -DCMAKE_OSX_SYSROOT=$(xcrun --sdk xr$XRSDK --show-sdk-path) \
            -DCMAKE_INSTALL_PREFIX=$SCRIPTPATH/vtk \
            -DVTKCompileTools_DIR=$SCRIPTPATH/vtk-compiletools/lib/cmake/vtkcompiletools-9.4 \
            -DCMAKE_BUILD_TYPE=Release \
            -DVTK_BUILD_TESTING=OFF \
            -DVTK_BUILD_EXAMPLES=OFF \
            -DVTK_GROUP_ENABLE_Rendering=NO \
            -DVTK_GROUP_ENABLE_Views=NO \
            -DVTK_GROUP_ENABLE_Web=NO \
            -DVTK_GROUP_ENABLE_Imaging=YES \
            -DVTK_GROUP_ENABLE_Parallel=NO \
            -DVTK_GROUP_ENABLE_Utilities=NO \
            -DVTK_MODULE_ENABLE_VTK_RenderingCore=YES \
            -DVTK_MODULE_ENABLE_VTK_RenderingContext2D=YES \
            -DVTK_MODULE_ENABLE_VTK_RenderingFreeType=YES \
            -DVTK_MODULE_ENABLE_VTK_RenderingOpenGL2=NO \
            -DVTK_MODULE_ENABLE_VTK_RenderingMetal=YES \
            -DVTK_MODULE_ENABLE_VTK_RenderingUI=NO \
            -DVTK_MODULE_ENABLE_VTK_CommonCore=YES \
            -DVTK_MODULE_ENABLE_VTK_CommonDataModel=YES \
            -DVTK_MODULE_ENABLE_VTK_IOCore=YES \
            -DVTK_MODULE_ENABLE_VTK_IOExport=YES \
            -DVTK_MODULE_ENABLE_VTK_IOExportOBJ=YES \
            -DVTK_MODULE_ENABLE_VTK_IOExportUSD=YES \
            -DVTK_MODULE_ENABLE_VTK_IOImage=YES \
            -DVTK_MODULE_ENABLE_VTK_IOSQLite=NO \
            -DVTK_MODULE_ENABLE_VTK_IOMINC=YES \
            -DVTK_MODULE_ENABLE_VTK_IOGeometry=YES \
            -DVTK_MODULE_ENABLE_VTK_FiltersCore=YES \
            -DVTK_MODULE_ENABLE_VTK_FiltersGeneral=YES \
            -DVTK_MODULE_ENABLE_VTK_FiltersModeling=YES \
            -DVTK_MODULE_ENABLE_VTK_FiltersMarchingCubes=YES \
            -DVTK_MODULE_ENABLE_VTK_FiltersFlyingEdges=YES \
            -DVTK_MODULE_ENABLE_VTK_FiltersHybrid=YES \
            -DVTK_MODULE_ENABLE_VTK_libxml2=NO \
            -DVTK_MODULE_ENABLE_VTK_sqlite=NO
    done
        
    cmake --build . --parallel $(sysctl -n hw.logicalcpu) --config Release
    mkdir "$SCRIPTPATH/vtk" && cmake --install .
fi
