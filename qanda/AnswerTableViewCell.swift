//
//  AnswerTableViewCell.swift
//  qanda
//
//  Created by Rachel Ng on 2/28/18.
//  Copyright © 2018 Rachel Ng. All rights reserved.
//

import UIKit

protocol AnswerTableViewCellDelegate: class {
    func addLike()
}

class AnswerTableViewCell: UITableViewCell {
    
    weak var delegate: AnswerTableViewCellDelegate?
    
    @IBOutlet var writerLabel: UILabel!
    @IBOutlet var answerContentLabel: UILabel!
    @IBOutlet var answerDescLabel: UILabel!
    @IBOutlet var likesLabel: UILabel!
    
    @IBAction func likeBtnPressed(_ sender: UIButton) {
        delegate?.addLike()
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
