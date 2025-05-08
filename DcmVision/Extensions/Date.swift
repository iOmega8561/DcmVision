//
//  Date.swift
//  DcmVision
//
//  Created by Giuseppe Rocco on 04/05/25.
//

import Foundation

extension Date {
    
    /// Create a `Date` from DICOM-formatted StudyDate and StudyTime.
    ///
    /// - Parameters:
    ///   - studyDate: A string in `"yyyyMMdd"` format.
    ///   - studyTime: A string in `"HHmmss.SSS..."` format (can include microseconds/nanoseconds).
    init?(studyDate: String, studyTime: String) {
        
        // Create a DateFormatter
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd HHmmss.SSS"
        formatter.locale = Locale(identifier: "en_US_POSIX") // ensure consistent parsing

        // Trim the time string to milliseconds (first 3 decimal digits)
        let trimmedTimeString = String(studyTime.prefix(9)) // "172922.520"
        let fullDateTimeString = studyDate + " " + trimmedTimeString

        guard let date = formatter.date(from: fullDateTimeString) else {
            return nil
        }
        
        self = date
    }
}
