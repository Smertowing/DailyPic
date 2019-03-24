//
//  AddEntityViewController.swift
//  DailyPicMobile
//
//  Created by Kiryl Holubeu on 3/24/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit
import YPImagePicker

protocol AddEntityDelegate: class {
    func didAdd(entity: EntityModel, from controller: AddEntityViewController)
}

class AddEntityViewController: UIViewController {
    @IBOutlet weak var entityImageView: UIImageView!
    weak var delegate: AddEntityDelegate?
    
    var isChanged: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        entityImageView.image = #imageLiteral(resourceName: "Plus")
        entityImageView.contentMode = .scaleAspectFit
    }
}

extension AddEntityViewController {
    @IBAction func pickImage(_ sender: Any) {
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                self.entityImageView.image = photo.image
                self.isChanged = true
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
}


extension AddEntityViewController {
    @IBAction func saveEntity(_ sender: Any) {
        guard let image = entityImageView.image, isChanged else {
            displayError(with: "Need to choose image")
            return
        }
        guard let jpegData = image.jpegData(compressionQuality: 0.0)  else {
            displayError(with: "Image compression error")
            return
        }
        guard let newEntity = EntityModel(id: nil, picture: jpegData.base64EncodedString(), date: Date()) else {
            displayError(with: "Could not create new entity")
            return
        }
        delegate?.didAdd(entity: newEntity, from: self)
    }
    
    private func displayError(with message: String) {
        let alert = UIAlertController(title: "Error", message: "We could not save this image - please try again! Reason: \(message)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
