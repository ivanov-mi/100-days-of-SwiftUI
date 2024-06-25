//
//  SettingsView.swift
//  Multiplication
//
//  Created by Martin Ivanov on 6/24/24.
//

import SwiftUI

struct SettingsView: View {
    @Bindable var settings: Settings
    @Binding var presentingMultiplication: Bool
    
    var body: some View {
        VStack {
            Form {
                Section {
                    Stepper(value: $settings.tablesUpTo, in: MultiplicationTablesBounds.maxRange()) {
                        Text("\(settings.tablesUpTo)")
                    }
                } header: {
                    Text("Multiplication tables up to:")
                        .font(.title)
                }
                
                Section {
                    Picker("Number of questions", selection: $settings.numberOfQuestions) {
                        ForEach(QuestionsNumberOptions.allCases, id: \.rawValue) {
                            Text("\($0.rawValue)")
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Number of questions")
                        .font(.title)
                }
            }
            
            Button {
                presentingMultiplication.toggle()
            } label: {
                Text("Start")
                    .font(.largeTitle)
                    .padding([.leading, .trailing], 25)
            }
            .padding(10)
            .background(.blue)
            .foregroundColor(.white)
            .clipShape(Capsule())
        }
    }
}

#Preview {
    @State var presentingMultiplication = false
    @State var settings = Settings()
    
    return SettingsView(settings: settings, presentingMultiplication: $presentingMultiplication)
}
