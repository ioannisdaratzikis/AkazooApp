//
//  AkazooViewController.swift
//  Akazoo
//
//  Created by John Daratzikis on 16/05/2017.
//  Copyright © 2017 ioannisdaratzikis. All rights reserved.
//

import UIKit

class AkazooViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showErrorAlert(){
        let alert = UIAlertController(title: "Error", message: "Oooops, something went wrong!", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
