//
//  UserViewController.swift
//  ios-swift-sdk-example
//
//  Copyright © 2016 SessionM. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, SessionMDelegate {

    @IBOutlet weak var sessionStateLabel: UILabel!
    @IBOutlet weak var isRegisteredLabel: UILabel!
    @IBOutlet weak var isSignInLabel: UILabel!
    @IBOutlet weak var isOptInLabel: UILabel!

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var confirmPasswordText: UITextField!
    @IBOutlet weak var yearOfBirthText: UITextField!

    @IBOutlet weak var genderFieldView: UIView!
    @IBOutlet weak var dummyGenderText: UITextField!
    @IBOutlet weak var genderOKButton: UIButton!
    @IBOutlet weak var genderSegment: UISegmentedControl!

    @IBOutlet weak var zipcodeText: UITextField!

    @IBOutlet weak var logMessage: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var optInOutButton: UIButton!

    @IBOutlet weak var toggleSegment: UISegmentedControl!

    let sessionM = SessionM.sharedInstance();

    override func viewDidLoad() {
        super.viewDidLoad();
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(_:)));
        self.view.addGestureRecognizer(tap);
    }

    func tap(_ tap : UITapGestureRecognizer) {
        self.view.endEditing(true);
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);

        sessionM.delegate = self;

        signupUI();
        editGender(false);
    }

    func signupUI() {
        loginButton.isHidden = true;
        logoutButton.isHidden = true;
        signupButton.isHidden = true;
        toggleSegment.isHidden = true;
        optInOutButton.isHidden = true;
        logMessage.isHidden = true;

        emailText.isHidden = true; passwordText.isHidden = true; confirmPasswordText.isHidden = true; yearOfBirthText.isHidden = true; zipcodeText.isHidden = true; genderFieldView.isHidden = true;

        if (sessionM.sessionState == .stopped) {
        } else if (sessionM.user.isRegistered) {
            logoutButton.isHidden = false;
            logoutButton.isEnabled = true;
            logMessage.isHidden = false;
            optInOutButton.isHidden = false;
            optInOutButton.setTitle(sessionM.user.isOptedOut ? "Opt In" : "Opt Out", for: UIControlState());
        } else {
            loginButton.isEnabled = true;
            signupButton.isEnabled = true;
            toggleSegment.isHidden = false;
            if (toggleSegment.selectedSegmentIndex == 1) {
                emailText.isHidden = false; passwordText.isHidden = false; confirmPasswordText.isHidden = false; yearOfBirthText.isHidden = false; zipcodeText.isHidden = false; genderFieldView.isHidden = false;
                signupButton.isHidden = false;
            } else {
                emailText.isHidden = false; passwordText.isHidden = false;
                loginButton.isHidden = false;
            }
        }

        isRegisteredLabel.text = sessionM.user.isRegistered ? "YES" : "NO";
        isSignInLabel.text = sessionM.user.isLoggedIn ? "YES" : "NO";
        isOptInLabel.text = sessionM.user.isOptedOut ? "NO" : "YES";

        switch sessionM.sessionState {
            case .stopped:
                sessionStateLabel.text = "Stopped";
            case .startedOffline:
                sessionStateLabel.text = "Started Offline";
            case .startedOnline:
                sessionStateLabel.text = "Started Online";
        }
    }

    // Gender

    func editGender(_ gndr : Bool) {
        dummyGenderText.isHidden = gndr;
        genderSegment.isHidden = !gndr;
        genderOKButton.isHidden = !gndr;
    }

    @IBAction func genderDummyTouched(_ sender: UITextField, forEvent event: UIEvent) {
        editGender(true);
    }

    @IBAction func genderOK(_ sender: UIButton) {
        dummyGenderText.text = genderSegment.titleForSegment(at: genderSegment.selectedSegmentIndex);
        editGender(false);
    }
    
    // Sign In / Sign Up

    @IBAction func toggle(_ sender: UISegmentedControl) {
        signupUI();
    }

    @IBAction func login(_ sender: UIButton) {
        loginButton.isEnabled = false;
        if let e = emailText.text, let p = passwordText.text {
            if (!sessionM.logInUser(withEmail: e, password: p)) {
                UIAlertView(title: "Invalid Authentication", message: "Please enter a valid email and password", delegate: nil, cancelButtonTitle: "OK").show();
                signupUI();
            }
        }
    }
    @IBAction func signup(_ sender: UIButton) {
        signupButton.isEnabled = false;
        var signupData : [String : NSObject] = [:];
        if let e = emailText.text, let p1 = passwordText.text, let p2 = confirmPasswordText.text {
            if (e.isEmpty || p1.isEmpty || p2.isEmpty) {
                let alert = UIAlertView(title: "Required Fields", message: "Email, Password, and Confirm Password are required.", delegate: nil, cancelButtonTitle: "OK");
                alert.show();
            } else if ( p1 != p2 ) {
                UIAlertView(title: "Password Mismatch", message: "Password and Confirmation don't match", delegate: nil, cancelButtonTitle: "OK").show();
            } else {
                signupData = [ "email" : e as NSObject, "password" : p1 as NSObject ];
                if let yob = yearOfBirthText.text {
                    if (!yob.isEmpty) { signupData["birth_year"] = yob as NSObject?; }
                }
                if let gndr = genderSegment {
                    if (gndr.selectedSegmentIndex > 0) { signupData["gender"] = gndr.titleForSegment(at: gndr.selectedSegmentIndex) as NSObject?; }
                }
                if let zip = zipcodeText.text {
                    if (!zip.isEmpty) { signupData["zip"] = zip as NSObject?; }
                }
            }
            if (!sessionM.signUpUser(withData: signupData)) {
                signupUI();
            }
        }
    }
    @IBAction func logout(_ sender: UIButton) {
        logoutButton.isEnabled = false;
        sessionM.logOutUser();
    }

    func sessionM(_ sessionM: SessionM, didFailWithError error: Error) {

        let ac = UIAlertController(title: "Failure", message: error.localizedDescription, preferredStyle: .alert);
        self.present(ac, animated: true) {
            self.signupUI();
        };
    }

    func sessionM(_ sessionM: SessionM, didUpdateUserRegistrationResult result: SMUserRegistrationResultType, errors: [String : NSObject]?) {
        var msg : [String] = [];
        if let errs = errors {
            for (key, valArray) in errs {
                msg.append("\(key) => \(valArray)");
            }
            UIAlertView(title: "Error(s) from Server", message: msg.joined(separator: "\n"), delegate: nil, cancelButtonTitle: "OK").show();
        }
        self.signupUI();
    }

    func sessionM(_ sessionM: SessionM, didUpdateUser user: SMUser) {
        signupUI();
    }

    @IBAction func optInOut(_ sender: UIButton) {
        sessionM.user.isOptedOut = !sessionM.user.isOptedOut;
    }

}
