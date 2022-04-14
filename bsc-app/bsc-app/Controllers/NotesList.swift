//
//  File.swift
//  bsc-app
//
//  Created by Иван Пономарев on 08.04.2022.
//

import Foundation
import UIKit

class NotesList: UIViewController, NotesViewDelegate {

    private let scrollView =  UIScrollView()
    private let addNoteButton = UIButton()
    private let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Заметки"
        view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        setupStackView()
        setupNoteListConstraint()
        setupAddNoteButton()
    }

    // MARK: - Create notesmodel and stackview

    func createNotesViewController(index: Int?) {
        let notesViewController = NotesViewController()
        notesViewController.delegate = self
        notesViewController.indexPath = index
        self.navigationController?.pushViewController(notesViewController, animated: true)
    }

    func createStackView() {
        guard let arr = NotesStorage.notesModel else { return }
        for (index, note) in arr.enumerated() {
            let noteView = NoteView()
            noteView.headerlabel.text = note.header
            noteView.dateLabel.text = note.dateNotes
            noteView.textLabel.text = note.notesText
            noteView.tapClosure = {
                self.createNotesViewController(index: index)
            }
            stackView.addArrangedSubview(noteView)
        }
    }

    func goBackButton(model: NotesModel, index: Int) {
        if stackView.arrangedSubviews.indices.contains(index) {
            let view = stackView.arrangedSubviews[index]
            if let noteView = view as? NoteView {
                noteView.headerlabel.text = model.header
                noteView.dateLabel.text = model.dateNotes
                noteView.textLabel.text = model.notesText
            }
        } else {
            let noteView = NoteView()
            noteView.headerlabel.text = model.header
            noteView.dateLabel.text = model.dateNotes
            noteView.textLabel.text = model.notesText
            noteView.tapClosure = {
                self.createNotesViewController(index: index)
            }
            stackView.addArrangedSubview(noteView)
        }
    }

    // MARK: - setup

    @objc func tapAddNoteButton() {
        createNotesViewController(index: nil)
    }

    func setupAddNoteButton() {
        addNoteButton.backgroundColor = .systemBlue
        addNoteButton.layer.cornerRadius = 25
        addNoteButton.setTitle("+", for: .normal)
        addNoteButton.titleLabel?.font = UIFont.systemFont(ofSize: 36, weight: .regular)
        addNoteButton.contentVerticalAlignment = .bottom
        addNoteButton.addTarget(self, action: #selector(tapAddNoteButton), for: .touchUpInside)
    }

    func setupStackView() {
        scrollView.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.layer.cornerRadius = 14
        createStackView()
    }

    // MARK: - Setup constraint
    func setupNoteListConstraint() {
        setupScrollViewConstraint()
        setupStackConstraint()
        setupAddNoteButtonConstraint()
    }

    func setupAddNoteButtonConstraint() {
        view.addSubview(addNoteButton)
        addNoteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addNoteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addNoteButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            addNoteButton.heightAnchor.constraint(equalToConstant: 50),
            addNoteButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }

    func setupScrollViewConstraint() {
        view.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    func setupStackConstraint() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
}
