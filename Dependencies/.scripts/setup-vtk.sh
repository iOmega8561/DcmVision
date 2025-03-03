if [[ -z "${SDKROOT}" || -z "${SCRIPTPATH}" || -z "$PARALLEL" ]]; then
    exit 1
fi

cd "$SCRIPTPATH"

if [[ ! -d "vtk-compiletools" || ! -d "vtk-src" ]]; then
    exit 1
fi

mkdir -p vtk-src/build && cd vtk-src/build

cmake .. \
    -GNinja \
    -DCMAKE_JOB_SERVER_LAUNCH=ON \
    -DBUILD_SHARED_LIBS=OFF \
    -DCMAKE_SYSTEM_NAME=Darwin \
    -DCMAKE_OSX_ARCHITECTURES=arm64 \
    -DCMAKE_OSX_SYSROOT="$SDKROOT" \
    -DCMAKE_INSTALL_PREFIX="$SCRIPTPATH/vtk" \
    -DVTKCompileTools_DIR="$SCRIPTPATH/vtk-compiletools/lib/cmake/vtkcompiletools-9.4" \
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
    
cmake --build . --parallel $PARALLEL --config Release
mkdir "$SCRIPTPATH/vtk" && cmake --install .

cd ../..

rm -fr vtk-src
