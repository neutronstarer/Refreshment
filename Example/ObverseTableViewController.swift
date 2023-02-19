//
//  ObverseTableViewController.swift
//  Example
//
//  Created by neutronstarer on 2021/11/2.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

class ObverseTableViewController: UITableViewController {
    
    let disposeBag = DisposeBag()
    
    private var models = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 50
        tableView.contentInset = UIEdgeInsets(top: 40, left: 0, bottom: 40, right: 0)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.rf.top = {
            let v = VerticalRefreshView()
            v.adjustable = true
            v.trigger = {[weak self] view in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {[weak self] in
                    guard let self = self else {
                        return
                    }
                    self.models.removeAll()
                    for _ in 0..<20 {
                        self.models.append(NSString.random() as String)
                    }
                    self.tableView.reloadData()
                    view.end()
                    (self.tableView.rf.bottom as? VerticalLoadmoreView)?.end(true)
                }
            }
            self.navigationController?.navigationBar.rx.observe(Bool.self, "hidden").subscribe(onNext: { hidden in
                if (v.navigationBarHidden == hidden) {
                    return
                }
                v.navigationBarHidden = hidden == true
            }).disposed(by: disposeBag)
            v.rx.observeWeakly(Bool.self, "navigationBarHidden").subscribe(onNext:{[weak self] hidden in
                guard let self = self else {
                    return
                }
                self.navigationController?.setNavigationBarHidden(hidden == true, animated: true)
            }).disposed(by: disposeBag)
            return v
        }()
        
        tableView.rf.bottom = {
            let v = VerticalLoadmoreView()
            v.adjustable = true
            v.trigger = { view in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {[weak self] in
                    guard let self = self, let view = view as? VerticalLoadmoreView else {
                        return
                    }
                    var indexPaths = [IndexPath]()
                    for _ in 0..<20 {
                        indexPaths.append(IndexPath(row: self.models.count, section: 0))
                        self.models.append(NSString.random() as String)
                    }
                    self.tableView.insertRows(at: indexPaths, with: .bottom)
                    view.end(true)
                }
            }
            return v
        }()
        
        tableView.rf.top?.begin()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return models.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.label.text = models[indexPath.row]
        // Configure the cell...
        
        return cell
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
