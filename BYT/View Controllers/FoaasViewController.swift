//
//  FoaasViewController.swift
//  BYT
//
//  Created by Louis Tur on 1/23/17.
//  Copyright © 2017 AccessLite. All rights reserved.
//

import UIKit
import Social


class FoaasViewController: UIViewController, FoaasViewDelegate, FoaasSettingMenuDelegate {
    
    // MARK: - View
    let foaasView: FoaasView = FoaasView(frame: CGRect.zero)
    let foaasSettingsMenuView: FoaasSettingsMenuView = FoaasSettingsMenuView(frame: CGRect.zero)
    
    // MARK: - Constraints
    var settingsMenuBottomConstraint: NSLayoutConstraint? = nil
    var foaasBottomConstraint: NSLayoutConstraint? = nil
    let defaults: UserDefaults = UserDefaults.standard
    
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
        
        UIView.animate(withDuration: 0.3) {
            self.foaasView.alpha = 1.0
        }
        
    }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    // this must be called after the views have been laid out and drawn to the screen. 
    // otherwise this gradient wont work
    self.foaasSettingsMenuView.foaasColorPickerView?.applyGradient()
    self.foaasSettingsMenuView.foaasColorPickerView?.setCurrentIndex(ColorManager.shared.colorSchemeIndex())
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
        notificationCenter.addObserver(self, selector: #selector(updateSettingsLabel(from:)), name: Notification.Name(rawValue: VersionManager.versionDidUpdateNotification), object: nil)
    }
    
    internal func updateSettingsLabel(from notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let _ = userInfo[VersionManager.versionUpdatedKey]
        else {
            return
        }
        
        DispatchQueue.main.async { [unowned self] in
            self.foaasSettingsMenuView.updateVersionLabels()
        }
    }
    
    internal func updateFoaas(sender: Notification) {
        guard let validFoaas = sender.object as? Foaas else {
            print("The notification center did not register a Foaas Object. Fix your bug bro.")
            return
        }
        self.foaasView.mainTextLabel.text = validFoaas.message
        self.foaasView.subtitleTextLabel.text = validFoaas.subtitle
        
        //Updates the constraint constant of subtitleLabel to newConstraintConstant asynchronously as the length of subtitleLabel.text changes
        DispatchQueue.main.async {
            let numberOfCharactersInSubtitle = validFoaas.subtitle.characters.count
            let newConstraintConstant = self.foaasView.subtitleLabelConstraint.constant - CGFloat(Double(numberOfCharactersInSubtitle) * 1.5)
            if newConstraintConstant < 16 {
                self.foaasView.subtitleLabelConstraint.constant = 16.0
                self.foaasView.layoutIfNeeded()
            } else {
                self.foaasView.subtitleLabelConstraint.constant = newConstraintConstant
                self.foaasView.layoutIfNeeded()
            }
        }

        self.foaas = validFoaas
    }
    
    
    
    
    // MARK: - Updating Foaas
    internal func makeRequest() {
        FoaasDataManager.shared.requestFoaas(url: FoaasDataManager.foaasURL!) { (foaas: Foaas?) in
            if let validFoaas = foaas {
                self.foaas = validFoaas
                
                DispatchQueue.main.async {
                    self.foaasView.mainTextLabel.text = validFoaas.message.filterBadLanguage()
                    self.foaasView.subtitleTextLabel.text = validFoaas.subtitle.filterBadLanguage()
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
        UIView.animate(withDuration: 0.3) {
            self.foaasView.backgroundColor = ColorManager.shared.currentColorScheme.primary
            self.foaasView.addButton.backgroundColor = ColorManager.shared.currentColorScheme.accent
            self.foaasView.settingsMenuButton.tintColor = ColorManager.shared.currentColorScheme.accent
            self.view.layoutIfNeeded()
        }
    }
    

    func profanitfySwitchToggled(on: Bool) {
        guard let validFoaas = self.foaas else { return }
        
        LanguageFilter.profanityAllowed = on
        self.foaasView.mainTextLabel.text = validFoaas.message.filterBadLanguage()
        self.foaasView.subtitleTextLabel.text = validFoaas.subtitle.filterBadLanguage()
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
            guard let validImage = getScreenShotImage(view: self.view) else { return }
//            vc.setInitialText(self.foaas!.description)
            vc.add(validImage)
            vc.add(URL(string: "https://github.com/AccessLite/BYT-Golden")!)
            present(vc, animated: true, completion: nil)
        }
    }
    
    func camerarollButtonTapped() {
        print("cameraroll button tapped")
        guard let validImage = getScreenShotImage(view: self.view) else { return }
        //https://developer.apple.com/reference/uikit/1619125-uiimagewritetosavedphotosalbum
        UIImageWriteToSavedPhotosAlbum(validImage, self, #selector(createScreenShotCompletion(image: didFinishSavingWithError: contextInfo:)), nil)
        
        //after the screenshot is saved, the settings menu will animate back into it's original position (show: true).
        //this will give the false impression that the screenshot includes the settings menu because of how quickly it occurs.
        animateSettingsMenu(show: true, duration: 0.1)
    }
    
    func shareButtonTapped() {
        print("share button tapped")
        guard let validFoaas = self.foaas else { return }
        var arrayToShare: [String] = []
        arrayToShare.append(validFoaas.message.filterBadLanguage())
        arrayToShare.append(validFoaas.subtitle.filterBadLanguage())
        
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
        
        //shortly before the graphics context for the view is determined, the settings menu will animate down (show: false)
        animateSettingsMenu(show: false, duration: 0.1)
        
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

