//
//  DicomMetadata.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 04/05/25.
//

import Foundation

/// A type-safe view model that transforms raw DICOM metadata (typically `[String: Any]`)
/// into strongly-typed Swift properties for display, processing, or archival purposes.
///
/// This struct provides semantic access to selected DICOM attributes and applies
/// useful transformations such as parsing date/time and decomposing composite fields.
///
/// DICOM tags are often represented as raw strings, integers, or floats from a DICOM parser (e.g., DCMTK),
/// and this struct abstracts their handling into a clean interface.
struct DicomMetadata: Codable, Hashable {
    
    // MARK: - Core Patient and Study Info

    /// The patient's name (DICOM tag: `0010,0010`, VR: PN).
    /// May be formatted with caret-separated components (e.g. "Doe^John").
    let patientName: String?

    /// The patient identifier (DICOM tag: `0010,0020`).
    /// Often a pseudonym or anonymized ID in public datasets.
    let patientID: String?

    /// The imaging modality (DICOM tag: `0008,0060`), e.g., "CT", "MR".
    let modality: String?

    /// The patient sex (DICOM tag: `0010,0040`), usually "M", "F", or "O".
    let patientSex: String?

    /// The patient age (DICOM tag: `0010,1010`), formatted like "070Y" (years), "030D" (days), etc.
    let patientAge: String?

    /// A `Date` representing the combination of `StudyDate` (`0008,0020`) and `StudyTime` (`0008,0030`).
    /// Combines both fields for convenience and formatting.
    let studyTimeDate: Date?

    // MARK: - Acquisition Parameters

    /// The slice thickness in millimeters (DICOM tag: `0018,0050`), typically a `Double`.
    let sliceThickness: Double?

    /// The name of the reconstruction kernel used (DICOM tag: `0018,1210`), e.g., "B40f", "Bv38f".
    let convolutionKernel: String?

    /// The equipment manufacturer (DICOM tag: `0008,0070`), e.g., "SIEMENS", "GE".
    let manufacturer: String?

    // MARK: - Series and Instance Details

    /// The series number within the study (DICOM tag: `0020,0011`).
    let seriesNumber: Int32?

    /// The number of images in the acquisition (DICOM tag: `0020,1002`).
    let imagesInAcquisition: Int32?

    /// The instance number of this image within the series (DICOM tag: `0020,0013`).
    let instanceNumber: Int32?

    // MARK: - Study Description Breakdown

    /// The general body region or study type, extracted from the first component of `StudyDescription` (`0008,1030`).
    /// For example, in "Abdomen^Routine_Abdomen", this would be "Abdomen".
    let studyArea: String?

    /// The specific procedure or sequence name, extracted from the second component of `StudyDescription`.
    /// For example, in "Abdomen^Routine_Abdomen", this would be "Routine_Abdomen".
    let studyProcedure: String?

    // MARK: - Initializer

    /// Initializes a typed DICOM metadata struct from a raw `[String: Any]` dictionary,
    /// such as one parsed from DCMTK or a JSON bridge.
    ///
    /// - Parameter metadata: A dictionary of raw DICOM values keyed by tag name.
    init(from metadata: [String: Any]) {
        
        // Direct field mappings
        patientName           = metadata["PatientName"]         as? String
        patientID             = metadata["PatientID"]           as? String
        modality              = metadata["Modality"]            as? String
        patientSex            = metadata["PatientSex"]          as? String
        patientAge            = metadata["PatientAge"]          as? String
        sliceThickness        = metadata["SliceThickness"]      as? Double
        convolutionKernel     = metadata["ConvolutionKernel"]   as? String
        manufacturer          = metadata["Manufacturer"]        as? String
        seriesNumber          = metadata["SeriesNumber"]        as? Int32
        imagesInAcquisition   = metadata["ImagesInAcquisition"] as? Int32
        instanceNumber        = metadata["InstanceNumber"]      as? Int32

        // Date + time combination
        if let studyDate = metadata["StudyDate"] as? String,
           let studyTime = metadata["StudyTime"] as? String,
           let date = Date(studyDate: studyDate, studyTime: studyTime) {
            studyTimeDate = date
        } else {
            studyTimeDate = nil
        }

        // Decompose StudyDescription (e.g., "Cardiac^TAVI_Routine")
        if let studyDescription = metadata["StudyDescription"] as? String {
            let parts = studyDescription.split(separator: "^")
            studyArea      = parts.first.map(String.init)
            studyProcedure = parts.dropFirst().first.map(String.init)
        } else {
            studyArea = nil
            studyProcedure = nil
        }
    }
}
