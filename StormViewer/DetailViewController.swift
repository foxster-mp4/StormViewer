//
//  DetailViewController.swift
//  StormViewer
//
//  Created by Huy Bui on 2021-09-02.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var selectedImage: String? // Optional since it won't have a value (or exist) when the view controller is first created
    var selectedImageIndex: Int?
    var totalNumberOfImages: Int? // Must be optional since it doesn't have a value at first; an alternative would be to use initializers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        title = selectedImage // No need to unwrap selectedImage because title is also an optional String
        title = "Image \(selectedImageIndex! + 1) of \(totalNumberOfImages!)"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
//        navigationItem.rightBarButtonItems?.insert(UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: nil), at: 1)
        navigationItem.largeTitleDisplayMode = .never
        

        if let imageToLoad = selectedImage { // Unwrapping selectedImage; reads "if imageToLoad is not nil"
            imageView.image = UIImage(named: imageToLoad)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    @objc func shareTapped() { // @objc signifies that the function can be called by underlying Objective-C
        guard let image = imageView.image?.jpegData(compressionQuality: 1) else {
            print("No image found")
            return
        }
        
        let activityViewController = UIActivityViewController(activityItems: [selectedImage!, image], applicationActivities: [])
        activityViewController.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem // Anchors the activity view controller to the right bar button item (the share button); only effective on iPad
        present(activityViewController, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
