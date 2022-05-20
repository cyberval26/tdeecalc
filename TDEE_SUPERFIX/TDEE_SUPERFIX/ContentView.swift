//
//  ContentView.swift
//  TDEE_SUPERFIX
//
//  Created by Evalda Christina on 27/04/22.
//

import SwiftUI
import AVFoundation

struct ContentView: View {
    
    @State var selected = 0
    @State var ageTextFieldText: Double = 0.0
    @State var weightTextFieldText: Double = 0.0
    @State var HeightTextFieldText: Double = 0.0
    @State var activitySelection: Int = 0
    @State var activity: Double = 0.0
    @State var resmsg: ResMsg?
    @State var showingAlert: Bool = false
    // @State var sizeText
    
    //    var Weight: Double = "1"
    //    var Height: Double = "1"
    //@State var Gender: String = ""
    @State var bmr: Double = 0.0
    //    var Age: Double = "1"
    
    @State var result:Double = 0
    
    var numberFormatter : NumberFormatter{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        return numberFormatter
    }
    
    
    var body: some View {
        //        let headlineFont = UIFont.preferredFont(forTextStyle: .headline)
        //        let subheadFont = UIFont.preferredFont(forTextStyle: .subheadline)
        VStack {
            HStack{
                Text("TDEE CALCULATOR")
                    .font(.largeTitle).fontWeight(.bold)
                
            }
            
            Picker(selection: $selected, label: Text("Gender"), content: {
                Text("Male").tag(0).font(.system(.body))
                Text("Female").tag(1).font(.system(.body))
            })
            .pickerStyle(SegmentedPickerStyle())
            
            VStack {
                Text("Age")
                    .font(.system(.body)).fontWeight(.semibold).frame(maxWidth: .infinity, alignment:.leading)
                TextField("Age", value: $ageTextFieldText, formatter: numberFormatter)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("Weight")
                    .font(.system(.body)).fontWeight(.semibold).frame(maxWidth: .infinity, alignment: .leading)
                TextField("Weight (kg)", value: $weightTextFieldText, formatter: numberFormatter)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                Text("Height")
                    .font(.system(.body)).fontWeight(.semibold).frame(maxWidth: .infinity, alignment: .leading)
                TextField("Height (cm)", value: $HeightTextFieldText, formatter: numberFormatter)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)
                    .font(.system(.body))
                Text("Activity Intensity")
                    .font(.system(.body)).fontWeight(.semibold).frame(maxWidth: .infinity, alignment: .leading)
                Picker(
                    selection: $activitySelection,
                    label: Text("Activity Intensity"),
                    content: {
                        Text("Sedentary (Office Job)").tag(1).font(.system(.body))
                        Text("Light Excercise (1-2 days/week)").tag(2).font(.system(.body))
                        Text("Moderate Excercise(3-5 days/week)").tag(3).font(.system(.body))
                        Text("Heavy Excercise(6-7 days/week").tag(4).font(.system(.body))
                        Text("Athelete(2x per day/week)").tag(5).font(.system(.body))
                    }
                ).frame(maxWidth: .infinity , alignment: .leading).background(.white).accentColor(.black)
                    .font(.system(.body))
                
            }.padding()
            Spacer()
            
            VStack{
                
                
                //                Text("Your TDEE is \(String(format: "%.2f", result)) Calories")
                Button{
                    
                    //let Weight = Double(weightTextFieldText.text!)!
                    //                    let Height = Double(Height.text!)!
                    //                    let Age = Double(Age.text!)!
                    
                    if selected == 0{
                        bmr = Double(66.5) + (Double(13.7) * (Double(weightTextFieldText) )) + (Double(5) * (Double(HeightTextFieldText) )) - (Double(6.8) * (Double(ageTextFieldText) ))
                        
                    }
                    else{
                        bmr = Double(655) + (Double(9.6) * (Double(weightTextFieldText))) + (Double(1.8) * (Double(HeightTextFieldText))) - (Double(4.7) * (Double(ageTextFieldText)))

//BMR Pria = 66,5 + (13,7 × berat badan) + (5 × tinggi badan) – (6,8 × usia)
                        //BMR Wanita = 655 + (9,6 × berat badan) + (1,8 × tinggi badan) – (4,7 × usia)
                    }
                    switch activitySelection{
                    case 1:
                        activity = Double(1.2)
                    case 2:
                        activity = Double(1.375)
                    case 3:
                        activity = Double(1.55)
                    case 4:
                        activity = Double(1.725)
                    case 5:
                        activity = Double(1.9)
                    default:
                        activity = 0
                    }
                    //Proses hitung menghitung
                    result = bmr * activity
                    resmsg = ResMsg(resmsg: String(format: "%.2f", result))
                    showingAlert = true
                    //print(String(format: "%.2f", result))
                    let utterance = AVSpeechUtterance(string: "Your TDEE is \( resmsg?.resmsg ?? "ERROR") Calories")
                    utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                    utterance.rate = 0.4

                    let synthesizer = AVSpeechSynthesizer()
                    synthesizer.speak(utterance)
                    
                }label: {
                    Label("Calculate", systemImage: "pencil.and.outline").padding()
                }.frame(maxWidth:.infinity , alignment: .center).background(.blue).foregroundColor(.white).cornerRadius(10).padding()
                
            }
            
        } .alert(item: $resmsg){
            obj in Alert (title: Text("TDEE"), message: Text("Your TDEE is \(obj.resmsg) Calories"), dismissButton: .default(Text("OK")))
            
            
        }
        
    }
    
    
}
//struct ScaledFont: ViewModifier{
//    @Environment
//
//}

struct ClearButton: ViewModifier
{
    @Binding var text: String

    public func body(content: Content) -> some View
    {
        ZStack(alignment: .trailing)
        {
            content

            if !text.isEmpty
            {
                Button(action:
                {
                    self.text = ""
                })
                {
                    Image(systemName: "delete.left")
                        .foregroundColor(Color(UIColor.opaqueSeparator))
                }
                .padding(.trailing, 8)
            }
        }
    }
}

struct ResMsg: Identifiable{
    let resmsg: String
    var id: String{resmsg}
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
