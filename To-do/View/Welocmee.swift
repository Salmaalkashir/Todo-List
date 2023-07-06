//
//  WelcomeViewController.swift
//  To-do
//
//  Created by Salma on 15/04/2023.
//

import UIKit
import FirebaseAuth

class WelcomeViewController: UIViewController, UITextFieldDelegate {
    
    let userdefault = UserDefaults.standard
    
    @IBOutlet weak var usernamee: UITextField!
    {
        didSet
        {
            usernamee.setLeftView(image: UIImage(systemName: "at")!)
            usernamee.tintColor = UIColor(named: "gr")
            usernamee.delegate = self
        }
    }
    
    @IBOutlet weak var password: UITextField!
    {
        didSet
        {
            password.setLeftView(image: UIImage(systemName: "lock")!)
            password.tintColor = UIColor(named: "gr")
            password.delegate = self
        }
    }
    
    @IBOutlet weak var incorrect: UILabel!
    
    @IBOutlet weak var emptyuser: UILabel!
    
    @IBOutlet weak var emptypass: UILabel!
    
    @IBOutlet weak var pencilimg: UIImageView!
    
    var log = UserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        incorrect.isHidden = true
        emptyuser.isHidden = true
        emptypass.isHidden = true
        
        usernamee.layer.borderWidth = 1.5
        usernamee.layer.borderColor = UIColor(named: "gr")?.cgColor
        usernamee.layer.cornerRadius = 15
        usernamee.borderStyle = .roundedRect
        
        password.layer.borderWidth = 1.5
        password.layer.borderColor = UIColor(named: "gr")?.cgColor
        password.layer.cornerRadius = 15
        password.borderStyle = .roundedRect
        
        pencilimg.image = UIImage(named: "pencil")
        
        if log.bool(forKey: "islogged")
        {
            performSegue(withIdentifier: "goto", sender: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        usernamee.text = ""
        password.text = "" 
    }
    
    @IBAction func unwindSegue(_ sender : UIStoryboardSegue)
    {
        print("unwinded")
    }
    
    @IBAction func login(_ sender: Any) {
        log.setValue(true, forKey: "islogged")
        if usernamee.text == ""{
            emptyuser.isHidden = false
        }
        else{
            emptyuser.isHidden = true
        }
        if password.text == ""{
            emptypass.isHidden = false
        }
        else{
            emptypass.isHidden = true
        }
        guard let email = usernamee.text, !email.isEmpty,
              let passwordd = password.text, !passwordd.isEmpty
        else{
            if usernamee.text == "" && password.text == ""
            {
                emptyuser.isHidden = false
                emptypass.isHidden = false
            }
            else if usernamee.text == ""
            {
                emptyuser.isHidden = false
            }
            else if password.text == ""
            {
                emptypass.isHidden = false
            }
            else
            {
                emptypass.text = ""
                emptyuser.text = ""
            }
            return
        }
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: passwordd) { result, error in
            guard error == nil else
            {
                self.incorrect.isHidden = false
                if email == ""
                {
                    self.emptyuser.isHidden = false
                }
                if passwordd == ""
                {
                    self.emptypass.isHidden = false
                }
                else{
                    print(error)
                    return
                }
                return
            }
            self.incorrect.isHidden = true
            self.emptypass.isHidden = true
            self.emptyuser.isHidden = true
            self.userdefault.setValue(self.usernamee.text, forKey: "useremail")
            
            self.performSegue(withIdentifier: "goto", sender: nil)

        }
        
    }
    
    
    @IBAction func signupp(_ sender: Any) {
        self.performSegue(withIdentifier: "registerr", sender: nil)
    }
    
}
extension UITextField
{
    func setLeftView(image : UIImage)
    {
        let icon = UIImageView(frame: CGRect(x: 10, y: 10, width: 25, height: 25))
        icon.image = image
        let iconContainerView : UIView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 45))
        iconContainerView.addSubview(icon)
        leftView = iconContainerView
        leftViewMode = .always
        self.tintColor = UIColor(named: "gr")
        
    }
}
