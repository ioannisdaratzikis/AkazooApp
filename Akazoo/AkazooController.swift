//
//  AkazooController.swift
//  Akazoo
//
//  Created by John Daratzikis on 16/05/2017.
//  Copyright © 2017 ioannisdaratzikis. All rights reserved.
//

import Foundation
import Alamofire
import CoreData

class AkazooController{
    
    static let sharedInstance = AkazooController()
    
    var managedObjectContext: NSManagedObjectContext!
    
    func fetchPlaylists(completed: @escaping (Bool)->()){
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Playlist")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            try managedObjectContext.execute(request)
            try managedObjectContext.save()
        } catch {
            print (error.localizedDescription)
        }
        
        
        Alamofire.request("https://akazoo.com/services/Test/TestMobileService.svc/playlists").validate(statusCode: 200..<300).responseJSON { (response) in
            
            let result = response.result
            
            switch result{
                case .success( let value):
                    
                    if let dict = value as? [String: AnyObject]{
                        
                        if let isError = dict["IsError"] as? Bool{
                            if isError{
                                completed(false)
                            }
                        }
                        
                        if let playlists = dict["Result"] as? [[String: AnyObject]]{
                            
                            for playlist in playlists{
                                
                                let playlistItem = Playlist(context: self.managedObjectContext)
                                
                                if let name = playlist["Name"] as? String {
                                    
                                    playlistItem.name = name
                                }
                                
                                if let tracks = playlist["ItemCount"] as? Int{
                                    playlistItem.trackCount = Int64(tracks)
                                }
                                
                                if let id = playlist["PlaylistId"] as? String{
                                    playlistItem.playlistId = id
                                }
                                
                                if let photo = playlist["PhotoUrl"] as? String{
                                    playlistItem.photoUrl = photo
                                }
                                
                                do {
                                    try self.managedObjectContext.save()
                                }catch{
                                    print(error.localizedDescription)
                                }
                                
                            }
                            
                        }
                        
                    }
                    completed(true)
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    completed(false)
                    break
            }
            
        }
        
    }
    
    func fetchTracks(id:String,completed: @escaping (Bool)->()){
        
        managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Track")
        let request = NSBatchDeleteRequest(fetchRequest: fetch)
        
        do {
            try managedObjectContext.execute(request)
            try managedObjectContext.save()
        } catch {
            print (error.localizedDescription)
        }

        Alamofire.request("https://akazoo.com/services/Test/TestMobileService.svc/playlist?playlistid=" + id).validate(statusCode: 200..<300).responseJSON { (response) in
            
            let result = response.result
            
            switch result{
            case .success( let value):
                
                if let dict = value as? [String: AnyObject]{
                    
                    if let isError = dict["IsError"] as? Bool{
                        if isError{
                            completed(false)
                        }
                    }
                    
                    if let playlist = dict["Result"] as? [String: AnyObject]{
                        
                        if let tracks = playlist["Items"] as? [[String: AnyObject]]{
                            
                            for track in tracks{
                                
                                let trackItem = Track(context: self.managedObjectContext)
                                
                                if let name = track["TrackName"] as? String {
                                    
                                    trackItem.name = name
                                }
                                
                                if let artist = track["ArtistName"] as? String{
                                    trackItem.artist = artist
                                }
                                
                                if let id = track["TrackId"] as? Int{
                                    trackItem.id = Int64(id)
                                }
                                
                                if let photo = track["ImageUrl"] as? String{
                                    trackItem.photoUrl = photo
                                }
                                
                                do {
                                    try self.managedObjectContext.save()
                                }catch{
                                    print(error.localizedDescription)
                                }
                            }
                            
                        }
                        
                    }
                    
                }
                completed(true)
                break
            case .failure(let error):
                print(error.localizedDescription)
                completed(false)
                break
            }
            
        }
        
    }


}
