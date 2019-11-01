//
//  ViewController.swift
//  TableCellExpansion
//
//  Created by Ahmed Khalaf on 11/1/19.
//  Copyright © 2019 Ahmed Khalaf. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private lazy var data: [Model] = (0..<100).map {
        return Model(text: "Row \($0)", isExpanded: false)
    }
    
    // MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Cell
        cell.dataSource = { [unowned self] in
            return self.data[indexPath.row]
        }
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        data[indexPath.row].isExpanded = !data[indexPath.row].isExpanded
        
        (tableView.cellForRow(at: indexPath) as! Cell).refresh()
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

class Cell: UITableViewCell {
    
    func refresh() {
        model = dataSource?()
    }
    var dataSource: (() -> Model)? {
        didSet {
            refresh()
        }
    }
    private var model: Model? {
        didSet {
            label.text = model?.text
            dropDown.isHidden = !(model?.isExpanded ?? false)
        }
    }
    
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var dropDown: UIStackView!
}


struct Model {
    let text: String
    var isExpanded: Bool
}
