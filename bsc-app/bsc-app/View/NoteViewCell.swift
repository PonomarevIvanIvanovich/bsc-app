//
//  note.swift
//  bsc-app
//
//  Created by Иван Пономарев on 12.04.2022.
//

import Foundation
import UIKit
final class NoteViewCell: UITableViewCell {

    var tapClosure: (() -> Void)?

    let headerlabel: UILabel = {
        let namelabel = UILabel()
        namelabel.font = UIFont(name: "SFProText-Medium", size: 16)
        namelabel.translatesAutoresizingMaskIntoConstraints = false
        return namelabel
    }()

    let textLabelCell: UILabel = {
        let textLabel = UILabel()
        textLabel.font = UIFont(name: "SFProText-Medium", size: 10)
        textLabel.textColor = UIColor(red: 0.675, green: 0.675, blue: 0.675, alpha: 1)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        return textLabel
    }()

    let dateLabel: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = UIFont(name: "SFProText-Medium", size: 10)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        return dateLabel
    }()

    private let checkBoxView = UIImageView()
    private var checkLeadingConstraint: NSLayoutConstraint?
    private var checkTrailingConstraint: NSLayoutConstraint?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        setupConstraint()
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup constraint

    private func setupConstraint() {
        noteViewConstraint()
        setupLabelConstraint()
        setupTextLabelConstraint()
        setupDateLabelConstraint()
    }

    func checkSelected() {
        if isSelected {
            checkBoxView.image = UIImage(named: "Check")
        } else {
            checkBoxView.image = UIImage(named: "unCheck")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        checkSelected()
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        setupChekConstraint()
    }

    func setupChekConstraint() {
        checkBoxView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(checkBoxView)
        checkTrailingConstraint = checkBoxView.rightAnchor.constraint(equalTo: contentView.leftAnchor, constant: -10)
        checkTrailingConstraint?.isActive = true
        checkLeadingConstraint = checkBoxView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        NSLayoutConstraint.activate([
            checkBoxView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -37),
            checkBoxView.heightAnchor.constraint(equalToConstant: 16),
            checkBoxView.widthAnchor.constraint(equalToConstant: 16)
        ])
    }

    private func setupLabelConstraint() {
        contentView.addSubview(headerlabel)
        NSLayoutConstraint.activate([
            headerlabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            headerlabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headerlabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -42),
            headerlabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }

    private func setupTextLabelConstraint() {
        contentView.addSubview(textLabelCell)
        NSLayoutConstraint.activate([
            textLabelCell.topAnchor.constraint(equalTo: headerlabel.bottomAnchor, constant: 4),
            textLabelCell.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            textLabelCell.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            textLabelCell.heightAnchor.constraint(equalToConstant: 14)
        ])
    }

    private func setupDateLabelConstraint() {
        contentView.addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            dateLabel.heightAnchor.constraint(equalToConstant: 10)
        ])
    }

    private func noteViewConstraint() {
        backgroundColor = .white
        self.layer.borderWidth = 2
        self.layer.borderColor = .init(gray: 0, alpha: 0.1)
        layer.cornerRadius = 14
    }
}
