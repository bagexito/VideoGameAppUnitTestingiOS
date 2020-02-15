//
//  GamesListViewController.swift
//  VideoGames
//
//  Created by Bilal Ahmad on 2/11/20.
//  Copyright © 2020 Bilal Ahmad. All rights reserved.
//

import UIKit

class GamesListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, GamesListViewModelDelegate {
    
    
    var vm = GamesListViewModel(AppDataService())
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var errorMessageView: UIView!
    @IBOutlet weak var tableView: UIView!
    
    @IBOutlet weak var errorMessageLbl: UILabel!
    @IBOutlet weak var gamesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        vm.delegate = self
        vm.loadGames()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.itemsCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item_cell")!
        let item = vm.getItem(at: indexPath.row)!
        
        cell.textLabel?.text = item.title
        
        return cell
    }
    
    func errorDidOccur(vm: GamesListViewModel) {
        
        errorMessageView.isHidden = !vm.showError
        errorMessageLbl.text = vm.errorMessage
        loadingView.isHidden = !vm.showLoading
    }
    
    func didStartLoading(vm: GamesListViewModel) {
        
        errorMessageView.isHidden = !vm.showError
        loadingView.isHidden = !vm.showLoading
    }
    
    func itemsLoaded(vm: GamesListViewModel) {
        
        errorMessageView.isHidden = !vm.showError
        loadingView.isHidden = !vm.showLoading
        gamesTableView.reloadData()
    }
    
    @IBAction func reload() {
        vm.loadGames()
    }
    
}

