//
//  ViewController.swift
//  PictureManager
//
//  Created by David Seek on 11/29/16.
//  Copyright © 2016 David Seek. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var avatarHighIV: UIImageView!
    @IBOutlet weak var coverHighIV: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        CameraHandler.shared.setNotificationUIVC(self, #selector(setAvatars), name: CameraHandler.setAvatars)
        CameraHandler.shared.setNotificationUIVC(self, #selector(setCovers), name: CameraHandler.setCovers)
    }

    @IBAction func newAvatarBtn(_ sender: Any) {
        CameraHandler.shared.presentFusumaCamera(self, true)
    }

    @IBAction func newCoverBtn(_ sender: Any) {
        CameraHandler.shared.presentFusumaCamera(self, false)
    }

    func setAvatars(_ notification: Notification) {
        CameraHandler.shared.displayImages(notification, avatarHighIV)
    }
    
    func setCovers(_ notification: Notification) {
        CameraHandler.shared.displayImages(notification, coverHighIV)
    }
}

