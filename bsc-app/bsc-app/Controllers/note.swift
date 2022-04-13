//
//  note.swift
//  bsc-app
//
//  Created by Иван Пономарев on 12.04.2022.
//

import Foundation
import UIKit
class NoteView: UIView {

    let nameLabel: UILabel = {
        let namelabel = UILabel()
        namelabel.text = "hello"
        namelabel.translatesAutoresizingMaskIntoConstraints = false
        return namelabel
    }()

    override init(frame: CGRect) {
        super .init(frame: frame)
        setupLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupLabel() {
        self.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
