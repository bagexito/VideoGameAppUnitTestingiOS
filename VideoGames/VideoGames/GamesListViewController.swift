//
//  GamesListViewController.swift
//  VideoGames
//
//  Created by Bilal Ahmad on 2/11/20.
//  Copyright © 2020 Bilal Ahmad. All rights reserved.
//

import UIKit

class GamesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var errorMessageView: UIView!
    @IBOutlet weak var tableView: UIView!
    
    @IBOutlet weak var errorMessageLbl: UILabel!
    @IBOutlet weak var gamesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

