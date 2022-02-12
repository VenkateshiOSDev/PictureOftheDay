//
//  ViewController.swift
//  PictureOfDay
//
//  Created by Venkatesh Savarala on 12/02/22.
//

import UIKit
import WebKit
class HomeVC: UIViewController {
    @IBOutlet weak var txtDatePicker : UITextField!
    @IBOutlet weak var lblTitle : UILabel!
    @IBOutlet weak var txtDescription : UITextView!
    @IBOutlet weak var merdiaView : UIView!
    @IBOutlet weak var indicator : UIActivityIndicatorView!
    @IBOutlet weak var lblLastUpdated : UILabel!
    @IBOutlet weak var favButton : UIButton!
    var viewModel : HomeViewModelProtocol?
    var datePicker :UIDatePicker!
    var imgViewMedia : UIImageView?
    var webView : WKWebView?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setpViewModel(view_Model: HomeViewModel(catchRequired: true,
                                                apiKey: Constants.ApiKey,
                                                dateFormat: Constants.dateFormat))
        setupDatePicker()
        
        indicator.color = UIColor(named: "LoaderColor")
        
        txtDatePicker?.layer.cornerRadius = 8
        txtDatePicker?.clipsToBounds = true
        txtDatePicker.layer.borderColor = UIColor.gray.cgColor
        txtDatePicker.layer.borderWidth = 1
        
        favButton.setImage(UIImage(systemName: "star"), for: .normal)
        favButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favButton.isSelected = viewModel?.onFvaroite ?? false
    }
    
    func setupDatePicker(){
        datePicker = UIDatePicker.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 200))
        datePicker.addTarget(self, action: #selector(self.dateChanged), for: .allEvents)
        txtDatePicker.inputView = datePicker
        datePicker.maximumDate = Date()
        datePicker.datePickerMode = .date
        let doneButton = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(self.datePickerDone))
        let toolBar = UIToolbar.init(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 44))
        toolBar.setItems([UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil), doneButton], animated: true)
        txtDatePicker.inputAccessoryView = toolBar
    }
    
    @objc func datePickerDone() {
        indicator.startAnimating()
        txtDatePicker.resignFirstResponder()
        viewModel?.fetchPictureOfTheDay(date: datePicker.date)
    }
    
    @objc func dateChanged() {
        txtDatePicker.text = datePicker.date.string(format: viewModel?.dateFormat ?? "")
    }
    
    
    @IBAction func btnTapFavroite(_ sender:UIButton){
        viewModel?.onTapOnFavroite()
        favButton.isSelected = viewModel?.onFvaroite ?? false
    }
    func setpViewModel(view_Model:HomeViewModelProtocol){
        viewModel = view_Model
        viewModel?.viewDidload()
        indicator.startAnimating()
        txtDatePicker.text = Date().string(format: Constants.dateFormat)
        viewModel?.updateViewOnSucess = { [weak self] (res,lastSynchdate) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.txtDatePicker.text = lastSynchdate
                self.updateView(with: res,
                                lastSynchdate:lastSynchdate)
            }
        }
        
        viewModel?.updateViewOnFailure = { [weak self] error in
            guard let self = self else { return }
            self.updateViewOnFailure()
        }
    }
    
    func updateView(with data:BaseResponse,lastSynchdate:String){
        self.indicator.stopAnimating()
        lblTitle.text = data.title
        txtDescription.text = data.explanation
        lblLastUpdated.text = "Last updated information for " + lastSynchdate
        if data.media_type == "video"
        {
            imgViewMedia?.removeFromSuperview()
            imgViewMedia = nil
            webView = WKWebView(frame: .zero)
            webView?.frame = merdiaView.bounds
            merdiaView.addSubview(webView!)
            if let  url = URL(string:data.url) {
                webView?.load(URLRequest(url: url))
            }
            webView?.layer.cornerRadius = 8
            webView?.clipsToBounds = true
        }
        else
        {
            webView?.removeFromSuperview()
            webView = nil
            imgViewMedia = UIImageView(frame: .zero)
            imgViewMedia?.frame = merdiaView.bounds
            merdiaView.addSubview(imgViewMedia!)
            imgViewMedia?.loadImage(withUrl: data.url)
            imgViewMedia?.layer.cornerRadius = 8
            imgViewMedia?.clipsToBounds = true
            
        }
        favButton.isSelected = viewModel?.onFvaroite ?? false
        
    }
    
    func updateViewOnFailure(){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.indicator.stopAnimating()
        }
        
    }
}

