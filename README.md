# DcmVision
This is a simple example project for visionOS, aiming to provide working image rapresentation of DICOM files.
There are a few steps needed to get this working, that require further explanation down below.

> [!CAUTION]
> This project is not intended to be used in any medical production environment. It should be only used for R&D.

## Requirements
- visionOS 2.0+
- XCode 16+
- Patience and time to spare

## Getting Started
### Dependencies
This project uses the open source, industry standard library [DCMTK](https://github.com/DCMTK/dcmtk). Pre-compiled binaries for visionOS are not available, so we'll need to compile our own.
To do that, many dependencies of DCMTK also need to be compiled targeting visionOS.

> [!TIP]
> This project includes the facility script <strong>setup-dependencies.sh</strong>

#### DMCTK
- From a terminal window, cd to <strong>Dependencies</strong> directory inside the repository root
- Clone DCMTK with this command ```git clone https://github.com/DCMTK/dcmtk dcmtk-src```
- Navigate to <strong>dcmtk-src/dcmdata/apps</strong> and edit <strong>CMakeLists.txt</strong> to remove all occurrences of <strong>dcm2pdf</strong>

> [!IMPORTANT]
> The last step is needed to disable the <strong>dcm2pdf</strong> module that cannot compile on visionOS, because it relies on unavailable system calls

#### Other dependencies
- Run <strong>Dependencies/setup-dependencies.sh</strong> and wait for everything to compile, including DCMTK itself
- Manually add <strong>dmctk</strong> and <strong>zlib</strong> dependency folders to the XCode project

> [!IMPORTANT]
> Be sure to select the build target when adding files to the XCode project, otherwise the app won't have the necessary resources inside its bundle

### DICOM Data Set
Create a directory named <strong>DataSet</strong> located at repository root and copy all your .dcm files inside of it

### Finalizing
Build the XCode project and enjoy!
