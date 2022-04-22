//
//  File.swift
//  bsc-app
//
//  Created by Иван Пономарев on 08.04.2022.
//

import Foundation
import UIKit

final class NotesListViewController: UIViewController, NotesViewDelegate {

    private let addNoteButton = UIButton()
    private let noteList = UITableView(frame: CGRect.zero, style: .grouped )
    private let identifier = "Cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraint()
        setupNoteList()
        setupAddNoteButton()
        view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        title = "Заметки"
    }

// MARK: - Action

    func goBackButton(model: NotesModel, index: Int) {
        noteList.reloadData()
    }

    @objc func tapAddNoteButton() {
        createNotesViewController(index: nil)
    }

    private func createNotesViewController(index: Int?) {
        let notesViewController = NotesViewController()
        notesViewController.delegate = self
        notesViewController.indexPath = index
        notesViewController.dateTextFiled.text = notesViewController.setupFormatter(
            fotmat: "dd.MM.yyyy EEEE HH:mm").string(from: notesViewController.date)
        self.navigationController?.pushViewController(notesViewController, animated: true)
    }

    // MARK: - Setup elements

    private func setupAddNoteButton() {
        addNoteButton.backgroundColor = .systemBlue
        addNoteButton.layer.cornerRadius = 25
        addNoteButton.setTitle("+", for: .normal)
        addNoteButton.titleLabel?.font = UIFont.systemFont(ofSize: 36, weight: .regular)
        addNoteButton.contentVerticalAlignment = .bottom
        addNoteButton.addTarget(self, action: #selector(tapAddNoteButton), for: .touchUpInside)
    }

    private func setupConstraint() {
        setupTableListConstraint()
        setupAddNoteButtonConstraint()
    }

    private func setupNoteList() {
        noteList.separatorInsetReference = .fromCellEdges
        noteList.separatorStyle = .none
        noteList.rowHeight = 94
        noteList.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        noteList.register(NoteCell.self, forCellReuseIdentifier: identifier)
        noteList.dataSource = self
        noteList.delegate = self
    }
// MARK: - Setup constraint

    private func setupTableListConstraint() {
        view.addSubview(noteList)
        noteList.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noteList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            noteList.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            noteList.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            noteList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupAddNoteButtonConstraint() {
        view.addSubview(addNoteButton)
        addNoteButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addNoteButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addNoteButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
            addNoteButton.heightAnchor.constraint(equalToConstant: 50),
            addNoteButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
}

extension NotesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        NotesStorage.notesModel?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = noteList.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? NoteCell {
            cell.selectionStyle = .none
            cell.noteView.headerlabel.text = NotesStorage.notesModel?[indexPath.row].header
            cell.noteView.dateLabel.text = NotesStorage.notesModel?[indexPath.row].dateNotes
            cell.noteView.textLabel.text = NotesStorage.notesModel?[indexPath.row].notesText
            return cell
        }
        let cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        cell.textLabel?.text = "error"
        return cell
    }
}

extension NotesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        createNotesViewController(index: indexPath.row)
    }
}
