# DcmVision

DcmVision is an advanced visionOS project that demonstrates how to handle and visualize DICOM files, including generation of a 3D model for scans acquired using CT and MRI. The project serves as a reference implementation for integrating DICOM imaging into visionOS applications. Additionally, it provides an example of bridging standard Clang technologies to the Apple ecosystem by using Objective-C++.

This project requires some setup steps, which are outlined below.

> [!CAUTION]
> This project is not intended for use in any medical production environment. It should only be used for R&D.

![Demo Image](./Demo.png)

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
> At the top of **setup-dependencies.sh**, there is a variable named `TARGET`, which is set to `xrsimulator` by default. Developers can change it to `xros` to switch from the simulator target to the visionOS target.

#### Steps to install dependencies:

1. Run **Dependencies/setup-dependencies.sh** and wait for everything to compile, including VTK, DCMTK, and ZLIB.
2. Manually bundle the **VTK, DCMTK, and LIBZ** install folders into the Xcode project.
3. Manually add all the static libraries that should be linked to the Application, under **Build Phases** -> **Link Binary with Libraries**

> [!IMPORTANT]
> - The **Header Search Path** and **Library Search Path** must be correctly set in Xcode to locate external frameworks and libraries.
> - Make sure statically link all the **.a** files found under the **{libname}/lib** directory, for each one of the dependencies.

### DICOM Data Sets

The project has recently been refactored to allow the usage of **any** DICOM Data Set. It will be possible to select the directory containing the files directly from **within the application**. Previously the files had to be bundled with the project itself.

### Finalizing

Build the Xcode project and enjoy!

## Privacy

DcmVision respects your privacy and does not collect, store, or transmit any personal information or user data. The application operates fully offline in a sandboxed environment.



