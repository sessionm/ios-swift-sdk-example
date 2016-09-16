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

    func tap(tap : UITapGestureRecognizer) {
        self.view.endEditing(true);
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);

        sessionM.delegate = self;

        signupUI();
        editGender(false);
    }

    func signupUI() {
        loginButton.hidden = true;
        logoutButton.hidden = true;
        signupButton.hidden = true;
        toggleSegment.hidden = true;
        optInOutButton.hidden = true;
        logMessage.hidden = true;

        emailText.hidden = true; passwordText.hidden = true; confirmPasswordText.hidden = true; yearOfBirthText.hidden = true; zipcodeText.hidden = true; genderFieldView.hidden = true;

        if (sessionM.sessionState == .Stopped) {
        } else if (sessionM.user.isRegistered) {
            logoutButton.hidden = false;
            logoutButton.enabled = true;
            logMessage.hidden = false;
            optInOutButton.hidden = false;
            optInOutButton.setTitle(sessionM.user.isOptedOut ? "Opt In" : "Opt Out", forState: .Normal);
        } else {
            loginButton.enabled = true;
            signupButton.enabled = true;
            toggleSegment.hidden = false;
            if (toggleSegment.selectedSegmentIndex == 1) {
                emailText.hidden = false; passwordText.hidden = false; confirmPasswordText.hidden = false; yearOfBirthText.hidden = false; zipcodeText.hidden = false; genderFieldView.hidden = false;
                signupButton.hidden = false;
            } else {
                emailText.hidden = false; passwordText.hidden = false;
                loginButton.hidden = false;
            }
        }

        isRegisteredLabel.text = sessionM.user.isRegistered ? "YES" : "NO";
        isSignInLabel.text = sessionM.user.isLoggedIn ? "YES" : "NO";
        isOptInLabel.text = sessionM.user.isOptedOut ? "NO" : "YES";

        switch sessionM.sessionState {
            case .Stopped:
                sessionStateLabel.text = "Stopped";
            case .StartedOffline:
                sessionStateLabel.text = "Started Offline";
            case .StartedOnline:
                sessionStateLabel.text = "Started Online";
        }
    }

    // Gender

    func editGender(gndr : Bool) {
        dummyGenderText.hidden = gndr;
        genderSegment.hidden = !gndr;
        genderOKButton.hidden = !gndr;
    }

    @IBAction func genderDummyTouched(sender: UITextField, forEvent event: UIEvent) {
        editGender(true);
    }

    @IBAction func genderOK(sender: UIButton) {
        dummyGenderText.text = genderSegment.titleForSegmentAtIndex(genderSegment.selectedSegmentIndex);
        editGender(false);
    }
    
    // Sign In / Sign Up

    @IBAction func toggle(sender: UISegmentedControl) {
        signupUI();
    }

    @IBAction func login(sender: UIButton) {
        loginButton.enabled = false;
        if let e = emailText.text, p = passwordText.text {
            if (!sessionM.logInUserWithEmail(e, password: p)) {
                UIAlertView(title: "Invalid Authentication", message: "Please enter a valid email and password", delegate: nil, cancelButtonTitle: "OK").show();
                signupUI();
            }
        }
    }
    @IBAction func signup(sender: UIButton) {
        signupButton.enabled = false;
        var signupData : [String : NSObject] = [:];
        if let e = emailText.text, p1 = passwordText.text, p2 = confirmPasswordText.text {
            if (e.isEmpty || p1.isEmpty || p2.isEmpty) {
                let alert = UIAlertView(title: "Required Fields", message: "Email, Password, and Confirm Password are required.", delegate: nil, cancelButtonTitle: "OK");
                alert.show();
            } else if ( p1 != p2 ) {
                UIAlertView(title: "Password Mismatch", message: "Password and Confirmation don't match", delegate: nil, cancelButtonTitle: "OK").show();
            } else {
                signupData = [ "email" : e, "password" : p1 ];
                if let yob = yearOfBirthText.text {
                    if (!yob.isEmpty) { signupData["birth_year"] = yob; }
                }
                if let gndr = genderSegment {
                    if (gndr.selectedSegmentIndex > 0) { signupData["gender"] = gndr.titleForSegmentAtIndex(gndr.selectedSegmentIndex); }
                }
                if let zip = zipcodeText.text {
                    if (!zip.isEmpty) { signupData["zip"] = zip; }
                }
            }
            if (!sessionM.signUpUserWithData(signupData)) {
                signupUI();
            }
        }
    }
    @IBAction func logout(sender: UIButton) {
        logoutButton.enabled = false;
        sessionM.logOutUser();
    }

    func sessionM(sessionM: SessionM, didFailWithError error: NSError) {

        let ac = UIAlertController(title: "Failure", message: error.localizedDescription, preferredStyle: .Alert);
        self.presentViewController(ac, animated: true) {
            self.signupUI();
        };
    }

    func sessionM(sessionM: SessionM, didUpdateUserRegistrationResult result: SMUserRegistrationResultType, errors: [String : NSObject]?) {
        var msg : [String] = [];
        if let errs = errors {
            for (key, valArray) in errs {
                msg.append("\(key) => \(valArray)");
            }
            UIAlertView(title: "Error(s) from Server", message: msg.joinWithSeparator("\n"), delegate: nil, cancelButtonTitle: "OK").show();
        }
        self.signupUI();
    }

    func sessionM(sessionM: SessionM, didUpdateUser user: SMUser) {
        signupUI();
    }

    @IBAction func optInOut(sender: UIButton) {
        sessionM.user.isOptedOut = !sessionM.user.isOptedOut;
    }

}
