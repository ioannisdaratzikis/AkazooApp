//
//  TracksViewController.swift
//  Akazoo
//
//  Created by John Daratzikis on 16/05/2017.
//  Copyright © 2017 ioannisdaratzikis. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage

class TracksViewController: AkazooViewController, UITableViewDelegate, UITableViewDataSource{

    var managedObjectContext:NSManagedObjectContext!
    var tracks = [Track]()
    var id = ""
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        tableView.delegate = self
        tableView.dataSource = self
        
        loadData()

    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadData(){
        
        AkazooController.sharedInstance.fetchTracks(id: self.id) { (response) in
            if(response){
            
                let trackRequest:NSFetchRequest<Track> = Track.fetchRequest()
                
                do{
                    self.tracks = try self.managedObjectContext.fetch(trackRequest)
                    self.tableView.reloadData()
                }catch{
                    self.showErrorAlert()
                    print(error.localizedDescription)
                }
                
            }else{
                self.showErrorAlert()
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "trackCell")
        
        let trackItem = tracks[indexPath.row]
        
        cell.textLabel?.text = "Name: " + trackItem.name!
        cell.detailTextLabel?.text = "Artist: " + trackItem.artist!
        let imageUrl = URL(string: trackItem.photoUrl!)
        let placeholderImage = UIImage(named: "akazoo.png")
        cell.imageView?.sd_setImage(with: imageUrl, placeholderImage:placeholderImage)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    
}
