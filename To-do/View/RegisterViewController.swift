//
//  RegisterViewController.swift
//  To-do
//
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var name: UITextField!
    {
        didSet
        {
            name.setLeftView(image: UIImage(systemName: "person")!)
            name.tintColor = UIColor(named: "gr")
            name.delegate = self
        }
    }
    
    @IBOutlet weak var password: UITextField!
    {
        didSet
        {
            password.setLeftView(image: UIImage(systemName: "lock")!)
            password.tintColor = UIColor(named: "gr")
            name.delegate = self
        }
    }
    @IBOutlet weak var nomatches: UILabel!
    @IBOutlet weak var emptyuserr: UILabel!
    @IBOutlet weak var emptypass: UILabel!
    @IBOutlet weak var emptyemail: UILabel!
    @IBOutlet weak var emaail: UITextField!
    {
        didSet
        {
            emaail.setLeftView(image: UIImage(systemName: "at")!)
            emaail.tintColor = UIColor(named: "gr")
            emaail.delegate = self
        }
    }
    
    @IBOutlet weak var passcon: UITextField!
    {
        didSet
        {
            passcon.setLeftView(image: UIImage(systemName: "lock")!)
            passcon.tintColor = UIColor(named: "gr")
            passcon.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        emptypass.isHidden = true
        emptyemail.isHidden = true
        emptyuserr.isHidden = true
        nomatches.isHidden = true
        
        name.layer.cornerRadius = 15
        name.layer.borderWidth = 1.5
        name.layer.borderColor = UIColor(named: "gr")?.cgColor
        name.borderStyle = .roundedRect
        
        password.layer.cornerRadius = 15
        password.layer.borderWidth = 1.5
        password.layer.borderColor = UIColor(named: "gr")?.cgColor
        password.borderStyle = .roundedRect
        
        emaail.layer.cornerRadius = 15
        emaail.layer.borderWidth = 1.5
        emaail.layer.borderColor = UIColor(named: "gr")?.cgColor
        emaail.borderStyle = .roundedRect
        
        
        passcon.layer.cornerRadius = 15
        passcon.layer.borderWidth = 1.5
        passcon.layer.borderColor = UIColor(named: "gr")?.cgColor
        passcon.borderStyle = .roundedRect
    }
    

    
    @IBAction func login(_ sender: Any) {
        self.performSegue(withIdentifier: "signin", sender: nil)
    }
    
    @IBAction func email(_ sender: UITextField) {
        switch(sender.tag)
        {
        case 1:
            if name.text == ""
            {
                emptyuserr.isHidden = false
            }
            else
            {
                emptyuserr.isHidden = true
            }
        case 2:
            if password.text == ""
            {
                emptypass.isHidden = false
            }
            else
            {
                emptypass.isHidden = true
            }
        case 4:
            if sender.text == ""
            {
                emptyemail.isHidden = false
            }
            else
            {
                emptyemail.isHidden = true
            }
            
        default:
            break
        }
            
    }
    
    
    @IBAction func passconfirmation(_ sender: UITextField) {
        if !(password.text == sender.text)
        {
            nomatches.isHidden = false
        }
        else
        {
            nomatches.isHidden = true
        }
    
    }
    
    
    @IBAction func signup(_ sender: Any) {
        if name.text == "" && password.text == "" && emaail.text == ""
        {
            emptyuserr.isHidden = false
            emptypass.isHidden = false
            emptyemail.isHidden = false
        }
        else
        {
            emptyuserr.isHidden = true
            emptypass.isHidden = true
            emptyemail.isHidden = true

        }
        
        guard let emaill = emaail.text, !emaill.isEmpty,
              let passwordd = password.text, !passwordd.isEmpty
        else{
            return
        }
        FirebaseAuth.Auth.auth().signIn(withEmail: emaill, password: passwordd) { result, error in
            guard error == nil else
            {
                self.showCreateAccount(email: emaill, password: passwordd)
                return
            }
        }
    }
    func showCreateAccount(email: String, password: String)
    {
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard error == nil else{
                print("Creation Failed")
                return
            }
            
            let signupobj = self?.storyboard?.instantiateViewController(withIdentifier: "tabbar") as! CustomTabBar
            self?.navigationController?.pushViewController(signupobj, animated: true)
        }
    }

}

