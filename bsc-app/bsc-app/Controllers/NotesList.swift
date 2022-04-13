//
//  File.swift
//  bsc-app
//
//  Created by Иван Пономарев on 08.04.2022.
//

import Foundation
import UIKit

class NotesList: UIViewController {

//    let scrollView =  UIScrollView()
    let addButton = UIButton()
    let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Заметка"
//        setupScrollConstraint()
        configureStackView()
        setupAddButton()
        view.backgroundColor = .white
    }

    func setupAddButton() {
        addButton.backgroundColor = .systemBlue
        addButton.layer.cornerRadius = 25
        addButton.setTitle("+", for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 36, weight: .regular)
        addButton.contentVerticalAlignment = .bottom
        addButton.addTarget(self, action: #selector(tuchAddButton), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addButton)
        addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        addButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        addButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }

    @objc func tuchAddButton() {
        let notesViewController = NotesViewController()
        navigationController?.pushViewController(notesViewController, animated: true)
        navigationItem.title = ""
    }

//    func setupScrollConstraint() {
//        view.addSubview(scrollView)
//        scrollView.showsVerticalScrollIndicator = false
//        scrollView.backgroundColor = .gray
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
//        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16).isActive = true
//        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
//        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
//    }

    func configureStackView() {
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 4
        configureStackConstraint()
        let noteView = NoteView()
        stackView.addArrangedSubview(noteView)
        stackView.addArrangedSubview(NoteView())
    }

//    func addView() {
//        let numNot = 5
//        for _ in 1...numNot {
//            let noteView  = NoteView()
//            stackView.addArrangedSubview(noteView)
//
//        }
//    }

    func configureStackConstraint() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

//    func createStackView() {
//        let poteView = UILabel()
//        poteView.layer.cornerRadius = 14
//        poteView.textAlignment = .center
//        poteView.text = "hello"
//        poteView.backgroundColor = .red
//        poteView.translatesAutoresizingMaskIntoConstraints = false
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.distribution = .fillEqually
//        stackView.spacing = 10
//        stackView.addArrangedSubview(poteView)
//        scrollView.addSubview(stackView)
//        stackView.frame = view.bounds
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
//        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
//        ])
//        NSLayoutConstraint.activate([
//        poteView.topAnchor.constraint(equalTo: stackView.topAnchor),
//        poteView.leftAnchor.constraint(equalTo: stackView.leftAnchor),
//        poteView.rightAnchor.constraint(equalTo: stackView.rightAnchor),
//        poteView.heightAnchor.constraint(equalToConstant: 90)
//        ])
}
