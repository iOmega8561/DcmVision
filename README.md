# DcmVision

DcmVision is a sample project for visionOS that demonstrates how to handle and visualize DICOM files. It serves as a reference implementation for integrating DICOM imaging into visionOS applications. Additionally, it provides an example of bridging standard Clang technologies to the Apple ecosystem by using Objective-C++.

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
- [ITK](https://github.com/InsightSoftwareConsortium/ITK)
- [Zlib](https://zlib.net/)

Since pre-compiled binaries for visionOS are not available, these libraries must be compiled manually.

> [!TIP]
> This project includes a facility script: **setup-dependencies.sh**
>
> At the top of **setup-dependencies.sh**, there is a variable named `XRSDK`, which is set to `simulator` by default. Developers can change it to `os` to switch from the simulator target to the visionOS target.

#### Steps to install dependencies:

1. Run **Dependencies/setup-dependencies.sh** and wait for everything to compile, including ITK, DCMTK, and Zlib.
2. Manually bundle the **ITK, DCMTK, and LIBZ** install folders into the Xcode project.
3. Ensure that each added dependency is correctly assigned to the build target when adding them to the Xcode project.

> [!IMPORTANT]
> The **Header Search Path** and **Library Search Path** must be correctly set in Xcode to locate external frameworks and libraries.

### DICOM Data Sets

For the example to work, DICOM files (Data Sets) must be directly included in the application. To achieve this, use the pre-existing **DicomFiles** group and add all the required directories under it. Ensure that you select **Add to Target** when adding files; otherwise, they will not be bundled with the build product.

### Finalizing

Build the Xcode project and enjoy!

## Contributors

- [Giuseppe Rocco](https://github.com/iOmega8561)[:](https://github.com/iOmega8561) Dependencies setup and initial project package
