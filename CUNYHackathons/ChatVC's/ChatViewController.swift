//
//  ChatViewController.swift
//  CUNYHackathons
//
//  Created by Jesse Seidman on 12/12/17.
//  Copyright © 2017 Jesse Seidman. All rights reserved.
//

import UIKit
import JSQMessagesViewController

/*
 * This VC handles all the chat stuff
 */
class ChatViewController: JSQMessagesViewController
{
    //vars
    public var currentChat: GroupData? = nil
    public var messages = [JSQMessage]()
    public lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    public lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
    
        self.inputToolbar.contentView.leftBarButtonItem = nil
        self.getChatData()
        
        self.senderId = "jesse"
        self.senderDisplayName = "jesse"
        
        self.addMessage(withId: "jesse", name: "Juicy", text: "Hello my name is Jesse")
        self.addMessage(withId: "jeremy", name: "jeremy", text: "Hello my name is jeremy")
        self.addMessage(withId: "josh", name: "josh", text: "Hello my name is josh")
        self.addMessage(withId: "judah", name: "judah", text: "Hello my name is judah")
        self.addMessage(withId: "shari", name: "shari", text: "Hello my name is shari")
        self.addMessage(withId: "YO", name: "YO", text: "Hello my name is YO")
    }
    
    public func getChatData()
    {
        //CONNECT TO DB
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!
    {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return messages.count
    }
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage
    {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage
    {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        let message = messages[indexPath.item]
        if message.senderId == senderId
        {
            return outgoingBubbleImageView
        }
        else
        {
            return incomingBubbleImageView
        }
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        return nil
    }
    
    private func addMessage(withId id: String, name: String, text: String)
    {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if message.senderId == senderId
        {
            cell.textView?.textColor = UIColor.white
        }
        else
        {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {
        self.addMessage(withId: senderId, name: senderDisplayName, text: text)
        JSQSystemSoundPlayer.jsq_playMessageSentSound() // 4
        finishSendingMessage() // 5
    }
    
    //actions
    @IBAction func goBack(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
}
