//
//  CharacterTVC.swift
//  XcodeCloudDemo
//
//  Created by Artem Kvasnetcky on 24.05.2022.
//

import UIKit
import Kingfisher

class CharacterTVC: UITableViewCell {
    private let genderLabel = UILabel()
    private let nameLabel = UILabel()
    private let speciesLabel = UILabel()
    private let statusLabel = UILabel()
    private let characterImage = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func setup(_ model: CharacterModel) {
        characterImage.kf.setImage(with: model.image)
        statusLabel.text = model.status
        nameLabel.text = model.name
        genderLabel.text = "Gender: \(model.gender)"
        speciesLabel.text = "Species: \(model.species)"
    }
    
    func commonInit() {
        backgroundColor = .white
        let labelsStack = UIStackView()
        labelsStack.setup(axis: .vertical, spacing: 5)
        
        statusLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        statusLabel.textColor = .lightGray
        
        nameLabel.font = UIFont.systemFont(ofSize: 21, weight: .bold)
        
        nameLabel.textColor = .black
        
        speciesLabel.font = UIFont.systemFont(ofSize: 16)
        speciesLabel.textColor = .gray
        
        genderLabel.font = UIFont.systemFont(ofSize: 16)
        genderLabel.textColor = .gray
        
        
        labelsStack.addArranged(statusLabel)
        labelsStack.addArranged(nameLabel)
        labelsStack.addArranged(speciesLabel)
        labelsStack.addArranged(genderLabel)
        
        let mainStack = UIStackView()
        mainStack.setup(axis: .horizontal, spacing: 20)
        
        let imageContainer = UIView(
            frame: CGRect(
                origin: .zero,
                size: CGSize(
                    width: 100,
                    height: 100
                )
            )
        )
        
        imageContainer.backgroundColor = .clear
        imageContainer.rounded()
        imageContainer.addSubviewToCenter(
            characterImage,
            width: 100,
            height: 100
        )
        
        mainStack.addArranged(imageContainer, size: 100)
        mainStack.addArranged(labelsStack)
        
        addSubview(
            mainStack,
            withEdgeInsets: UIEdgeInsets(
                top: 20,
                left: 20,
                bottom: 20,
                right: 20
            ),
            safeArea: false
        )
    }
}

#if DEBUG
import SwiftUI

@available(iOS 13.0, *)
struct CharacterTVCPreview: PreviewProvider {
    static var previews: some View {
        ViewRepresentable(
            CharacterTVC(frame: CGRect(x: 0, y: 100, width: 300, height: 200))
        ) {
            $0.setup(
                CharacterModel(
                    gender: "Male",
                    name: "Rick Sanchez",
                    image: URL(string: "https://rickandmortyapi.com/api/character/avatar/1.jpeg")!,
                    species: "Human",
                    status: "Alive"
                )
            )
        }
        .previewLayout(.fixed(width: 400.0, height: 150))
    }
}
#endif
