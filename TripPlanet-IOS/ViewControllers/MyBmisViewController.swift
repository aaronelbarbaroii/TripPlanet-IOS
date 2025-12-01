//
//  MyBmisViewController.swift
//  TripPlanet-IOS
//
//  Created by Mananas on 1/12/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class MyBmisViewController: UIViewController, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var bmis: [Bmi] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        Task {
            self.bmis = await self.getBmis()
                
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bmis.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BmiCell", for: indexPath) as! BmiViewCell
        let bmi = bmis[indexPath.row]
        cell.render(with: bmi)
        return cell
    }
    
    func getBmis() async -> [Bmi] {
        let userID = Auth.auth().currentUser!.uid
        var bmis: [Bmi] = []
            
        do {
            let db = Firestore.firestore()
            let querySnapshot = try await db.collection("Bmis").whereField("userId", isEqualTo: userID).order(by: "currentDate", descending: true).getDocuments()
                
            for document in querySnapshot.documents {
                let bmi = try document.data(as: Bmi.self)
                
                bmis.append(bmi)
            }
        } catch {
            print("Error reading chats from Firestore: \(error)")
        }
            
        return bmis
    }
    

}
