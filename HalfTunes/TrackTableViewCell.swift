//
//  TrackTableViewCell.swift
//  HalfTunes
//
//  Created by Arpit Pittie on 14/12/16.
//  Copyright © 2016 Metacube. All rights reserved.
//

import UIKit

protocol TrackCellDelegate {
    func pauseTapped(_ cell: TrackTableViewCell)
    func resumeTapped(_ cell: TrackTableViewCell)
    func cancelTapped(_ cell: TrackTableViewCell)
    func downloadTapped(_ cell: TrackTableViewCell)
}

class TrackTableViewCell: UITableViewCell {

    // MARK: Properties
    
    var delegate: TrackCellDelegate?
    
    @IBOutlet weak var trackLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var downloadProgress: UIProgressView!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var downloadProgressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func pauseOrResumeTapped(_ sender: AnyObject) {
        if(pauseButton.titleLabel!.text == "Pause") {
            delegate?.pauseTapped(self)
        } else {
            delegate?.resumeTapped(self)
        }
    }
    
    @IBAction func cancelTapped(_ sender: AnyObject) {
        delegate?.cancelTapped(self)
    }
    
    @IBAction func downloadTapped(_ sender: AnyObject) {
        delegate?.downloadTapped(self)
    }
}
