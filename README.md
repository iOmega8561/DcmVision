# DcmVision

DcmVision is a sample project for visionOS that demonstrates how to handle and visualize DICOM files, including generation of a 3D model for scans acquired using CT and MRI. The project serves as a reference implementation for integrating DICOM imaging into visionOS applications. Additionally, it provides an example of bridging standard Clang technologies to the Apple ecosystem by using Objective-C++.

This project requires some setup steps, which are outlined below.

> [!CAUTION]
> This project is not intended for use in any medical production environment. It should only be used for R&D purposes.

## Requirements

- visionOS 2.0+
- Xcode 16+
- Patience and time to spare

## Getting Started

### Dependencies

This project utilizes multiple open-source, industry-standard libraries, including:

- [DCMTK](https://github.com/DCMTK/dcmtk)
- [VTK](https://github.com/Kitware/VTK)
- [Zlib](https://zlib.net/)

Since pre-compiled binaries for visionOS are not available, these libraries must be compiled manually.

> [!TIP]
> This project includes a facility script: **setup-dependencies.sh**
>
> At the top of **setup-dependencies.sh**, there is a variable named `XRSDK`, which is set to `simulator` by default. Developers can change it to `os` to switch from the simulator target to the visionOS target.

#### Steps to install dependencies:

1. Run **Dependencies/setup-dependencies.sh** and wait for everything to compile, including VTK, DCMTK, and ZLIB.
2. Manually bundle the **VTK, DCMTK, and LIBZ** install folders into the Xcode project.
3. Manually add all the static libraries that should be linked to the Application, under **Build Phases** -> **Link Binary with Libraries**

> [!IMPORTANT]
> - The **Header Search Path** and **Library Search Path** must be correctly set in Xcode to locate external frameworks and libraries.
> - Make sure statically link all the **.a** files found under the **{libname}/lib** directory, for each one of the dependencies.

### DICOM Data Sets

For the example to work, DICOM files (Data Sets) must be directly included in the application. To achieve this, use the pre-existing **DicomFiles** group and add all the required directories under it. The way this is currently handled in the project, is by using **Build Phases** -> **Copy Files** phase to manually copy all the dicom files in the application bundle. You may need to adjust settings according to your data sets.

### Finalizing

Build the Xcode project and enjoy!

## Contributors

- [Giuseppe Rocco](https://github.com/iOmega8561)[:](https://github.com/iOmega8561) Dependencies setup and initial project package
