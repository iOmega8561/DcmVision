//
//  Copyright (C) 2025  Giuseppe Rocco
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <https://www.gnu.org/licenses/>.
//
//  ----------------------------------------------------------------------
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
