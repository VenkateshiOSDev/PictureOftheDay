//
//  FavListCell.swift
//  PictureOfDay
//
//  Created by Venkatesh Savarala on 12/02/22.
//

import UIKit
import WebKit
class FavListCell: UITableViewCell {
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var lblDescription : UILabel!
    @IBOutlet weak var merdiaView : UIView!
    @IBOutlet weak var imgViewMedia : UIImageView!
    @IBOutlet weak var webView : WKWebView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgViewMedia?.layer.cornerRadius = 8
        imgViewMedia?.clipsToBounds = true
        
        webView?.layer.cornerRadius = 8
        webView?.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupData(for data:BaseResponse){
        lblTitle.text = data.title
        lblDescription.text = data.explanation
        if data.media_type == "video"
        {
            imgViewMedia.isHidden = true
            webView.isHidden = false
            if let  url = URL(string:data.url) {
                webView.load(URLRequest(url: url))
            }
        }
        else
        {
            webView.isHidden = true
            imgViewMedia.isHidden = false
            imgViewMedia?.loadImage(withUrl: data.url)
            
        }
    }
}
