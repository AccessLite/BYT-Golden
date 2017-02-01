//
//  FoaasViewController.swift
//  BYT
//
//  Created by Louis Tur on 1/23/17.
//  Copyright © 2017 AccessLite. All rights reserved.
//

import UIKit
import Social

var languageFilterToggle: Bool = true

class FoaasViewController: UIViewController, FoaasViewDelegate, FoaasSettingMenuDelegate {
    
    // MARK: - View
    let foaasView: FoaasView = FoaasView(frame: CGRect.zero)
    let foaasSettingsMenuView: FoaasSettingsMenuView = FoaasSettingsMenuView(frame: CGRect.zero)
    
    // MARK: - Constraints
    var settingsMenuBottomConstraint: NSLayoutConstraint? = nil
    var foaasBottomConstraint: NSLayoutConstraint? = nil
    
    // MARK: - Models
    var foaas: Foaas?
    var message = ""
    var subtitle = ""
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //removing duplicate call for registering for Notifications
//        self.registerForNotifications()
        self.foaasView.delegate = self
        self.foaasSettingsMenuView.delegate = self
        
        setupViewHierarchy()
        configureConstraints()
        addGesturesAndActions()
        registerForNotifications()
        addFoaasViewShadow()
        makeRequest()
        updateSettingsMenu()
        
    }
    
    // MARK: - Setup
    private func configureConstraints() {
        self.foaasView.translatesAutoresizingMaskIntoConstraints = false
        self.foaasSettingsMenuView.translatesAutoresizingMaskIntoConstraints = false
        
        self.settingsMenuBottomConstraint = foaasSettingsMenuView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 100)
        self.foaasBottomConstraint = foaasView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)
        
            [
            // foaasSettingMenuView
            foaasSettingsMenuView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            foaasSettingsMenuView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            foaasSettingsMenuView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.333),
            settingsMenuBottomConstraint!,
            // foaasView
            foaasView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            foaasView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            foaasView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            foaasBottomConstraint!,
            ].activate()
        }
    
    private func setupViewHierarchy() {
        self.view.backgroundColor = .white
        self.view.addSubview(foaasSettingsMenuView)
        self.view.addSubview(foaasView)
        self.foaasView.backgroundColor = ColorManager.shared.currentColorScheme.primary
    }
    
    private func updateSettingsMenu() {
        
        // this is hard coded. Will work dynamically when Louis finishes the color scroll view implementation
        if ColorManager.shared.colorSchemes != nil && ColorManager.shared.colorSchemes.count > 2 {
            DispatchQueue.main.async {
                self.foaasSettingsMenuView.view1.backgroundColor = ColorManager.shared.colorSchemes[0].primary
                self.foaasSettingsMenuView.view2.backgroundColor = ColorManager.shared.colorSchemes[1].primary
                self.foaasSettingsMenuView.view3.backgroundColor = ColorManager.shared.colorSchemes[2].primary
            }
        }
        self.foaasSettingsMenuView.updateVersionLabels()
    }
    
    // MARK: - FoaasView Shadow
    func addFoaasViewShadow() {
        self.foaasView.layer.shadowColor = UIColor.black.cgColor
        self.foaasView.layer.shadowOpacity = 0.8
        self.foaasView.layer.shadowOffset = CGSize.zero
        self.foaasView.layer.shadowRadius = 8
    }
    
    // MARK: - Gesture Actions
    private func addGesturesAndActions() {
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(toggleSettingsMenu(sender:)))
        swipeUpGesture.direction = .up
        foaasView.addGestureRecognizer(swipeUpGesture)
        
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(toggleSettingsMenu(sender:)))
        swipeDownGesture.direction = .down
        foaasView.addGestureRecognizer(swipeDownGesture)
    }
    
    
    // MARK: - Notifications
    private func registerForNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(updateFoaas(sender:)), name: Notification.Name(rawValue: "FoaasObjectDidUpdate"), object: nil)
    }
    
    
    
    internal func updateFoaas(sender: Notification) {
        guard let validFoaas = sender.object as? Foaas else {
            print("The notification center did not register a Foaas Object. Fix your bug bro.")
            return
        }
        self.foaasView.mainTextLabel.text = validFoaas.message
        self.foaasView.subtitleTextLabel.text = validFoaas.subtitle
        self.foaas = validFoaas
    }
    
    
    
    
    // MARK: - Updating Foaas
    // TODO: replace this
    internal func makeRequest() {
        
        FoaasDataManager.shared.requestFoaas(url: FoaasDataManager.foaasURL!) { (foaas: Foaas?) in
            if let validFoaas = foaas {
                self.foaas = validFoaas
                
                DispatchQueue.main.async {
                    self.foaasView.mainTextLabel.text = validFoaas.message.filterBadLanguage(languageFilterToggle)
                    self.foaasView.subtitleTextLabel.text = validFoaas.subtitle.filterBadLanguage(languageFilterToggle)
                }
            }
            
            // Make the following API Call if the version has been updated...
            
            FoaasDataManager.shared.requestColorSchemeData(endpoint: FoaasAPIManager.colorSchemeURL) { (data: Data?) in
                guard let validData = data else { return }
                guard let colorSchemes = ColorScheme.parseColorSchemes(from: validData) else { return }
                ColorManager.shared.colorSchemes = colorSchemes
                DispatchQueue.main.async {
                    self.foaasSettingsMenuView.view1.backgroundColor = colorSchemes[0].primary
                    self.foaasSettingsMenuView.view2.backgroundColor = colorSchemes[1].primary
                    self.foaasSettingsMenuView.view3.backgroundColor = colorSchemes[2].primary
                }
            }
            
            FoaasDataManager.shared.requestVersionData(endpoint: FoaasAPIManager.versionURL) { (data: Data?) in
                guard let validData = data else { return }
                guard let version = Version.parseVersion(from: validData) else { return }
                
                if version.number != VersionManager.shared.currentVersion.number {
                    VersionManager.shared.currentVersion = version
                    DispatchQueue.main.async {
                        // update the version info in the settings menu view
                        self.foaasSettingsMenuView.updateVersionLabels()
                    }
                }
            }
        }
    }
    
    
    // MARK: - View Delegate
    func didTapActionButton() {
        guard let navVC = self.navigationController else { return }
        
        let dtvc = FoaasOperationsTableViewController()
        navVC.pushViewController(dtvc, animated: true)
    }
    
    func didTapSettingsButton() {
        if self.foaasView.frame.origin.y == 0 {
            animateSettingsMenu(show: true, duration: 0.8, dampening: 0.7, springVelocity: 7)
        } else {
            animateSettingsMenu(show: false, duration: 0.1)
        }
    }
    
    
    // MARK: - Animating Menu
    internal func toggleSettingsMenu(sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case UISwipeGestureRecognizerDirection.up where self.foaasView.frame.origin.y == 0:
            animateSettingsMenu(show: true, duration: 0.8, dampening: 0.7, springVelocity: 7)
        case UISwipeGestureRecognizerDirection.down where self.foaasView.frame.origin.y != 0:
            animateSettingsMenu(show: false, duration: 0.1)
        default: print("Not interested")
        }
    }
    
    private func animateSettingsMenu(show: Bool, duration: TimeInterval, dampening: CGFloat = 0.005, springVelocity: CGFloat = 0.005) {
        self.settingsMenuBottomConstraint?.constant = show ? 0.0 : 100.0
        self.foaasBottomConstraint?.constant = show ? -(self.foaasSettingsMenuView.frame.height) : 0
        self.foaasView.settingsMenuButton.transform = show ? CGAffineTransform(rotationAngle: CGFloat.pi) : CGAffineTransform.identity
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: dampening, initialSpringVelocity: springVelocity, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    // MARK: - FoaasSettingMenuDelegate Method
    
    func colorSwitcherScrollViewScrolled() {
        self.foaasView.backgroundColor = ColorManager.shared.currentColorScheme.primary
    }
    
    func profanitfySwitchChanged() {
        print("switch changed")
        
        guard let validFoaas = self.foaas else { return }
        
        languageFilterToggle = foaasSettingsMenuView.profanitySwitch.isOn

        self.foaasView.mainTextLabel.text = validFoaas.message.filterBadLanguage(languageFilterToggle)
        self.foaasView.subtitleTextLabel.text = validFoaas.subtitle.filterBadLanguage(languageFilterToggle)
    }
    
    func twitterButtonTapped() {
        sharePostTo(serviceType: SLServiceTypeTwitter)
    }
    
    func facebookButtonTapped() {
        sharePostTo(serviceType: SLServiceTypeFacebook)
    }
    
    // this function shares the current foaas message to twitter or facebook. Will need to add to the message with a BYT tag and also will need to be filtered if the filter is on. Will also need to be the string that gets passed back from operations VC
    
    func sharePostTo(serviceType: String!) {
        if let vc = SLComposeViewController(forServiceType: serviceType) {
            vc.setInitialText(self.foaas!.description)
            present(vc, animated: true, completion: nil)
        }
    }
    
    func camerarollButtonTapped() {
        print("cameraroll button tapped")
        guard let vaidImage = getScreenShotImage(view: self.view) else { return }
        //https://developer.apple.com/reference/uikit/1619125-uiimagewritetosavedphotosalbum
        UIImageWriteToSavedPhotosAlbum(vaidImage, self, #selector(createScreenShotCompletion(image: didFinishSavingWithError: contextInfo:)), nil)
    }
    
    func shareButtonTapped() {
        print("share button tapped")
        guard let validFoaas = self.foaas else { return }
        var arrayToShare: [String] = []
        arrayToShare.append(validFoaas.message.filterBadLanguage(languageFilterToggle))
        arrayToShare.append(validFoaas.subtitle.filterBadLanguage(languageFilterToggle))
        
        let activityViewController = UIActivityViewController(activityItems: arrayToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func uploadData() {
        self.view.reloadInputViews()
    }
    
    //MARK: - Helper functions
    ///Get current screenshot
    func getScreenShotImage(view: UIView) -> UIImage? {
        //https://developer.apple.com/reference/uikit/1623912-uigraphicsbeginimagecontextwitho
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, view.layer.contentsScale)
        guard let context = UIGraphicsGetCurrentContext() else{
            return nil
        }
        view.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    ///Present appropriate Alert by UIAlertViewController, indicating images are successfully saved or not
    ///https://developer.apple.com/reference/uikit/uialertcontroller
    internal func createScreenShotCompletion(image: UIImage, didFinishSavingWithError: NSError?, contextInfo: UnsafeMutableRawPointer?) {
        
        if didFinishSavingWithError != nil {
            print("Error in saving image.")
            let alertController = UIAlertController(title: "Failed to save screenshot to photo library", message: nil , preferredStyle: UIAlertControllerStyle.alert)
            let okay = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alertController.addAction(okay)
            // do not dismiss the alert yourself in code this way! add a button and let the user handle it
            present(alertController, animated: true, completion: nil)
        }
        else {
            // this has to be in an else clause. because if error is !nil, you're going to be presenting 2x of these alerts
            print("Image saved.")
            let alertController = UIAlertController(title: "Successfully saved screenshot to photo library", message: nil , preferredStyle: UIAlertControllerStyle.alert)
            let okay = UIAlertAction(title: "Okay", style: .cancel, handler: nil)
            alertController.addAction(okay)
            
            present(alertController, animated: true, completion: nil)
        }
    }
}

extension String {
    func filterBadLanguage (_ toggle: Bool) -> String {
        let wordsToBeFiltered: Set<String> = ["fuck", "bitch", "ass", "dick", "pussy", "shit", "twat", "cock"]
        let wordsToBeUnfiltered: [String: String] = ["f*ck" : "u", "b*tch" : "i", "*ss" : "a", "*ick": "i", "p*ssy": "u", "sh*t": "i", "tw*t" : "a", "c*ck" : "o"]
        let vowels: Set<Character> = ["a", "e", "i", "o", "u"]
        //Breaks down the word into an Arr, where every word will be checked and filtered
        func filterFoulWords (_ previewText: String) -> String {
            var words = previewText.components(separatedBy: " ")
            for (index, word) in words.enumerated() {
                let filteredWord = word.replacingOccurrences(of: word, with: filter(word), options: .caseInsensitive, range: nil)
                words[index] = filteredWord
            }
            return words.joined(separator: " ")
        }
        //this is the filter, it checks to see if the word contains an instance of a foul word by iterating over the foul words. if it comes back true, then it will replace the first instance of a vowel excepting y with a * and return the updated word.
        
        func filter(_ word: String) -> String {
            for foulWord in wordsToBeFiltered where word.lowercased().contains(foulWord){
                for char in word.lowercased().characters where vowels.contains(char) {
                    return word.replacingOccurrences(of: String(char), with: "*", options: .caseInsensitive, range: nil)
                }
            }
            return word
        }
        
        func unfilterFoulWords(_ previewText: String) -> String {
            var words = previewText.components(separatedBy: " ")
            for (index, word) in words.enumerated() {
                let filteredWord = word.replacingOccurrences(of: word, with: unfilter(word), options: .caseInsensitive, range: nil)
                words[index] = filteredWord
            }
            return words.joined(separator: " ")
        }
        
        func unfilter(_ word: String) -> String {
            for filteredWord in wordsToBeUnfiltered.keys where word.lowercased().contains(filteredWord) {
                    return word.replacingOccurrences(of: "*", with: wordsToBeUnfiltered[filteredWord]!, options: .caseInsensitive, range: nil)
            }
            return word
        }
        //implements the filter on itself.
        return toggle ? filterFoulWords(self) : unfilterFoulWords(self)
    }
}

