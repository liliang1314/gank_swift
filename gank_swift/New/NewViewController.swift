//
//  NewViewController.swift
//  gank_swift
//
//  Created by keith on 2019/2/21.
//  Copyright © 2019 keith. All rights reserved.
//

import UIKit
import Alamofire

class NewViewController: UIViewController {
    
    var category:Array<String> = []
    var results:Dictionary<String, AnyObject> = [:]
    var news = Array<Any>()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "每日干货"
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: "NewTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "NewTableViewCell")
        loadNewData()
        // Do any additional setup after loading the view.
    }

    func loadNewData() {
        let url = "https://gank.io/api/today"
        
        Alamofire.request(url).responseJSON { response in
            if let JSON = response.result.value {
                if let dict = JSON as? [String: AnyObject] {
                    self.category = dict["category"] as! Array
                    self.results = dict["results"] as! Dictionary<String, AnyObject>
                }
            }
            self.tableView.reloadData()
        }
    }

}

extension NewViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.category.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = self.category[section]
        return title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let title = self.category[section]
        let news: Array<AnyObject> = self.results[title] as! Array
        return news.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "NewTableViewCell") as! NewTableViewCell
        if(cell == nil) {
            let nib = Bundle.main.loadNibNamed("NewTableViewCell", owner: nil, options: nil)
            cell = nib?[0] as! NewTableViewCell
        }
        let key = self.category[indexPath.section]
        let news: Array<AnyObject> = self.results[key] as! Array
        let dict:Dictionary = news[indexPath.row] as! [String: Any]
        if let title = dict["desc"] as? String {
            cell.titleLabel.text = title
        }
        if let who = dict["who"] as? String {
            cell.autherLabel.text = who
        }
        if let date = dict["publishedAt"] as? String {
            cell.dateLabel.text = date
        }
        if dict.keys.contains("images") {
            if let images:Array<String> = dict["images"] as? [String] {
                if let urlString = images.first {
                    DispatchQueue.global().async {
                        let url: NSURL = NSURL(string: urlString)!
                        let data = NSData(contentsOf: url as URL)!
                        DispatchQueue.main.async {
                            cell.imgView.image = UIImage(data: data as Data, scale: 1.0)
                        }
                    }
                }
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let key = self.category[indexPath.section]
        let news: Array<AnyObject> = self.results[key] as! Array
        let dict:Dictionary = news[indexPath.row] as! [String: Any]
        if let url = dict["url"] as? String {
            let webVC: WebViewController = WebViewController()
            webVC.url = url
            self.navigationController?.pushViewController(webVC, animated: true)
        }
        
    }
}
