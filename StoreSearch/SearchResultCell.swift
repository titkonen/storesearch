//
//  SearchResultCell.swift
//  StoreSearch
//
//  Created by Toni Itkonen on 21/05/2019.
//  Copyright © 2019 Toni Itkonen. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {

    // MARK:- Properties
    var downloadTask: URLSessionDownloadTask?
    
    
    // MARK:- Outlets
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!
    
    // MARK:- Overrides
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Change custom selection colour.
        let selectedView = UIView(frame: CGRect.zero)
        selectedView.backgroundColor = UIColor(red: 20/255,
                                               green: 160/255, blue: 160/255, alpha: 0.5)
        selectedBackgroundView = selectedView
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    // cancel any image downloading that is still in progress.
    override func prepareForReuse() {
        super.prepareForReuse()
        downloadTask?.cancel()
        downloadTask = nil
        print("testing that canceling is OK!")
    }
    
    // MARK:- Public Methods
    func configure(for result: SearchResult) {
        nameLabel.text = result.name
        
        if result.artist.isEmpty {
            artistNameLabel.text = "Unknown"
        } else {
            artistNameLabel.text = String(format: "%@ (%@)",
            result.artist, result.type)
        }
        
        // This tells the UIImageView to load the image from imageSmall and to place it in the cell’s image view.
        artworkImageView.image = UIImage(named: "Placeholder")
        if let smallURL = URL(string: result.imageSmall) {
            downloadTask = artworkImageView.loadImage(url: smallURL)
        }
        
    }
    
    

} // End of class
