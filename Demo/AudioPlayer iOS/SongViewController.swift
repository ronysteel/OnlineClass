//
//  SongViewController.swift
//  Demo
//
//  Created by 刘兆娜 on 16/4/15.
//  Copyright © 2016年 tbaranes. All rights reserved.
//

import UIKit
import KDEAudioPlayer

class SongViewController: BaseUIViewController,
        UIGestureRecognizerDelegate, CommentDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var bottomView2: UIView!
    @IBOutlet weak var commentFiled2: UITextView!
    
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var bottomView: UIView!

    var keyboardHeight: CGFloat?
    var comments : [Comment]?  {
        didSet{
            commentListDataSource.comments = comments
        }
    }
    
    var overlay = UIView()
    var audioPlayer: AudioPlayer!
    
    @IBOutlet weak var sendButton: UIButton!

    @IBOutlet weak var cancelButton: UIButton!
    var commentListDataSource: CommentListDataSourceAndDelegate!
    var commentController = CommentController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        commentController.bottomView = bottomView
        commentController.commentField = commentField
        commentController.bottomView2 = bottomView2
        commentController.commentFiled2 = commentFiled2
        commentController.cancelButton = cancelButton
        commentController.sendButton = sendButton
        commentController.viewController = self
        commentController.delegate = self
        commentController.initView()

        
        print("viewDidLoad")
        commentListDataSource = CommentListDataSourceAndDelegate()
        commentListDataSource.viewController = self
        commentListDataSource.showHasMoreLink = true
        
        audioPlayer = getAudioPlayer()
        comments = [Comment]()
        
        tableView.dataSource = commentListDataSource
        tableView.delegate = commentListDataSource
        
        self.navigationController?.interactivePopGestureRecognizer!.delegate = self
        
        if audioPlayer.currentItem != nil {
            let item = audioPlayer.currentItem as! MyAudioItem
            print(item.song)
            navigationItem.title = item.song!.name
            print("title = \( item.song!.name)")
        }
        reload()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        commentController.addKeyboardNotify()
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
        commentController.removeKeyboardNotify()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        if appDelegate.liveProgressTimer != nil {
            appDelegate.liveProgressTimer?.invalidate()
            appDelegate.liveProgressTimer = nil
        }
    }
    
    private func reload() {
        
        let song = Song()
        song.id = "1"
        BasicService().sendRequest(ServiceConfiguration.GET_SONG_COMMENTS,
                                   params: ["song": song]) {
            (resp: GetSongCommentsResponse) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                if resp.status != 0 {
                    print(resp.errorMessage)
                    return
                }
                self.comments = resp.resultSet
                self.tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .None)
            }
        }
    }
    
    
    /* UIGestureRecognizerDelegate functions   */
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
    
    @IBAction func nextSongPressed(sender: UIButton) {
        print("nextSongPressed")
        reload()
    }
    
    func afterSendComment(comment: Comment) {
        comments?.insert(comment, atIndex: 0)

        tableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .None)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "commentListSegue" {
            let backItem = UIBarButtonItem()
            backItem.title = ""
            navigationItem.backBarButtonItem = backItem
        }
    }

}


