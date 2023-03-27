//
//  LoginVC.swift
//  Pixel Photo
//
//  Created by Macbook Pro on 18/10/2019.
//  Copyright © 2019 Olivin Esguerra. All rights reserved.
//

import UIKit

class LoginVC: BaseVC {
    
    @IBOutlet weak var orContainerView: UIView!
    @IBOutlet weak var forgotPasswordBtn: UIButton!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var googleloginView: UIView!
    @IBOutlet weak var facebookloginView: UIView!
    @IBOutlet weak var appleloginView: UIView!
    @IBOutlet weak var wowonderloginView: UIView!
    @IBOutlet weak var googleloginButton: UIButton!
    @IBOutlet weak var facebookloginButton: FBButton!
    @IBOutlet weak var appleloginButton: ASAuthorizationAppleIDButton!
    @IBOutlet weak var emailTxtFld: BorderedTextField!
    @IBOutlet weak var passwordTxtFld: BorderedTextField!
    
    @IBOutlet weak var signInLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.passwordTxtFld.textField.isSecureTextEntry = true
        self.passwordTxtFld.placeholder = "Password"
        self.emailTxtFld.placeholder = "Email"
        passwordTxtFld.isRoundedRect(cornerRadius: 10, hasBorderColor: .textFeildCornerRadiusColor)
        emailTxtFld.isRoundedRect(cornerRadius: 10, hasBorderColor: .textFeildCornerRadiusColor)
        self.googleloginView.isRoundedRect(cornerRadius: 16)
        self.facebookloginView.isRoundedRect(cornerRadius: 16)
        self.appleloginView.isRoundedRect(cornerRadius: 16)
        self.loginView.isRoundedRect(cornerRadius: 15)
        
        let l1 = CAGradientLayer()
        l1.colors = [UIColor(named: "Theme 2")!.cgColor  , UIColor(named: "Theme 1")!.cgColor ]
        l1.startPoint = CGPoint(x: 0, y: 0.5)
        l1.endPoint = CGPoint(x: 1, y: 0.5)
        l1.frame = self.loginView.bounds
        self.loginView.layer.insertSublayer(l1, at: 0)
//        self.contentCollectionView.delegate = self
//        self.loginView.applyGradient(colours: [UIColor.startColor, UIColor.endColor], start: CGPoint(x: 0.0, y: 1.0), end: CGPoint(x: 1.0, y: 1.0), borderColor: UIColor.clear)
    }
    
    @IBAction func facebookPressed(_ sender: Any) {
        facebookLogin()
    }
    
    @IBAction func googleloginButtonClick(_ sender: Any) {
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    @IBAction func forgetPassPressed(_ sender: Any) {
        let vc = R.storyboard.main.forgetPasswordVC()
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    @IBAction func registerPressed(_ sender: Any) {
        let vc = R.storyboard.main.signUpVC()
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    func setupUI(){
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationItem.hidesBackButton = true
        self.emailTxtFld.placeholder = NSLocalizedString("Email", comment: "Email")
        self.passwordTxtFld.placeholder = NSLocalizedString("Password", comment: "Password")
        self.signInLabel.text = NSLocalizedString("Continue", comment: "Continue")
//        self.fbLoginBtn.titleLabel?.textAlignment = .center
//        self.fbLoginBtn.setTitle(NSLocalizedString("Continue with Facebook", comment: "Continue with Facebook"), for: .normal)
//        self.fbLoginBtn.titleLabel?.font = UIFont(name: "Arial Rounded MT Bold", size: 15.0)
//        self.title = NSLocalizedString("Sign In", comment: "")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Create Account", style: .done, target: self, action: #selector(creatAccountTapped))
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.hexStringToUIColor(hex: "#73348D")
       
        self.forgotPasswordBtn.setTitle(NSLocalizedString("Forgot your password?", comment: ""), for: UIControl.State.normal)
        self.forgotPasswordBtn.tintColor = UIColor.hexStringToUIColor(hex: "#73348D")
        
        
        if !ControlSettings.EnableSocialLogin {
//            self.fbLoginBtn.isHidden = true
//            self.googleSignBtn.isHidden = true
            self.orContainerView.isHidden = true
        }else{
//            self.fbLoginBtn.isHidden = false
//            self.googleSignBtn.isHidden = false
            self.orContainerView.isHidden = false
        }
        let Logintap = UITapGestureRecognizer(target: self, action: #selector(self.loginTapped(_:)))
        self.loginView.isUserInteractionEnabled = true
        self.loginView.addGestureRecognizer(Logintap)
        
        let googletap = UITapGestureRecognizer(target: self, action: #selector(self.googleTapped(_:)))
//        self.googleSignBtn.isUserInteractionEnabled = true
//        self.googleSignBtn.addGestureRecognizer(googletap)
        
        appleloginButton.addTarget(self, action: #selector(loginWithApplePressed), for: .touchUpInside)
    }
    
    @objc func loginTapped(_ sender: UITapGestureRecognizer) {
        loginPressed()
    }
    
    @objc func creatAccountTapped() {
        let vc = R.storyboard.main.signUpVC()
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    @objc func googleTapped(_ sender: UITapGestureRecognizer) {
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
        GIDSignIn.sharedInstance().signIn()
    }
    
    @objc func loginWithApplePressed() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
      }
    
    private func loginPressed(){
        if appDelegate.isInternetConnected{
            
            if (self.emailTxtFld.text?.isEmpty)!{
                
                let securityAlertVC = R.storyboard.popup.securityPopupVC()
                securityAlertVC?.titleText  = NSLocalizedString("Security", comment: "Security")
                securityAlertVC?.errorText = NSLocalizedString("Please enter username.", comment: "Please enter username.")
                self.present(securityAlertVC!, animated: true, completion: nil)
                
            }else if (passwordTxtFld.text?.isEmpty)!{
                
                let securityAlertVC = R.storyboard.popup.securityPopupVC()
                securityAlertVC?.titleText  = NSLocalizedString("Security", comment: "Security")
                securityAlertVC?.errorText = NSLocalizedString("Please enter password.", comment: "Please enter password.")
                self.present(securityAlertVC!, animated: true, completion: nil)
                
            }else{
                
                self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
                let email = self.emailTxtFld.text ?? ""
                let password = self.passwordTxtFld.text ?? ""
                let deviceId = UserDefaults.standard.getDeviceId(Key: Local.DEVICE_ID.DeviceId)
                Async.background({
                    UserManager.instance.authenticateUser(userName: email, password: password, DeviceId: "", completionBlock: { (success, sessionError, error) in
                        if success != nil{
                            Async.main{
                                self.dismissProgressDialog{
                                    
                                    log.verbose("Success = \(success?.data?.accessToken ?? "")")
                                    AppInstance.instance.getUserSession()
                                    AppInstance.instance.fetchUserProfile()
                                    UserDefaults.standard.setPassword(value: password, ForKey: Local.USER_SESSION.Current_Password)
                                    
                                    let dashboardNav =  R.storyboard.dashboard.tabbarVC()
                                    dashboardNav?.modalPresentationStyle = .fullScreen
                                    self.present(dashboardNav!, animated: true, completion: nil)
//                                    self.view.makeToast("Login Successfull!!")
                                }
                            }
                        }else if sessionError != nil{
                            Async.main{
                                self.dismissProgressDialog {
                                    
                                    log.verbose("session Error = \(sessionError?.errors?.errorText ?? "")")
                                    let securityAlertVC = R.storyboard.popup.securityPopupVC()
                                    securityAlertVC?.titleText  = NSLocalizedString("Security", comment: "Security")
                                    securityAlertVC?.errorText = sessionError?.errors?.errorText ?? ""
                                    self.present(securityAlertVC!, animated: true, completion: nil)
                                }
                            }
                        }else {
                            Async.main({
                                self.dismissProgressDialog {
                                    
                                    log.verbose("error = \(error?.localizedDescription ?? "")")
                                    let securityAlertVC = R.storyboard.popup.securityPopupVC()
                                    securityAlertVC?.titleText  = NSLocalizedString("Security", comment: "Security")
                                    securityAlertVC?.errorText = error?.localizedDescription ?? ""
                                    self.present(securityAlertVC!, animated: true, completion: nil)
                                }
                            })
                        }
                    })
                })
            }
        }else{
            self.dismissProgressDialog {
                
                let securityAlertVC = R.storyboard.popup.securityPopupVC()
                securityAlertVC?.titleText  = NSLocalizedString("Internet Error", comment: "Internet Error")
                securityAlertVC?.errorText = InterNetError
                self.present(securityAlertVC!, animated: true, completion: nil)
                log.error("internetError - \(InterNetError)")
            }
        }
    }
    
    private func facebookLogin(){
        if Connectivity.isConnectedToNetwork(){
            let fbLoginManager : LoginManager = LoginManager()
            fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) in
                if (error == nil){
                     self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
                    let fbloginresult : LoginManagerLoginResult = result!
                    if (result?.isCancelled)!{
                        self.dismissProgressDialog{
                            log.verbose("result.isCancelled = \(result?.isCancelled ?? false)")
                        }
                        return
                    }
                    if fbloginresult.grantedPermissions != nil {
                        if(fbloginresult.grantedPermissions.contains("email")) {
                            if((AccessToken.current) != nil){
                                GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completion: { (connection, result, error) -> Void in
                                    if (error == nil){
                                        let dict = result as! [String : AnyObject]
                                        log.debug("result = \(dict)")
                                        guard (dict["first_name"] as? String) != nil else {return}
                                        guard (dict["last_name"] as? String) != nil else {return}
                                        guard (dict["email"] as? String) != nil else {return}
                                        let accessToken = AccessToken.current?.tokenString ?? ""
                                        Async.background({
                                            UserManager.instance.socialLogin(provider: "facebook", accessToken: accessToken, googleApiKey: "", completionBlock: { (success, sessionError,error) in
                                                if success != nil{
                                                    Async.main{
                                                        self.dismissProgressDialog{
                                                            log.verbose("Success = \(success?.code ?? "")")
                                                            AppInstance.instance.getUserSession()
                                                            AppInstance.instance.fetchUserProfile()
                                                            let vc = R.storyboard.dashboard.tabbarVC()
                                                            vc?.modalPresentationStyle = .fullScreen
                                                            
                                                            self.present(vc!, animated: true, completion: nil)
                                                            self.view.makeToast("Login Successfull!!")
                                                        }
                                                        
                                                    }
                                                }else if sessionError != nil{
                                                    Async.main{
                                                        self.dismissProgressDialog {
                                                            log.verbose("session Error = \(sessionError?.errors?.errorText ?? "")")
                                                            
                                                            let securityAlertVC = R.storyboard.popup.securityPopupVC()
                                                            securityAlertVC?.titleText  = NSLocalizedString("Security", comment: "Security")
                                                            securityAlertVC?.errorText = sessionError?.errors?.errorText ?? ""
                                                            self.present(securityAlertVC!, animated: true, completion: nil)
                                                            
                                                        }
                                                    }
                                                }else {
                                                    Async.main({
                                                        self.dismissProgressDialog {
                                                            log.verbose("error = \(error?.localizedDescription ?? "")")
                                                            let securityAlertVC = R.storyboard.popup.securityPopupVC()
                                                            securityAlertVC?.titleText  = NSLocalizedString("Security", comment: "Security")
                                                            securityAlertVC?.errorText = error?.localizedDescription ?? ""
                                                            self.present(securityAlertVC!, animated: true, completion: nil)
                                                        }
                                                    })
                                                }
                                            })
                                        })
                                        log.verbose("FBSDKAccessToken.current() = \(AccessToken.current?.tokenString ?? "")")
                                    }
                                })
                            }
                        }
                    }
                }
            }
        }else{
            self.dismissProgressDialog {
                let securityAlertVC = R.storyboard.popup.securityPopupVC()
                securityAlertVC?.titleText  = NSLocalizedString("Internet Error", comment: "Internet Error")
                securityAlertVC?.errorText = InterNetError
                self.present(securityAlertVC!, animated: true, completion: nil)
                log.error("internetError - \(InterNetError)")
            }
        }
    }
    
    private func googleLogin(accessToken:String){
        if appDelegate.isInternetConnected{
            let deviceId = UserDefaults.standard.getDeviceId(Key: Local.DEVICE_ID.DeviceId) ?? ""
             self.showProgressDialog(text: NSLocalizedString("Loading...", comment: "Loading..."))
            Async.background({
                UserManager.instance.socialLogin(provider: "google", accessToken: accessToken, googleApiKey: ControlSettings.googleApiKey, completionBlock: { (success, sessionError,error) in
//                    if success != nil{
//                        Async.main{
//                            self.dismissProgressDialog{
//                                log.verbose("Success = \(success?.code ?? "")")
//                                AppInstance.instance.getUserSession()
//                                AppInstance.instance.fetchUserProfile()
//                                let dashboardNav =  R.storyboard.dashboard.tabbarVC()
//                                dashboardNav?.modalPresentationStyle = .fullScreen
//                                self.present(dashboardNav!, animated: true, completion: nil)
////                                self.view.makeToast("Login Successfull!!")
//                            }
//
//                        }
//                    }else if sessionError != nil{
//                        Async.main{
//                            self.dismissProgressDialog {
//                                log.verbose("session Error = \(sessionError?.errors?.errorText ?? "")")
//
//                                let securityAlertVC = R.storyboard.popup.securityPopupVC()
//                                securityAlertVC?.titleText  = NSLocalizedString("Security", comment: "Security")
//                                securityAlertVC?.errorText = sessionError?.errors?.errorText ?? ""
//                                self.present(securityAlertVC!, animated: true, completion: nil)
//
//                            }
//                        }
//                    }else {
//                        Async.main({
//                            self.dismissProgressDialog {
//                                log.verbose("error = \(error?.localizedDescription ?? "")")
//                                let securityAlertVC = R.storyboard.popup.securityPopupVC()
//                                securityAlertVC?.titleText  = NSLocalizedString("Security", comment: "Security")
//                                securityAlertVC?.errorText = error?.localizedDescription ?? ""
//                                self.present(securityAlertVC!, animated: true, completion: nil)
//                            }
//                        })
//                    }
                    
                    if success != nil{
                        Async.main{
                            self.dismissProgressDialog{
                                log.verbose("Success = \(success?.code ?? "")")
                                AppInstance.instance.getUserSession()
                                AppInstance.instance.fetchUserProfile()
                                let dashboardNav =  R.storyboard.dashboard.tabbarVC()
                                dashboardNav?.modalPresentationStyle = .fullScreen
                                self.present(dashboardNav!, animated: true, completion: nil)
                                self.view.makeToast(NSLocalizedString("Login Successfull!!", comment: ""))
                            }
                            
                        }
                    }else if sessionError != nil{
                        Async.main{
                            self.dismissProgressDialog {
                                log.verbose("session Error = \(sessionError?.errors?.errorText ?? "")")
                                
                                let securityAlertVC = R.storyboard.popup.securityPopupVC()
                                securityAlertVC?.titleText  = (NSLocalizedString("Security", comment: ""))
                                securityAlertVC?.errorText = sessionError?.errors?.errorText ?? ""
                                self.present(securityAlertVC!, animated: true, completion: nil)
                                
                            }
                        }
                    }else {
                        Async.main({
                            self.dismissProgressDialog {
                                log.verbose("error = \(error?.localizedDescription ?? "")")
                                let securityAlertVC = R.storyboard.popup.securityPopupVC()
                                securityAlertVC?.titleText  = (NSLocalizedString("Security", comment: ""))
                                securityAlertVC?.errorText = error?.localizedDescription ?? ""
                                self.present(securityAlertVC!, animated: true, completion: nil)
                            }
                        })
                    }
                })
            })
            
        }else{
            self.dismissProgressDialog {
                
                let securityAlertVC = R.storyboard.popup.securityPopupVC()
                securityAlertVC?.titleText  = NSLocalizedString("Internet Error", comment: "Internet Error")
                securityAlertVC?.errorText = InterNetError
                self.present(securityAlertVC!, animated: true, completion: nil)
                log.error("internetError - \(InterNetError)")
            }
        }
        
    }
    
}

extension LoginVC : GIDSignInDelegate{
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            self.googleLogin(accessToken: user.authentication.idToken)
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
    }
}

extension LoginVC: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
        let userIdentifier = appleIDCredential.authorizationCode
    let fullName = appleIDCredential.fullName
    let email = appleIDCredential.email
        let authorizationCode = String(data: appleIDCredential.identityToken!, encoding: .utf8)!
        print("authorizationCode: \(authorizationCode)")
        //self.socialLogin(accesstoken: authorizationCode, provider: "apple", googleKey: "")
    
        
    print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))") }
    }
}
