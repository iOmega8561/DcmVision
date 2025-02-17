# DcmVision
This is a simple example project for visionOS, aiming to provide working image rapresentation of DICOM files.
There are a few steps needed to get this working, that require further explanation down below.

> [!CAUTION]
> This project is not intended to be used in any medical production environment. It should be only used for R&D.

## Requirements
- visionOS 2.0+
- Xcode 16+
- Patience and time to spare

## Getting Started
### Dependencies
This project uses the open source, industry standard library [DCMTK](https://github.com/DCMTK/dcmtk). Pre-compiled binaries for visionOS are not available, so we'll need to compile our own.
To do that, many dependencies of DCMTK also need to be compiled targeting visionOS.

> [!TIP]
> This project includes the facility script <strong>setup-dependencies.sh</strong>

- Run <strong>Dependencies/setup-dependencies.sh</strong> and wait for everything to compile, including DCMTK itself
- Manually add <strong>dmctk</strong> along with <strong>zlib</strong> and <strong>vtk</strong> dependency folders to the Xcode project

> [!IMPORTANT]
> Be sure to select the build target when adding files to the Xcode project, otherwise the app won't have the necessary resources inside its bundle

### DICOM Data Set
Create a directory named <strong>DataSet</strong> located at repository root and copy all your .dcm files inside of it

### Finalizing
Build the Xcode project and enjoy!

## Contributors
- [Giuseppe Rocco](https://github.com/iOmega8561): Dependencies setup and initial project package
