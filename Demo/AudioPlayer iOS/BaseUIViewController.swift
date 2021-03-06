//
//  BaseUIViewController.swift
//  OnlineClass
//
//  Created by 刘兆娜 on 16/4/16.
//  Copyright © 2016年 tbaranes. All rights reserved.
//

import UIKit
import KDEAudioPlayer
import QorumLogs

class BaseUIViewController: UIViewController, AudioPlayerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAudioPlayer().delegate = self
        tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        
        if  self.navigationController != nil {

            self.navigationController?.navigationBar.barTintColor =
   UIColor(red: 0xF2/255, green: 0x61/255, blue: 0, alpha: 0.9)
            self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()

            self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
           
        }
        
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
    }
    
    
    
    func isNeedResetAudioPlayerDelegate() -> Bool {
        return true
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        getAudioPlayer().delegate = nil
        
        if isNeedResetAudioPlayerDelegate()
            && self.navigationController?.viewControllers.indexOf(self) == nil {
            if let navigatoinViewController = (self.parentViewController as? UINavigationController) {
                if let delegate = navigatoinViewController.topViewController as? AudioPlayerDelegate {
                    getAudioPlayer().delegate = delegate
                }
            }
        }

    }
    
        
    
    func getAudioPlayer() -> AudioPlayer {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        return appDelegate.audioPlayer
    }
    
    func addPlayingButton(button: UIButton) {
        button.addTarget(self, action: #selector(playingButtonPressed), forControlEvents: .TouchUpInside)
    }
    
    func playingButtonPressed(sender: UIButton) {
        if hasCurrentItem() {
            performSegueWithIdentifier("songSegue", sender: false)
        }
    }
    
    func stringFromTimeInterval(interval: NSTimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        if hours > 0 {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            return String(format: "%02d:%02d", minutes, seconds)
        }
        
    }
    
    private func hasCurrentItem() -> Bool {
        return getAudioPlayer().currentItem != nil
    }
    
    func updatePlayingButton(button: UIButton) {
        let audioPlayer = getAudioPlayer()
        QL1("audioPlayer.state = \(audioPlayer.state)")
        if audioPlayer.state == AudioPlayerState.Playing {
            
            let image = UIImage.animatedImageWithImages([UIImage(named: "wave1")!,
                UIImage(named: "wave2")!,
                UIImage(named: "wave3")!,
                UIImage(named: "wave4")!,
                UIImage(named: "wave5")!], duration: NSTimeInterval(0.8))
            button.setImage(image, forState: .Normal)
        } else {
            button.setImage(UIImage(named: "wave1"), forState: .Normal)
        }
    }

    func audioPlayer(audioPlayer: AudioPlayer, didChangeStateFrom from: AudioPlayerState, toState to: AudioPlayerState) {
        QL1("audioPlayer:didChangeStateFrom called")
    }
    
    func audioPlayer(audioPlayer: AudioPlayer, willStartPlayingItem item: AudioItem) {
        QL1("audioPlayer:willStartPlayingItem called")
    }
    
    func audioPlayer(audioPlayer: AudioPlayer, didUpdateProgressionToTime time: NSTimeInterval, percentageRead: Float) {
        
    }
    
    func audioPlayer(audioPlayer: AudioPlayer, didFindDuration duration: NSTimeInterval, forItem item: AudioItem) {

    }
    
    func audioPlayer(audioPlayer: AudioPlayer, didUpdateEmptyMetadataOnItem item: AudioItem, withData data: Metadata) {
        QL1("audioPlayer:didUpdateEmptyMetadataOnItem called, metaData = \(data)")
    }
    
    func audioPlayer(audioPlayer: AudioPlayer, didLoadRange range: AudioPlayer.TimeRange, forItem item: AudioItem){

    }
    
    func becomeLineBorder(field: UITextField) {
        field.borderStyle = .None
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRectMake(0.0, field.frame.size.height - 1, field.frame.size.width, 1.0);
        bottomBorder.backgroundColor = UIColor.lightGrayColor().CGColor
        field.layer.addSublayer(bottomBorder)
    }
    
    func setTextFieldHeight(field: UITextField, height: CGFloat) {
        var frameRect = field.frame
        frameRect.size.height = height
        field.frame = frameRect
    }

   
    var tap: UITapGestureRecognizer!
}

extension BaseUIViewController {
    func displayMessage(message : String) {
        let alertView = UIAlertView()
        //alertView.title = "系统提示"
        alertView.message = message
        alertView.addButtonWithTitle("好的")
        alertView.cancelButtonIndex=0
        alertView.show()
        
    }
    
    func displayMessage(message : String, delegate: UIAlertViewDelegate) {
        let alertView = UIAlertView()
        //alertView.title = "系统提示"
        alertView.message = message
        alertView.addButtonWithTitle("好的")
        alertView.cancelButtonIndex=0
        alertView.delegate=delegate
        alertView.show()
        
    }
    
    func displayVipBuyMessage(message : String, delegate: UIAlertViewDelegate) {
        let alertView = UIAlertView()
        //alertView.title = "系统提示"
        alertView.message = message
        alertView.addButtonWithTitle("购买")
        alertView.addButtonWithTitle("取消")
        alertView.delegate=delegate
        alertView.show()
    }
    
    func displayVipBuyMessage2(message : String, delegate: UIAlertViewDelegate) {
        let alertView = UIAlertView()
        //alertView.title = "系统提示"
        alertView.message = message
        alertView.addButtonWithTitle("购买")
        alertView.addButtonWithTitle("返回")
        alertView.delegate=delegate
        alertView.show()
    }


    
    func displayConfirmMessage(message : String, delegate: UIAlertViewDelegate) {
        let alertView = UIAlertView()
        //alertView.title = "系统提示"
        alertView.message = message
        alertView.addButtonWithTitle("确认")
        alertView.addButtonWithTitle("取消")
        alertView.delegate=delegate
        alertView.show()
    }

    
    func hideKeyboardWhenTappedAround() {
        view.addGestureRecognizer(tap)
    }
    
    func cancleHideKeybaordWhenTappedAround() {
        view.removeGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }


}
