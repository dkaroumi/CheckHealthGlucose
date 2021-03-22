//
//  BloodMeterSample.swift
//  TestSDK3
//
//  Created by Daniel Karoumi on 2020-07-15.
//  Copyright © 2020 Daniel Karoumi. All rights reserved.
//
import Foundation
import KetoMojoSDK

extension BloodMeterSample {
    var description: String {
        switch self {
        case .ketone:
            return "Ketone"
        case .ketoneGKI:
            return "Ketone GKI"
        case .ketoneQualityControl:
            return "Ketone QC"
        case .ketoneGKIQualityControl:
            return "Ketone GKI QC"
        case .glucose:
            return "Glucose"
        case .glucoseGKI:
            return "Glucose GKI"
        case .glucoseQualityControl:
            return "Glucose QC"
        case .glucoseGKIQualityControl:
            return "Glucose GKI QC"
        case .error:
            return "Error"
        case .GKI:
            return "GKI"
        case .hematocrit:
            return "Hematocrit"
        case .hemoglobine:
            return "Hemoglobine"
        }
    }
}
