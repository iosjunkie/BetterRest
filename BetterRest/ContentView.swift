//
//  ContentView.swift
//  BetterRest
//
//  Created by Jules Lee on 12/31/19.
//  Copyright © 2019 Jules Lee. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    var idealSleep: String {
        var idealSleep = ""
        let model = SleepCalculator()
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        do {
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            idealSleep = formatter.string(from: sleepTime)
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
            alertShowing = true
            idealSleep = alertMessage
        }
        return idealSleep
    }
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var alertShowing = false
    var body: some View {
        NavigationView {
            Form {
                VStack(alignment: .leading, spacing: 0) {
                    Text("When do you want to wake up?")
                        .font(.headline)
                    DatePicker("Please enter a time",
                               selection: $wakeUp,
                               displayedComponents: .hourAndMinute)
                        .datePickerStyle(WheelDatePickerStyle())
                    .labelsHidden()
                }
                VStack(alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.15) {
                        Text("\(sleepAmount, specifier: "%.2f") hours")
                    }
                }
                VStack {
                    Picker("Daily coffee intake", selection: $coffeeAmount) {
                        ForEach(1...20, id: \.self) { cup in
                            Text("\(cup) \(cup == 1 ? "cup" : "cups")").tag(cup)
                        }
                    }
//                    Stepper(value: $coffeeAmount, in: 1...20) {
//                        if coffeeAmount == 1 {
//                            Text("1 cup")
//                        } else {
//                            Text("\(coffeeAmount) cups")
//                        }
//                    }
                }
                HStack {
                    Text("Ideal bed time")
                    Spacer()
                    Text("\(idealSleep)")
                }
            }
        .navigationBarTitle("BetterRest")
//            .navigationBarItems(trailing: Button(action: calculateBedTime) { Text("Calculate") })
        }
//        .alert(isPresented: $alertShowing) {
//            Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//        }
    }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
//    func calculateBedTime() {
//        let model = SleepCalculator()
//        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
//        let hour = (components.hour ?? 0) * 60 * 60
//        let minute = (components.minute ?? 0) * 60
//        do {
//            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
//            let sleepTime = wakeUp - prediction.actualSleep
//            let formatter = DateFormatter()
//            formatter.timeStyle = .short
//
//            alertMessage = formatter.string(from: sleepTime)
//            alertTitle = "Your ideal bedtime is…"
//        } catch {
//            alertTitle = "Error"
//            alertMessage = "Sorry, there was a problem calculating your bedtime."
//
//        }
//        alertShowing = true
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
