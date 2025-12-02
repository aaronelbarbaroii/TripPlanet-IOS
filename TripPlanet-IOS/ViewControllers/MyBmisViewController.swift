//
//  MyBmisViewController.swift
//  TripPlanet-IOS
//
//  Created by Mananas on 1/12/25.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class MyBmisViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var bmis: [Bmi] = []
    
    let deleteThreshold: CGFloat = -80
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.tableView.dataSource = self
        
        // añado para crear la accion deslizar y borrar un resgistro de la bbdd
        // me añade el UITableViewDelegate
        tableView.delegate = self
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
        // Crea una instancia de UISwipeGestureRecognizer
        
        /*cell.contentView.frame.origin.x = 0
       let swipeLeft = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        cell.contentView.addGestureRecognizer(swipeLeft)*/
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let itemToDelete = bmis[indexPath.row]

            // Borrar en Firebase
            let db = Firestore.firestore()
            db.collection("Bmis").document(itemToDelete.id).delete { error in
                
                if let error = error {
                    print("Error erasing: \(error)")
                    return
                }
                
                // Borrar localmente
                self.bmis.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                self.showAlert(message: "item deleted correctly")
            }
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
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

    /*
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let contentView = gesture.view else { return }
        let translation = gesture.translation(in: contentView)

        switch gesture.state {
        case .changed:
            // Solo permitir deslizar hacia la izquierda
            if translation.x < 0 {
                contentView.frame.origin.x = translation.x
            }

        case .ended, .cancelled:
            let shouldDelete = translation.x < deleteThreshold

            if shouldDelete {
                // Encontrar el indexPath de la celda
                if let cell = contentView.superview as? UITableViewCell,
                   let indexPath = tableView.indexPath(for: cell) {

                    let itemToDelete = bmis[indexPath.row]

                    // Borrar en Firebase
                    let db = Firestore.firestore()
                    db.collection("Bmis").document(itemToDelete.id).delete { error in
                        if let error = error {
                            print("Error erasing: \(error)")
                            // Volver a la posición inicial
                            UIView.animate(withDuration: 0.2) {
                                contentView.frame.origin.x = 0
                            }
                            return
                        }

                        // Borrar localmente
                        self.bmis.remove(at: indexPath.row)
                        self.tableView.deleteRows(at: [indexPath], with: .automatic)
                        self.showAlert(message: "item deleted correctly")
                    }
                }

            } else {
                // Si no se pasa el umbral, volver a la posición original
                UIView.animate(withDuration: 0.2) {
                    contentView.frame.origin.x = 0
                }
            }

        default:
            break
        }
    }
    */
    

}
