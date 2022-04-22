//
//  NoteListCell.swift
//  bsc-app
//
//  Created by Иван Пономарев on 18.04.2022.
//

import Foundation
import UIKit

final class NoteCell: UITableViewCell {

    var noteView = NoteView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        setupConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraint() {
        self.contentView.addSubview(noteView)
        NSLayoutConstraint.activate([
            noteView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            noteView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16),
            noteView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16),
            noteView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2)
        ])
    }
}
