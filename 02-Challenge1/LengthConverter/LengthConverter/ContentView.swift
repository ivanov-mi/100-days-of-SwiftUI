//
//  ContentView.swift
//  LengthConverter
//
//  Created by Martin Ivanov on 4/10/24.
//

import SwiftUI

enum LengthUnits: String, CaseIterable, Identifiable {
    case meter = "Meters"
    case kilometer = "Kilometers"
    case feet = "Feet"
    case yard = "Yards"
    case mile = "Miles"
    
    var id: Self {
        self
    }
    
    var abbreviation: String {
        switch self {
        case .meter:
            return "m"
        case .kilometer:
            return "km"
        case .feet:
            return "ft"
        case .yard:
            return "yd"
        case .mile:
            return "mi"
        }
    }
    
    var unit: UnitLength {
        switch self {
        case .meter:
            UnitLength.meters
        case .kilometer:
            UnitLength.kilometers
        case .feet:
            UnitLength.feet
        case .yard:
            UnitLength.yards
        case .mile:
            UnitLength.miles
        }
    }
}

struct ContentView: View {
    @State private var inputLength = 0.0
    @State private var inputUnits = LengthUnits.meter
    @State private var outputUnits = LengthUnits.meter
    
    @FocusState private var inputLengthIsFocused: Bool
    
    private let customFormatting = FloatingPointFormatStyle<Double>()
        .notation(.automatic)
        .locale(Locale(identifier: Locale.current.identifier))
    
    private var convertedLength: Double {
        let source = Measurement(value: inputLength, unit: inputUnits.unit)
        return source.converted(to: outputUnits.unit).value
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        TextField("Value", value: $inputLength, format: .number)
                            .keyboardType(.decimalPad)
                            .focused($inputLengthIsFocused)
                        Spacer()
                        Text(inputUnits.rawValue)
                    }
                    
                    Picker("Selected Unit", selection: $inputUnits) {
                        ForEach(LengthUnits.allCases) {
                            Text($0.abbreviation)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                
                Section {
                    HStack {
                        Text(convertedLength, format: customFormatting)
                        Spacer()
                        Text(outputUnits.rawValue)
                    }
                    
                    Picker("Selected Unit", selection: $outputUnits) {
                        ForEach(LengthUnits.allCases) {
                            Text($0.abbreviation)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Length Converter")
            .toolbar {
                if inputLengthIsFocused {
                    Button("Done") {
                        inputLengthIsFocused = false
                    }
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
