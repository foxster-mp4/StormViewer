//
//  ViewController.swift
//  StormViewer
//
//  Created by Huy Bui on 2021-08-30.
//

import UIKit

class ViewController: UITableViewController {
    var pictures: [Picture] = []
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "StormViewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        DispatchQueue.global(qos: .background).async {
            if let savedData = self.defaults.object(forKey: "stormviewerdata") as? Data {
                let decoder = JSONDecoder()
                do {
                    self.pictures = try decoder.decode(type(of: self.pictures), from: savedData)
                } catch {
                    print("Unable to load saved data; it might not have existed in the first place.")
                }
            } else { // No data found/set
                // Finding image files
                let fileManager = FileManager.default // FileManager is a data type that allows us to work with the filesystem
                let path = Bundle.main.resourcePath! // path is the resource path of the app's bundle
                let items = try! fileManager.contentsOfDirectory(atPath: path) // Items is an array of all the items in the app's bundle
                
                // Sorting items in alphabetical order
                var sortedItems = items; sortedItems.sort()
                
                for item in sortedItems {
                    if item.hasPrefix("nssl") {
                        // Found image file and storing info in pictures[]
                        self.pictures.append(Picture(fileName: item, viewCount: 0))
                    }
                }
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(recommendApp))
    }
    
    // MARK: Overriding methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    } // This will be triggered when iOS wants to know how many rows are in the table view
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let picture = pictures[indexPath.row],
            cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath) // Creating cell using recycled cell from the table
        cell.textLabel?.text = picture.fileName // Sets cell label using item from the pictures property (array); only runs if textLabel is not nil
        cell.detailTextLabel?.text = "Viewed \(picture.viewCount) time\(picture.viewCount == 1 ? "" : "s")"
        return cell
    }
    
    // Triggered when a table row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Trying to load the view controller with the id "Detail" (from Main.storyboard) then typecast it to type DetailViewController; storyboard (from UIViewController) is either the storyboard the view controller was loaded from or nil
        if let detailViewController = storyboard?.instantiateViewController(identifier: "Detail") as? DetailViewController {
            detailViewController.selectedImage = pictures[indexPath.row].fileName
            detailViewController.selectedImageIndex = indexPath.row
            detailViewController.totalNumberOfImages = pictures.count
            
            pictures[indexPath.row].viewCount += 1
            saveData()
            
            // Pushing the detail view controller onto the navigation controller
            navigationController?.pushViewController(detailViewController, animated: true)
            
            tableView.reloadData()
        }
        
    }
    
    @objc func recommendApp() {
        let alert = UIAlertController(title: "Recommend this app", message: "This feature is not available", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    func saveData() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(pictures) {
            defaults.set(data, forKey: "stormviewerdata")
        }
    }
    
}

