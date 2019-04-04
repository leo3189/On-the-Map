//
//  LocationTVCell.swift
//  On The Map
//
//  Created by leonard on 4/3/19.
//  Copyright © 2019 leonard. All rights reserved.
//

import UIKit

class LocationTVCell: UITableViewCell {
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var urlLbl: UILabel!
    
    static let identifier = "LocationCell"

    func configWith(_ info: StudentInformation) {
        nameLbl.text = info.labelName
        urlLbl.text = info.mediaURL
    }

}
