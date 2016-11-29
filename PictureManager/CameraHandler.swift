//  Created by David Seek on 11/29/16.
//  Copyright © 2016 David Seek. All rights reserved.


import Foundation
import UIKit

var globalIsAvatar = true

class CameraHandler: NSObject, FusumaDelegate {
    
    static let shared = CameraHandler()
    static let setAvatars = NSNotification.Name(rawValue: "setAvatars")
    static let setCovers = NSNotification.Name(rawValue: "setCovers")
    
    var passedVC: UIViewController?
    
    func presentFusumaCamera(_ onVC: UIViewController, _ isAvatar: Bool) {
        globalIsAvatar = isAvatar
        passedVC = onVC
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusuma.hasVideo = false
        onVC.present(fusuma, animated: true, completion: nil)
    }
    
    func fusumaImageSelected(_ image: UIImage) {
        
        let thumb = image.resizeWith(percentage: 0.1)
        let notificationObject = ["fullscale": image,
                                  "thumb": thumb]
        
        // here you can add your backend upload funcationality for the image and the thumbnail
        ///////// 
        if globalIsAvatar {
            callNotification(CameraHandler.setAvatars, notificationObject)
        } else {
            callNotification(CameraHandler.setCovers, notificationObject)
        }
    }
    
    func getXIB() -> String {
        if globalIsAvatar {
            return "FSAlbumView"
        } else {
            return "FSAlbumViewCover"
        }
    }
    
    func setNotificationUIVC(_ wo: UIViewController, _ selector: Selector, name: Notification.Name) {
        NotificationCenter.default.addObserver(wo, selector: selector, name: name, object: nil)
    }
    
    func callNotification(_ name: Notification.Name, _ object: Any) {
        NotificationCenter.default.post(name: name, object: object)
    }
    
    func displayImages(_ notification: Notification, _ iv: UIImageView) {
        if let images = notification.object as? [String: Any] {
            if let thumb = images["thumb"] as? UIImage {
                iv.image = thumb
                if let fullscale = images["fullscale"] as? UIImage {
                    
                    // add delay to simulate download delay
                    /////////
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3), execute: {
                        iv.image = fullscale
                    })
                }
            }
        }
    }
    
    func fusumaCameraRollUnauthorized() {
        let alert = UIAlertController(title: "Access Requested", message: "Saving image needs to access your photo album", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { action in
            
            if let url = URL(string:UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: {_ in})
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in }))
        
        passedVC?.present(alert, animated: true, completion: nil)
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        //
    }
}

extension UIImage {
    func resizeWith(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}
