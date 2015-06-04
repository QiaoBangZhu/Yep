//
//  ChatRightBaseCell.swift
//  Yep
//
//  Created by NIX on 15/6/4.
//  Copyright (c) 2015年 Catch Inc. All rights reserved.
//

import UIKit

class ChatRightBaseCell: UICollectionViewCell {
    
    @IBOutlet weak var dotImageView: UIImageView!
    @IBOutlet weak var gapBetweenDotImageViewAndBubbleConstraint: NSLayoutConstraint!
    
    var messageSendState: MessageSendState = .NotSend {
        didSet {
            switch messageSendState {

            case MessageSendState.NotSend:
                dotImageView.image = UIImage(named: "icon_dot_sending")
                dotImageView.hidden = false

                showSendingAnimation()

            case MessageSendState.Successed:
                dotImageView.image = UIImage(named: "icon_dot_unread")
                dotImageView.hidden = false

                removeSendingAnimation()

            case MessageSendState.Read:
                dotImageView.hidden = true

                removeSendingAnimation()

            case MessageSendState.Failed:
                dotImageView.hidden = true

                removeSendingAnimation()

            default:
                dotImageView.hidden = true

                removeSendingAnimation()
            }
        }
    }

    var message: Message? {
        didSet {
            tryUpdateMessageState()
        }
    }

    let sendingAnimationName = "RotationOnStateAnimation"

    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "tryUpdateMessageState", name: MessageNotification.MessageStateChanged, object: nil)

        gapBetweenDotImageViewAndBubbleConstraint.constant = YepConfig.ChatCell.gapBetweenDotImageViewAndBubble
    }

    func tryUpdateMessageState() {
        if let message = message, messageSendState = MessageSendState(rawValue: message.sendState) {
            self.messageSendState = messageSendState
        }
    }

    func showSendingAnimation() {
        let animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.fromValue = 0.0
        animation.toValue = 2 * M_PI
        animation.duration = 3.0
        animation.repeatCount = MAXFLOAT

        dotImageView.layer.addAnimation(animation, forKey: sendingAnimationName)
    }

    func removeSendingAnimation() {
        dotImageView.layer.removeAnimationForKey(sendingAnimationName)
    }
}