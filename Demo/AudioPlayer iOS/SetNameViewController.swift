//
//  SetNameViewController.swift
//  jufangzhushou
//
//  Created by 刘兆娜 on 16/6/7.
//  Copyright © 2016年 tbaranes. All rights reserved.
//

import UIKit

class SetNameViewController: BaseUIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var loginUserStore = LoginUserStore()

    @IBOutlet weak var tableView: UITableView!
     @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var loading = LoadingOverlay()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.enabled = false
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("textFieldCell") as! TextFieldCell
        cell.textField.text = loginUserStore.getLoginUser()?.name
        cell.textField.addTarget(self, action: #selector(textFieldDidChange), forControlEvents: UIControlEvents.EditingChanged)
        return cell
    }
    
    func textFieldDidChange(textField: UITextField) {
        if loginUserStore.getLoginUser()?.name != textField.text && textField.text?.length != 0 {
            saveButton.enabled = true
        } else {
            saveButton.enabled = false
        }
    }
    
    
    @IBAction func savePressed(sender: AnyObject) {
        
        loading.showOverlay(view)
        let request = SetNameRequest()
        request.newName = (tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! TextFieldCell).textField.text!
        BasicService().sendRequest(ServiceConfiguration.SET_NAME, request: request) {
            (resp : SetNameResponse) -> Void in
            self.loading.hideOverlayView()
            if resp.status != 0 {
                self.displayMessage(resp.errorMessage!)
                return
            }
            
            let loginUser = self.loginUserStore.getLoginUser()!
            loginUser.name = request.newName
            if self.loginUserStore.updateLoginUser() {
                (self.navigationController?.viewControllers[1] as! PersonalInfoViewController).tableView.reloadData()
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                self.displayMessage("保存失败")
                return
            }
            
        }
        
    }
    
}
