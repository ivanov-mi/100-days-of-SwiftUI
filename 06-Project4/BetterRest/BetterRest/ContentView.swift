//
//  ContentView.swift
//  BetterRest
//
//  Created by Martin Ivanov on 4/17/24.
//

import SwiftUI
import CoreML

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? .now
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("When do you want to wake up?")
                    .font(.headline)) {
                    DatePicker("Please enter time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                Section(header: Text("Desired amount of sleep")
                    .font(.headline)) {
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
                Section(header: Text("Daily coffee intake")
                    .font(.headline)) {
                        Picker("Daily coffee intake", selection: $coffeeAmount) {
                            ForEach(1...20, id: \.self) { cups in
                                Text("^[\(cups) cup](inflect: true)")
                            }
                        }
                        .labelsHidden()
                }
                
                Section(header: Text("Recommended bedtime")
                    .font(.headline)) {
                        Text("\(calculateBedtime())")
                            .font(.headline)
                    }
            }
            .navigationTitle("BetterRest")
        }
    }
    
    func calculateBedtime() -> String {
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 3600
        let minute = (components.minute ?? 0) * 60
        
        var bedTime: String
        
        do {
            let model = try SleepCalculator(configuration: MLModelConfiguration())
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep

            bedTime = sleepTime.formatted(date: .omitted, time: .shortened)
        } catch {
            bedTime = "Sorry, there was a problem calculating your bedtime."
        }
        
        return bedTime
    }
}

#Preview {
    ContentView()
}
