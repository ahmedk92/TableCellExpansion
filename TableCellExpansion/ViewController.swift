//
//  ViewController.swift
//  TableCellExpansion
//
//  Created by Ahmed Khalaf on 11/1/19.
//  Copyright © 2019 Ahmed Khalaf. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {

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
        cell.tapAction = { [unowned self] in
            self.data[indexPath.row].isExpanded = !self.data[indexPath.row].isExpanded
            
            (tableView.cellForRow(at: indexPath) as! Cell).refresh()
            
            tableView.beginUpdates()
            tableView.endUpdates()

        }
        return cell
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
    var tapAction: (() -> Void)?
    private var model: Model? {
        didSet {
            label.text = model?.text
            let isExpanded = !(model?.isExpanded ?? false)
            dropDown.isHidden = isExpanded
            labelContainerStackView.alignment = isExpanded ? .top : .fill
        }
    }
    
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var labelContainerStackView: UIStackView!
    @IBOutlet private weak var dropDown: UIStackView!
    
    @objc private func labelTapped(_ recognizer: UITapGestureRecognizer) {
        tapAction?()
    }
    
    private func addTapGestureRecognizer() {
        label.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(labelTapped(_:)))
        label.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: Overrides
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addTapGestureRecognizer()
    }
}


struct Model {
    let text: String
    var isExpanded: Bool
}
