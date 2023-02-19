//
//  ReverseTableViewController.swift
//  Example
//
//  Created by neutronstarer on 2021/11/2.
//

import UIKit
import RxCocoa
import RxSwift

class ReverseTableViewController: UITableViewController {
    
    let disposeBag = DisposeBag()
    
    private var models = [String]()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
//        tableView.translatesAutoresizingMaskIntoConstraints = true
//        tableView.frame = CGRectMake(0, 200, tableView.bounds.width, 500)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 50
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "TableViewCell")
        tableView.contentInset = UIEdgeInsets(top: 100, left: 0, bottom: 100, right: 0)
        tableView.rf.top = {
            let v = VerticalRefreshView()
            v.automatic = true
            v.trigger = {[weak self] view in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {[weak self] in
                    guard let self = self, let scrollView = view.superview as? UITableView else {
                        return
                    }
                    var indexPaths = [IndexPath]()
                    for i in 0..<20 {
                        indexPaths.append(IndexPath(row: i, section: 0))
                        self.models.insert(NSString.random() as String, at: 0)
                    }
                    let ip = scrollView.indexPathsForVisibleRows?.first
                    var offset: CGFloat = 0
                    if let ip = ip, let cell = scrollView.cellForRow(at: ip) {
                        if #available(iOS 11.0, *) {
                            offset = scrollView.contentOffset.y + scrollView.adjustedContentInset.top - cell.frame.origin.y
                        } else {
                            offset = scrollView.contentOffset.y + scrollView.contentInset.top - cell.frame.origin.y
                        }
                    }
                    scrollView.reloadData()
                    scrollView.layoutIfNeeded()
                    if let ip = ip {
                        scrollView.scrollToRow(at: IndexPath(row: 20+ip.row, section: 0), at: .top, animated: false)
                    }else{
                        scrollView.scrollToRow(at: IndexPath(row: 19, section: 0), at: .top, animated: false)
                    }
                    scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y + offset)
                    view.end()
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
        self.tableView.rf.top?.begin()
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
