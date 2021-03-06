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
    @IBOutlet weak var contentView : UIView!
    @IBOutlet weak var lblError : UILabel!
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
        
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        favButton.isSelected = viewModel?.onFvaroite ?? false
    }
    
    
    func setupView(){
        contentView.isHidden = true
        lblError.isHidden = true
        setupDatePicker()
        
        indicator.color = UIColor(named: "LoaderColor")
        
        txtDatePicker?.layer.cornerRadius = 8
        txtDatePicker?.clipsToBounds = true
        txtDatePicker.layer.borderColor = UIColor.gray.cgColor
        txtDatePicker.layer.borderWidth = 1
        
        favButton.setImage(UIImage(systemName: "star"), for: .normal)
        favButton.setImage(UIImage(systemName: "star.fill"), for: .selected)
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
        viewModel?.fetchPictureOfTheDay(date: datePicker.date,
                                        loadFromCacheIfFails: false)
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
        if Constants.Selecteday == "" {
            viewModel?.viewDidload(date: Date())
        }else{
            
        }
        
        indicator.startAnimating()
        txtDatePicker.text = Date().string(format: Constants.dateFormat)
        viewModel?.updateViewOnSucess = { [weak self] (res,lastSynchdate) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.contentView.isHidden = false
                self.lblError.isHidden = true
                self.txtDatePicker.text = lastSynchdate
                self.updateView(with: res,
                                lastSynchdate:lastSynchdate)
            }
        }
        
        viewModel?.updateViewOnFailure = { [weak self] error in
            guard let self = self else { return }
            self.updateViewOnFailure(error:error)
           
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
            webView?.translatesAutoresizingMaskIntoConstraints = false
            merdiaView.addSubview(webView!)
            if let  url = URL(string:data.url) {
                webView?.load(URLRequest(url: url))
            }
            webView?.layer.cornerRadius = 8
            webView?.clipsToBounds = true
            webView?.leadingAnchor.constraint(equalTo: merdiaView.leadingAnchor).isActive = true
            webView?.trailingAnchor.constraint(equalTo: merdiaView.trailingAnchor,constant:0).isActive = true
            webView?.topAnchor.constraint(equalTo: merdiaView.topAnchor,constant:0).isActive = true
            webView?.bottomAnchor.constraint(equalTo: merdiaView.bottomAnchor,constant:0).isActive = true
        }
        else
        {
            webView?.removeFromSuperview()
            webView = nil
            imgViewMedia = UIImageView(frame: .zero)
            imgViewMedia?.frame = merdiaView.bounds
            imgViewMedia?.translatesAutoresizingMaskIntoConstraints = false
            merdiaView.addSubview(imgViewMedia!)
            imgViewMedia?.loadImage(withUrl: data.url)
            imgViewMedia?.layer.cornerRadius = 8
            imgViewMedia?.clipsToBounds = true
            imgViewMedia?.leadingAnchor.constraint(equalTo: merdiaView.leadingAnchor).isActive = true
            imgViewMedia?.trailingAnchor.constraint(equalTo: merdiaView.trailingAnchor,constant:0).isActive = true
            imgViewMedia?.topAnchor.constraint(equalTo: merdiaView.topAnchor,constant:0).isActive = true
            imgViewMedia?.bottomAnchor.constraint(equalTo: merdiaView.bottomAnchor,constant:0).isActive = true
            
        }
        favButton.isSelected = viewModel?.onFvaroite ?? false
        
    }
    
    func updateViewOnFailure(error:String){
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.indicator.stopAnimating()
            self.lblError.text = error
            self.contentView.isHidden = true
            self.lblError.isHidden = false
            self.favButton.isSelected =  false
        }
        
    }
}

