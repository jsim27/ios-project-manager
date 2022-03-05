//
//  ProjectManager - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    let disposeBag = DisposeBag()
    let tableView = UITableView()
    let viewModel = ViewModel()
    let button = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure()
    }

    func configure() {
        self.view.addSubview(tableView)
        self.view.addSubview(button)
        self.tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.button.translatesAutoresizingMaskIntoConstraints = false
        self.button.setTitle("button", for: .normal)
        self.button.setTitleColor(.blue, for: .normal)
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1 / 3),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            self.button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])



        configureRx()
    }

    func configureRx() {
        viewModel.scheduleObservable
            .bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: TableViewCell.self)) {
                index, item, cell in
                cell.label.text = item.title
            }
            .disposed(by: disposeBag)

        button.rx.tap.bind { [weak self] in
            self?.viewModel.example()
        }.disposed(by: disposeBag)

    }

    func tapButton() {
        print("dddd")
    }
}
