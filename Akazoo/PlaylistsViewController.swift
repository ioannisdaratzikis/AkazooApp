//
//  ViewController.swift
//  Akazoo
//
//  Created by John Daratzikis on 16/05/2017.
//  Copyright © 2017 ioannisdaratzikis. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage

class PlaylistsViewController: AkazooViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    var managedObjectContext:NSManagedObjectContext!
    var playlists = [Playlist]()
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

    
    @IBAction func refresh(_ sender: Any) {
        
        playlists.removeAll()
        tableView.reloadData()
        
        AkazooController.sharedInstance.fetchPlaylists { (response) in
            if(response){
                let playlistRequest:NSFetchRequest<Playlist> = Playlist.fetchRequest()
                
                do{
                    self.playlists = try self.managedObjectContext.fetch(playlistRequest)
                    self.tableView.reloadData()
                }catch{
                    self.showErrorAlert()
                    print(error.localizedDescription)
                }
            }else {
                self.showErrorAlert()
            }
        }
    }

    func loadData(){

        let playlistRequest:NSFetchRequest<Playlist> = Playlist.fetchRequest()
        
            do{
                self.playlists = try self.managedObjectContext.fetch(playlistRequest)
                
                if self.playlists.count == 0{
                    refresh((Any).self)
                }
                
                self.tableView.reloadData()
            }catch{
                self.showErrorAlert()
                print(error.localizedDescription)
        }
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.id = playlists[indexPath.row].playlistId!
        performSegue(withIdentifier: "playlistSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "playlistCell")
        
        let playlistItem = playlists[indexPath.row]
        
        cell.textLabel?.text = "Name: " + playlistItem.name!
        cell.detailTextLabel?.text = "Tracks: " + String(playlistItem.trackCount)
        let imageUrl = URL(string: playlistItem.photoUrl!)
        let placeholderImage = UIImage(named: "akazoo.png")
        cell.imageView?.sd_setImage(with: imageUrl, placeholderImage:placeholderImage)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playlistSegue" {
            let destination = segue.destination as! TracksViewController
            destination.id = self.id
        }
    }
    

}

