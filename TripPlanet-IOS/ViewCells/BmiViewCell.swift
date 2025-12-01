//
//  BmiViewCell.swift
//  TripPlanet-IOS
//
//  Created by Mananas on 1/12/25.
//

import UIKit

class BmiViewCell: UITableViewCell {
    
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bmiLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func render(with bmi: Bmi) {
        let date = bmi.currentDate
        let currentDate = Date(timeIntervalSince1970: TimeInterval(date) / 1000)
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        let dateFormatted = formatter.string(from: currentDate)
        dateLabel.text = dateFormatted
        bmiLabel.text = String(bmi.bmi)
    }

}
