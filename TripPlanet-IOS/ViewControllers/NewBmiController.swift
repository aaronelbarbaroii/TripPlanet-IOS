//
//  NewBmiController.swift
//  TripPlanet-IOS
//
//  Created by Mananas on 1/12/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class NewBmiController: UIViewController {
    
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var heightLabel: UILabel!
    
    @IBOutlet weak var weightStepper: UIStepper!
    
    @IBOutlet weak var HeightSlider: UISlider!

    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var estado: UILabel!
    


    var weight = 70
    var height = 170

    override func viewDidLoad() {
        super.viewDidLoad()
        
        weightLabel.text = "\(weight) kg"
        heightLabel.text = "\(height) cm"
        
        calculateButton()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func weightStepper(_ sender: UIStepper) {
        weight = Int(sender.value)
        weightLabel.text = "\(weight) kg"
        calculateButton()
    }
    
    @IBAction func heightSlider(_ sender: UISlider) {
        height = Int(sender.value)
        heightLabel.text = "\(height) cm"
        calculateButton()
    }
    
   func calculateButton() {
        let result = ("\(Double(weight)/pow(Double(height)/100.0, 2))")
        resultLabel.text = String(format: "%.2f", Double(result)!)
        estado.text = estadoIMC(imc: Double(result)!)
    }
    
    
    @IBAction func Save(_ sender: Any) {
        let userId = Auth.auth().currentUser!.uid
        let date = Date()
        let currentDate = date.millisecondsSince1970
        let weight = weight
        let height = height
        let bmi = Double(resultLabel.text!)
        
        Task {
            do {
                let db = Firestore.firestore()
                let docRef = try await db.collection("Bmis").addDocument(data: [:])
                
                let bmi = Bmi(id: docRef.documentID, currentDate: currentDate, userId: userId, weight: weight, height: height, bmi: bmi!)
                
                try docRef.setData(from: bmi)
                
                showAlert(message: "Bmi added successfully!")
                
            } catch {
                print("Error adding document: \(error)")
            }
        }
        
    }
    
    func estadoIMC(imc: Double) -> String {
        if imc < 18.5 {
            estado.textColor = .bmiColorUnderweight
            resultLabel.textColor = .bmiColorUnderweight
            return "Underweight"
        } else if imc < 24.9 {
            estado.textColor = .bmiColorNormal
            resultLabel.textColor = .bmiColorNormal
            return "Healthy weight"
        } else if imc < 29.9 {
            estado.textColor = .bmiColorOverweight
            resultLabel.textColor = .bmiColorOverweight
            return "Overweight"
        } else if imc < 34.9 {
            estado.textColor = .bmiColorObesity
            resultLabel.textColor = .bmiColorObesity
            return "Obesity"
        }
        else {
            estado.textColor = .bmiColorExtremeObesity
            resultLabel.textColor = .bmiColorExtremeObesity
            return "Extreme obesity"
        }
    }
    
    

}
