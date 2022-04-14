//
//  note.swift
//  bsc-app
//
//  Created by Иван Пономарев on 12.04.2022.
//

import Foundation
import UIKit
class NoteView: UIView {

    var tapClosure: (() -> Void)?

    let headerlabel: UILabel = {
        let namelabel = UILabel()
        namelabel.text = NotesStorage.notesModel?.last?.header
        namelabel.font = UIFont(name: "SFProText-Medium", size: 16)
        namelabel.translatesAutoresizingMaskIntoConstraints = false
        return namelabel
    }()

    let textLabel: UILabel = {
        let textLabel = UILabel()
        textLabel.text = NotesStorage.notesModel?.last?.notesText
        textLabel.font = UIFont(name: "SFProText-Medium", size: 10)
        textLabel.textColor = UIColor(red: 0.675, green: 0.675, blue: 0.675, alpha: 1)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()

    let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.text = NotesStorage.notesModel?.last?.dateNotes
        dateLabel.font = UIFont(name: "SFProText-Medium", size: 10)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        return dateLabel
    }()

    override init(frame: CGRect) {
        super .init(frame: frame)
        setupConstraint()
        tapView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tapView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureRecognizer))
        self.addGestureRecognizer(gesture)
    }

    @objc func tapGestureRecognizer(sender: UITapGestureRecognizer) {
        self.tapClosure?()
    }

    // MARK: - Constraint

    func setupConstraint() {
        noteViewConstraint()
        setupLabelConstraint()
        setupTextLabelConstraint()
        setupDateLabelConstraint()
    }

    func setupLabelConstraint() {
        self.addSubview(headerlabel)
        NSLayoutConstraint.activate([
            headerlabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            headerlabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            headerlabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -42),
            headerlabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }

    func setupTextLabelConstraint() {
        self.addSubview(textLabel)
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: headerlabel.bottomAnchor,constant: 4),
            textLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            textLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16),
            textLabel.heightAnchor.constraint(equalToConstant: 14)
        ])
    }

    func setupDateLabelConstraint() {
        self.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.topAnchor.constraint(equalTo: textLabel.bottomAnchor, constant: 24),
            dateLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            dateLabel.heightAnchor.constraint(equalToConstant: 10)
        ])
    }

    func noteViewConstraint() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 90).isActive = true
        self.backgroundColor = .white
        self.layer.cornerRadius = 14
    }
}
