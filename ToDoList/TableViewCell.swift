//
//  TableViewCell.swift
//  ToDoList
//
//  Created by Yasir  on 12/13/21.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var taskLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var markImg: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
