//
//  File.swift
//  bsc-app
//
//  Created by Иван Пономарев on 08.04.2022.
//

import Foundation
import UIKit

class NotesList: UIViewController {

    let addButton: UIButton = {
        let addButton = UIButton()
        addButton.backgroundColor = .systemBlue
        addButton.layer.cornerRadius = 25
        addButton.setTitle("+", for: .normal)
        addButton.titleLabel?.font = UIFont(name: "Inter-Regular", size: 50)
        addButton.addTarget(addButton, action: #selector(tuchAddButton), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        return addButton
    }()

    let notLabel: UILabel = {
        let notLabel = UILabel()
        notLabel.text = "Заметка"
        notLabel.textAlignment = .center
        notLabel.font = UIFont(name: "SFProText-Semibold", size: 17)
        notLabel.translatesAutoresizingMaskIntoConstraints = false
        return notLabel
    }()

    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .white
        stackView.layer.cornerRadius = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        setupConstreint()
    }

    @objc func tuchAddButton() {
        let notesViewController = NotesViewController()
        present(notesViewController, animated: true, completion: nil)
    }

    func setupConstreint() {
        setupNotLabelConstraint()
        setupStackConstraint()
        setupAddButtonConstraint()
    }

    func setupStackConstraint() {
        view.addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: notLabel.bottomAnchor, constant: 26).isActive = true
        stackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 90).isActive = true
    }

    func setupAddButtonConstraint() {
        view.addSubview(addButton)
        addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        addButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }

    func setupNotLabelConstraint() {
        view.addSubview(notLabel)
        notLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        notLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor ).isActive = true
        notLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        notLabel.widthAnchor.constraint(equalToConstant: 130).isActive = true
    }
}
