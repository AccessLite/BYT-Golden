
//
//  FoaasPreviewViewController.swift
//  BYT
//
//  Created by Louis Tur on 1/23/17.
//  Copyright © 2017 AccessLite. All rights reserved.
//

import UIKit

class FoaasPrevewViewController: UIViewController, FoaasTextFieldDelegate, FoaasPrevewViewDelegate{
    
    internal private(set) var operation: FoaasOperation?
    private var pathBuilder: FoaasPathBuilder?
    private var foaas: Foaas!
    
    var foaasSettingMenuDelegate : FoaasSettingMenuDelegate!
    
    var previewText: NSString = ""
    var previewAttributedText: NSAttributedString = NSAttributedString()
    
    var tapGestureRecognizer: UITapGestureRecognizer!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViewHierarchy()
        self.configureConstraints()
        
        self.foaasPreviewView.createTextFields(for: self.pathBuilder!.allKeys())
        self.foaasPreviewView.setTextFieldsDelegate(self)
        self.foaasPreviewView.delegate = self
        
        //Add tapGestureRecognizer to view
        tapGestureRecognizer = UITapGestureRecognizer(target: self.foaasPreviewView, action: #selector(tapGestureDismissKeyboard(_:)))
        self.view.isUserInteractionEnabled = true
        self.foaasPreviewView.isUserInteractionEnabled = true
        tapGestureRecognizer.cancelsTouchesInView = false
        tapGestureRecognizer.numberOfTapsRequired = 1
        tapGestureRecognizer.numberOfTouchesRequired = 1
        tapGestureRecognizer.delegate = self.foaasPreviewView
        self.foaasPreviewView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: - View Setup
    internal func setupViewHierarchy() {
        self.view.addSubview(foaasPreviewView)
    }
    
    internal func configureConstraints() {
        
        let _ = [
            foaasPreviewView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0.0),
            foaasPreviewView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0.0),
            foaasPreviewView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0.0),
            foaasPreviewView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0.0),
            ].map { $0.isActive = true }
    }
    
    
    // MARK: - FoaasButtonDelegateMethods
    
    internal func backButtonPressed() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    internal func doneButtonPressed() {
        let messageAndSubtitle = self.foaasPreviewView.previewTextView.text.components(separatedBy: "\n")
        let notificationCenter = NotificationCenter.default
        notificationCenter.post(name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: Foaas(message: messageAndSubtitle[0], subtitle: messageAndSubtitle[1..<messageAndSubtitle.count].joined(separator: "\n")))
        _ = navigationController?.popToRootViewController(animated: true)
        
    }
    
    // MARK: - Other
    internal func set(operation: FoaasOperation?) {
        guard let validOp = operation else { return }
        
        self.operation = validOp
        self.pathBuilder = FoaasPathBuilder(operation: validOp)
        
        self.request(operation: validOp)
    }
    
    internal func request(operation: FoaasOperation) {
        guard
            let validPathBulder = self.pathBuilder,
            let url = URL(string: validPathBulder.build())
            else {
                return
        }
        
        FoaasAPIManager.getFoaas(url: url, completion: { (foaas: Foaas?) in
            guard let validFoaas = foaas else { return }
            self.foaas = validFoaas
            let message = self.foaas.message.filterBadLanguage()
            let subtitle = self.foaas.subtitle.filterBadLanguage()
            DispatchQueue.main.async {
                
                let attributedString = NSMutableAttributedString(string: message, attributes: [NSForegroundColorAttributeName : UIColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 1.0), NSFontAttributeName : UIFont.Roboto.light(size: 24.0)! ])
                let fromAttribute = NSMutableAttributedString(string: "\n\n" + "From,\n" + subtitle, attributes: [ NSForegroundColorAttributeName : UIColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 1.0), NSFontAttributeName : UIFont.Roboto.light(size: 24.0)!])
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = .right
                
                let textLength = fromAttribute.string.characters.count
                let range = NSRange(location: 0, length: textLength)
                
                fromAttribute.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: range)
                attributedString.append(fromAttribute)
                
                self.foaasPreviewView.updateAttributedText(text: attributedString)
                self.previewText = attributedString.mutableString
                self.previewAttributedText = attributedString
                
                if let validFoaasPath = self.pathBuilder {
                    let keys = validFoaasPath.allKeys()
                    for key in keys {
                        let range = self.previewText.range(of: key)
                        let attributedStringToReplace = NSMutableAttributedString(string: validFoaasPath.operationFields[key]! , attributes: [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue, NSForegroundColorAttributeName : ColorManager.shared.currentColorScheme.accent, NSFontAttributeName : UIFont.Roboto.light(size: 24.0)!])
                        
                        let attributedTextWithGreenFields = NSMutableAttributedString.init(attributedString: self.previewAttributedText)
                        attributedTextWithGreenFields.replaceCharacters(in: range, with: attributedStringToReplace)
                        
                        self.foaasPreviewView.updateAttributedText(text: attributedTextWithGreenFields)
                        self.previewAttributedText = attributedTextWithGreenFields
                    }
                }
            }
        })
    }
    
    // TODO: needs live updating
    // MARK: - UITextField Delegate
    func foaasTextField(_ textField: FoaasTextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let validFoaasPath = self.pathBuilder else { return false }
        guard var validText = textField.textField.text else { return false }
        if textField.textField.text == "" {
            validText = " "
        }
        let updatedString = (validText as NSString).replacingCharacters(in: range, with: string)
        validFoaasPath.update(key: textField.identifier, value: updatedString)
        
        updateAttributedTextInput()
        return true
    }
    
    func foaasTextFieldShouldReturn(_ textField: FoaasTextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    func foaasTextFieldDidEndEditing(_ textField: FoaasTextField) {
        self.view.endEditing(true)
    }
    
    // MARK: - TapGestureRecognizer Function
    func tapGestureDismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    func updateAttributedTextInput() {
        if let validFoaasPath = self.pathBuilder {
            let attributedText = NSMutableAttributedString.init(attributedString: self.previewAttributedText)
            let keys = validFoaasPath.allKeys()
            for key in keys {
                let string = attributedText.string as NSString
                let rangeOfWord = string.range(of: key)
                
                let attributedStringToReplace = NSMutableAttributedString(string: validFoaasPath.operationFields[key]!, attributes: [NSUnderlineStyleAttributeName: NSUnderlineStyle.styleSingle.rawValue, NSForegroundColorAttributeName : ColorManager.shared.currentColorScheme.accent, NSFontAttributeName : UIFont.Roboto.light(size: 24.0)!])
                attributedText.replaceCharacters(in: rangeOfWord, with: attributedStringToReplace)
            }
            self.foaasPreviewView.updateAttributedText(text: attributedText)
        }
    }
    
    // TODO: add in delegation
    // MARK: - Lazy Inits
    internal lazy var foaasPreviewView: FoaasPreviewView = {
        let previewView = FoaasPreviewView()
        return previewView
    }()
    
}
