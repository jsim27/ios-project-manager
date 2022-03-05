//
//  TableViewCell.swift
//  ProjectManager
//
//  Created by 이승재 on 2022/03/05.
//

import UIKit

class TableViewCell: UITableViewCell {

    let label = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(label)
        self.label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            self.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            self.widthAnchor.constraint(equalTo: self.contentView.widthAnchor),
            self.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func awakeFromNib() {
        super.awakeFromNib()

    }

}
