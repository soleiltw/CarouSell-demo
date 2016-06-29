//
//  RegistrationWithEmailTableViewController.swift
//  CarouSell-demo
//
//  Created by Brian Hu on 4/12/16.
//  Copyright © 2016 Brian Hu. All rights reserved.
//

import UIKit
import PKHUD

enum RegistrationMode {
    case SignUp
    case SignIn
}

// STEP 5: conform to our protocal "SignInInputTableViewCellDelegate"
class RegistrationWithEmailTableViewController: UITableViewController, SignInInputTableViewCellDelegate {

    private var mode = RegistrationMode.SignUp
    private var signInInputCellIdentifier = "SignInInputCellIdentifier"
    
    var userName: String?
    var password: String?
    var email: String?
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func done(sender: AnyObject) {
        self.view.endEditing(true)
        guard let username = self.userName
            else {
                self.alert("you should input correct username!")
                return
        }
        guard self.isValidatedEmail(self.email)
            else {
                self.alert("you should input correct email")
                return
        }
        guard self.isValidatedPassword(self.password)
            else {
                self.alert("you should input a password whose length is greater than 6")

                return
        }
        
        let params = ["username": username, "password": self.password, "email": self.email]
        
        // send params to server
        HUD.show(.Progress)
        fakeAPICall(params) {
            HUD.hide()
            let storybaord = UIStoryboard(name: "Main", bundle: nil)
            let viewController = storybaord.instantiateViewControllerWithIdentifier("MainNavigationController")
            self.presentViewController(viewController, animated: true, completion: nil)
            NSUserDefaults.standardUserDefaults().setValue(self.email, forKey: "email")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    private func fakeAPICall(params: [String: String?], closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(3 * (NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    private func alert(title: String) {
        let alertController = UIAlertController(title: title, message: nil, preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func isValidatedPassword(password: String?) -> Bool {
        return password?.characters.count > 6
    }
    
    private func isValidatedEmail(email: String?) -> Bool {
        // regular expression
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let range = email?.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
//        let result = range != nil ? true : false
        return range != nil
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.title = "Sign in"
        
        let tableHeaderView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, 50))
        
        tableHeaderView.backgroundColor = UIColor.clearColor()
        
        let segmentedControl = UISegmentedControl(items: ["Sign up", "Sign in"])
        segmentedControl.frame = CGRectMake(0, 10, 180, 29)
        segmentedControl.center.x = self.view.center.x
        segmentedControl.addTarget(self, action: #selector(RegistrationWithEmailTableViewController.segmentedControlSwitched), forControlEvents: .ValueChanged)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = UIColor.lightGrayColor()
        
        tableHeaderView.addSubview(segmentedControl)
        self.tableView.tableHeaderView = tableHeaderView
        
        self.tableView.registerNib(UINib(nibName: "SignInInputTableViewCell", bundle: nil), forCellReuseIdentifier: signInInputCellIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
//        var numOfRows = 5
//        if self.mode == .SignUp {
//            numOfRows = 5
//        } else if self.mode == .SignIn {
//            numOfRows = 2
//        }
//        return numOfRows
    }
    
    func segmentedControlSwitched() {
        if self.mode == .SignUp {
            self.mode = .SignIn
            self.title = "Sign in"
        } else if self.mode == .SignIn {
            self.mode = .SignUp
            self.title = "Sign up"
        }
        self.tableView.reloadData()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

//        if self.mode == .SignUp {
        let cell = tableView.dequeueReusableCellWithIdentifier(signInInputCellIdentifier, forIndexPath: indexPath) as! SignInInputTableViewCell
        switch indexPath.row {
        case 0:
            cell.mode = SignInInputMode.UserName
//            cell.textField.delegate = self
//            cell.textField.tag = 0
            
            // STEP 6: set the delegate property of the cell
            cell.delegate = self
        case 1:
            cell.mode = SignInInputMode.Password
//            cell.textField.delegate = self
//            cell.textField.tag = 1
            cell.delegate = self
        case 2:
            cell.mode = SignInInputMode.Email
//            cell.textField.delegate = self
//            cell.textField.tag = 2
            cell.delegate = self
        default:
            break
        }


            return cell
//        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        switch textField.tag {
        case 0:
            self.userName = textField.text
        case 1:
            self.password = textField.text
        case 2:
            self.email = textField.text
        default:
            break
        }
    }
    
    // STEP 7: implement the protocal func
    func didEditTextField(mode: SignInInputMode, text: String?) {
        switch mode {
        case .UserName:
            self.userName = text
        case .Password:
            self.password = text
        case .Email:
            self.email = text
        }
    }
}
