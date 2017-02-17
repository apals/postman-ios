//
//  MissionTableViewCell.swift
//  Postman
//
//  Created by Andreas Pålsson on 2017-02-17.
//  Copyright © 2017 KLANTEAM5. All rights reserved.
//

import UIKit

class MissionTableViewCell: UITableViewCell {

    @IBOutlet weak var missionTitleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
