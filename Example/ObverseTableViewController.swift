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
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        tableView.translatesAutoresizingMaskIntoConstraints = true
//        tableView.frame = CGRectMake(0, 200, tableView.bounds.width, 500)
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 1000
//        tableView.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 100, right: 0)
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.rf.top = {
            let v = VerticalRefreshView()
            v.adjustable = true
            v.automatic = true
            v.isHidden = true
            v.trigger = {[weak self] view in
                loadPre {[weak self] data, more in
                    guard let self = self else {
                        return
                    }
                    view.end()
                    let distanceFromOffset = self.tableView.contentSize.height - self.tableView.contentOffset.y
                    self.models.insert(contentsOf: data, at: 0)
                    self.tableView.reloadData() // reload tableView
                    let offset = self.tableView.contentSize.height - distanceFromOffset
                    self.tableView.layoutIfNeeded()
                    self.tableView.setContentOffset(CGPoint(x: 0, y: offset), animated: false)
            
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
            v.automatic = true
            v.isHidden = true
            v.trigger = { view in
                loadPre {[weak self] data, more in
                    guard let self = self else {
                        return
                    }
                    view.isHidden = more == false
                    self.models.append(contentsOf: data)
                    self.tableView.reloadData()
                    view.end()
                }
            }
            return v
        }()
        loadPre {[weak self] data, more in
            guard let self = self else{
                return
            }
            self.models.append(contentsOf: data)
            self.tableView.reloadData()
            self.tableView.rf.top?.isHidden = false
            self.tableView.rf.bottom?.isHidden = false
        }
//        tableView.rf.top?.begin()
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
