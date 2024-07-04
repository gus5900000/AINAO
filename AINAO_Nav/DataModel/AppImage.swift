//
//  AppImage.swift
//  AINAO_Nav
//
//  Created by FrancoisW on 01/07/2024.
//


import SwiftUI
import SwiftData
import UIKit

// The aim of this file is to maintain Images in two formats (Image and UIImage) in order to peform easy oiperations
// - interation with PhotoPicker
// - Exchange with the database
// This extension converts an Image friom a Base64 enconding
extension Image {
    static func fromBase64(_ base64String: String) -> Image? {
        guard let data = Data(base64Encoded: base64String),
              let uiImage = UIImage(data: data) else {
            return nil
        }
        return Image(uiImage: uiImage)
    }
}


struct AppImage {
    var image: Image = Image("clint")
    var uiImage: UIImage? = UIImage(named: "clint")
    
    // Default initializer
    init(image: Image = Image("clint"), uiImage: UIImage? = UIImage(named: "clint")) {
        self.image = image
        self.uiImage = uiImage
    }
    
    // initializer taking data from file on disk of from database
    // This func doesn't work
    init?(key: String?) {
        return nil
        
        if let key = key {
            
            // Initialize properties individually
            let loadedImage = loadImageFromUserDefaults(key : key)
            
            // TODO To be continued
        } else {
            return nil
            print("ProfileImage Found in User data...")

        }
    }

    
    // Update function to handle UIImage from photo picker
    // This function works and is in use
    mutating func updateFromPhotoPicker(data: Data?) {
        if let data = data {
            if let uiImage = UIImage(data: data) {
                self.image = Image(uiImage: uiImage)
                self.uiImage = uiImage
            }
        }
    }
    
    
    func saveToUserDefaults(key: String) {
        guard let uiImage = uiImage else { return }
        saveImageToUserDefaults(uiImage: uiImage, key: key)
    }

    func loadImageFromUserDefaults(key: String) -> (image: Image?, uiImage: UIImage?) {
        guard let base64String = UserDefaults.standard.string(forKey: key) else {
            return (nil, nil)
        }
        
        guard let data = Data(base64Encoded: base64String),
              let uiImage = UIImage(data: data) else {
            return (nil, nil)
        }
        
        let image = Image.fromBase64(base64String)
        return (image, uiImage)
    }
}


func saveImageProfile(appImage: AppImage) {
    if let uiImage = appImage.uiImage {
        saveImageToUserDefaults(uiImage: uiImage, key: Consts.Storage.userProfileImageKey)
        print("Profile image saved !")

    } else {
        // Handle the case where uiImage is nil (optional chaining)
        print("No profile image (uiImage is nil) to save.")
    }
}


func saveImageToUserDefaults(uiImage: UIImage, key: String) {
    guard let imageData = uiImage.pngData() else { return }
    let base64String = imageData.base64EncodedString()
    UserDefaults.standard.set(base64String, forKey: key)
}
 
/*
func loadImageFromUserDefaults(key: String) -> UIImage? {
    guard let base64String = UserDefaults.standard.string(forKey: key) else { return nil }
    guard let data = Data(base64Encoded: base64String) else { return nil }
    return UIImage(data: data)
}

*/

