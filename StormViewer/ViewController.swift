//
//  ViewController.swift
//  StormViewer
//
//  Created by Huy Bui on 2021-08-30.
//

import UIKit

class ViewController: UITableViewController {
    var pictures: [String] = []
//    var pictures = [String]() // Another way to declare an empty array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "StormViewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // MARK: Finding image files
        let fileManager = FileManager.default // FileManager is a data type that allows us to work with the filesystem
        let path = Bundle.main.resourcePath! // path is the resource path of the app's bundle
        let items = try! fileManager.contentsOfDirectory(atPath: path) // Items is an array of all the items in the app's bundle
        
        // Sorting items in alphabetical order
        var sortedItems = items; sortedItems.sort()
        
        for item in sortedItems {
            if item.hasPrefix("nssl") {
                // Found image file and storing it in pictures[]
                pictures.append(item)
            }
        }
//        print(pictures) // Prints array items to the debugging console
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(recommendApp))
    }
    
    // MARK: Overriding methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    } // This will be triggered when iOS wants to know how many rows are in the table view
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath) // Creating cell using recycled cell from the table
        cell.textLabel?.text = pictures[indexPath.row] // Sets cell label using items (type String) from the pictures property (array); only runs if textLabel is not nil
//        print(indexPath) // Prints indexPath in the format [section_index, row_index)
        return cell
    }
    
    // Triggered when a table row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Trying to load the view controller with the id "Detail" (from Main.storyboard) then typecast it to type DetailViewController; storyboard (from UIViewController) is either the storyboard the view controller was loaded from or nil
        if let detailViewController = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            detailViewController.selectedImage = pictures[indexPath.row]
            detailViewController.selectedImageIndex = indexPath.row
            detailViewController.totalNumberOfImages = pictures.count
            
            // Pushing the detail view controller onto the navigation controller
            navigationController?.pushViewController(detailViewController, animated: true)
        }
        
    }
    
    @objc func recommendApp() {
        let alert = UIAlertController(title: "Recommend this app", message: "This feature is not available", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
}

