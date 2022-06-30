//
//  HomeView.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import UIKit
import Combine

final class HomeView: BaseView {
    // MARK: - Subviews
    private let tableView = UITableView()
    
    // MARK: - Private Properties
    private var characters: [CharacterModel] = []
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Internal Properties
extension HomeView {
    func show(characters: [CharacterModel]) {
        self.characters = characters
        self.tableView.reloadData()
    }
    
    func reloadData() {
        tableView.reloadData()
    }
}

// MARK: - Private Methods
private extension HomeView {
    func commonInit() {
        setupLayout()
        setupUI()
    }
    
    func setupLayout() {
        addSubview(tableView, withEdgeInsets: .zero, safeArea: true)
    }
    
    func setupUI() {
        backgroundColor = .white
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .white
        tableView.register(
            CharacterTVC.self,
            forCellReuseIdentifier: Constant.cellReuseIdentifier
        )
    }
}

// MARK: - UITableViewDataSource
extension HomeView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: Constant.cellReuseIdentifier,
            for: indexPath
        ) as! CharacterTVC
        
        let model = characters[indexPath.row]
        cell.setup(model)
        
        return cell
    }
}

// MARK: - Static Properties
private enum Constant {
    static let cellReuseIdentifier: String = "UITableViewCell"
}

// MARK: - PreviewProvider
import SwiftUI
struct HomeViewPreview: PreviewProvider {
    static var previews: some View {
        ViewRepresentable(HomeView()) {
            $0.show(
                characters: [
                    CharacterModel(
                        gender: "Male",
                        name: "Rick Sanchez",
                        image: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")!,
                        species: "Human",
                        status: "Alive"
                    ),
                    CharacterModel(
                        gender: "Male",
                        name: "Rick Sanchez 2",
                        image: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")!,
                        species: "Human 2",
                        status: "Alive 2"
                    ),
                ]
            )
        }
    }
}
