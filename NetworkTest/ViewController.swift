//
//  ViewController.swift
//  NetworkTest
//
//  Created by Максим Хмелев on 26.05.2022.
//

import UIKit
import Network

class ViewController: UIViewController {
    
    @IBOutlet weak var jsonTableView: UITableView!
    
    var jsonData = [[String: Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retriveData()
        setDelegates()
    }
    
    private func setDelegates() {
        jsonTableView.dataSource = self
        jsonTableView.delegate = self
    }
    
    func retriveData() {
        let urlPath: String = "http://jsonplaceholder.typicode.com/posts"
        var request = URLRequest(url: URL(string: urlPath)!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("Запрос неудался")
                return
            }
            do {
                if let jsonResult = try JSONSerialization.jsonObject(with: data, options: []) as? NSArray {
                    //                    print("Ответ вернулся")
                    for item in jsonResult {
                        if let itemDict = item as? NSDictionary {
                            let id  = itemDict["id"] as? Int ?? 0
                            let title  = itemDict["title"] as? String ?? ""
                            let userId  = itemDict["userId"] as? Int ?? 0
                            let body  = itemDict["body"] as? String ?? ""
                            
                            self.jsonData.append(itemDict as? [String : Any] ?? ["": ""])
//                                                        print("Мы распарсили данные элемента массива:\n\n id = \(id)\n title = \(title)\n userId = \(userId)\n title = \(body)\n\n------------\n")
                        }
                    }
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
            DispatchQueue.main.async {
                self.jsonTableView.reloadData()
            }
        }
        task.resume()
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        jsonData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "jsonCell") as? JsonTableViewCell {
            
            let dict = jsonData[indexPath.row]
            cell.numberLabel.text = "\(indexPath.row + 1)"
            cell.idLabel.text = "ID: \(dict["id"] ?? "")"
            cell.titleLabel.text = "Title: \(dict["title"] ?? "")"
            cell.bodyLabel.text = "\(dict["body"] ?? "")"
            return cell
        }
        return UITableViewCell()
    }
}


