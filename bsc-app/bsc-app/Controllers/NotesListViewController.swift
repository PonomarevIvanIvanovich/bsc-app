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
    private let noteList = UITableView(frame: .zero, style: .plain)
    private let identifier = "Cell"
    private let appDate = AppDateFormatter()
    private let rightBarButtom = UIBarButtonItem()
    private let imageBasket = UIImage(named: "Vector")
    private let imagePlus = UIImage(named: "plus")
    private var config = UIButton.Configuration.filled()
    private var buttonTopConstraint: NSLayoutConstraint?
    private var buttonBotConstraint: NSLayoutConstraint?
    private var lastSelectedIndexPath: IndexPath?
    private var arrayDelete = [IndexPath]()
    let filter = FilterNotes()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraint()
        setupNoteList()
        setupRightBarButtom()
        setupAddNoteButton()
        filter.loadNotes {
            self.noteList.reloadData()
        }
        view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        title = "Заметки"
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        upAnimatedButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        buttonBotConstraint?.isActive = false
        buttonTopConstraint?.isActive = true
    }

    // MARK: - Action

    func goBackButton(model: NotesModel?, index: Int?) {
        guard let newModel = model else { return }
        if let index = index {
            if filter.arrayModel.indices.contains(index) {
                filter.arrayModel[index] = newModel
            } else {
                filter.arrayModel.append(newModel)
            }
            noteList.reloadData()
        } else {
            filter.loadNotes {
                self.noteList.reloadData()
            }
        }
    }

    @objc func tapAddNoteButton() {
        downAnimatedButton { _ in
            self.createNotesViewController(model: nil, index: nil)
        }
    }

    @objc func topRightBarButtom() {
        noteList.setEditing(!noteList.isEditing, animated: true)
        if noteList.isEditing {
            arrayDelete.removeAll()
            rightBarButtom.title = "Готово"
            addNoteButton.setImage(imageBasket, for: .normal)
            addNoteButton.removeTarget(self, action: #selector(tapAddNoteButton), for: .touchUpInside)
            addNoteButton.addTarget(self, action: #selector(deliteButton), for: .touchUpInside)
        } else {
            rightBarButtom.title = "Выбрать"
            addNoteButton.setImage(imagePlus, for: .normal)
            addNoteButton.removeTarget(self, action: #selector(deliteButton), for: .touchUpInside)
            addNoteButton.addTarget(self, action: #selector(tapAddNoteButton), for: .touchUpInside)
        }
    }

    @objc func deliteButton() {
        if arrayDelete.isEmpty {
            createAlert()
        } else {
            let arraySorted = arrayDelete.sorted(by: >)
            var array = NotesStorage.notesModel
            for indexPath in arraySorted {
                if filter.arrayModel[indexPath.row].isSave {
                    array?.remove(at: indexPath.row)
                }
                filter.arrayModel.remove(at: indexPath.row)
            }
            NotesStorage.notesModel = array
            noteList.reloadData()
        }
        arrayDelete.removeAll()
    }

    // MARK: - Animated

    private func downAnimatedButton(complition: ((Bool) -> Void)?) {
        UIView.animate(
            withDuration: 1.3,
            delay: 0.2,
            usingSpringWithDamping: 0.3,
            initialSpringVelocity: 0.8,
            options: [.curveEaseInOut],
            animations: {
                self.buttonBotConstraint?.isActive = false
                self.buttonTopConstraint?.isActive = true
                self.view.layoutSubviews()
            }, completion: complition)
    }

    private func upAnimatedButton() {
        UIView.animate(
            withDuration: 1.3,
            delay: 0.2,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 0.5,
            options: [.curveEaseInOut]
        ) {
            if self.buttonBotConstraint == nil {
                self.buttonBotConstraint = self.addNoteButton.bottomAnchor.constraint(
                    equalTo: self.view.bottomAnchor, constant: -60)
            }
            self.buttonTopConstraint?.isActive = false
            self.buttonBotConstraint?.isActive = true
            self.view.layoutSubviews()
        }
    }

    // MARK: - Setup elements

    private func setupNoteList() {
        noteList.allowsSelectionDuringEditing = true
        noteList.rowHeight = 90
        noteList.separatorStyle = .none
        noteList.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        noteList.register(NoteViewCell.self, forCellReuseIdentifier: identifier)
        noteList.dataSource = self
        noteList.delegate = self
    }

    private func setupRightBarButtom() {
        navigationItem.rightBarButtonItem = rightBarButtom
        rightBarButtom.title = "Выбрать"
        rightBarButtom.target = self
        rightBarButtom.action = #selector(topRightBarButtom)
    }

    private func setupAddNoteButton() {
        addNoteButton.backgroundColor = .systemBlue
        addNoteButton.layer.cornerRadius = 25
        addNoteButton.setImage(imagePlus, for: .normal)
        addNoteButton.contentVerticalAlignment = .center
        addNoteButton.contentHorizontalAlignment = .center
        addNoteButton.addTarget(self, action: #selector(tapAddNoteButton), for: .touchUpInside)
    }

    private func createAlert() {
        let alert = UIAlertController(title: "Вы не выбрали ни одной ячейки", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }

    private func createNotesViewController(model: NotesModel?, index: IndexPath?) {
        let notesViewController = NotesViewController()
        notesViewController.indexPath = index
        notesViewController.delegate = self
        notesViewController.loadNote(model: model)
        self.navigationController?.pushViewController(notesViewController, animated: true)
    }

    // MARK: - Setup constraint

    private func setupConstraint() {
        setupTableListConstraint()
        setupAddNoteButtonConstraint()
    }

    private func setupTableListConstraint() {
        view.addSubview(noteList)
        noteList.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            noteList.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            noteList.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            noteList.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            noteList.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }

    private func setupAddNoteButtonConstraint() {
        view.addSubview(addNoteButton)
        addNoteButton.translatesAutoresizingMaskIntoConstraints = false
        buttonTopConstraint = addNoteButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: 15)
        addNoteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        addNoteButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addNoteButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
}

extension NotesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filter.arrayModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? NoteViewCell {
            cell.headerlabel.text = filter.arrayModel[indexPath.row].header
            cell.textLabelCell.text = filter.arrayModel[indexPath.row].notesText
            cell.dateLabel.text = appDate.format(filter.arrayModel[indexPath.row].dateNotes, dateFormat: "dd.MM.yyyy")
            return cell
        }
        let cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        cell.textLabel?.text = "error"
        return cell
    }
}

extension NotesListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !tableView.isEditing {
            self.createNotesViewController(model: filter.arrayModel[indexPath.row], index: indexPath)
        } else {
            arrayDelete.append(indexPath)
        }
    }

    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        guard lastSelectedIndexPath == indexPath else { return nil }
        return indexPath
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        lastSelectedIndexPath = indexPath
        if let cell = tableView.cellForRow(at: indexPath) {
            if cell.isSelected {
                for (index, element) in arrayDelete.enumerated() {
                    guard element == indexPath else { continue }
                    arrayDelete.remove(at: index)
                }
                tableView.deselectRow(at: indexPath, animated: true)
                return nil
            }
        }
        return indexPath
    }

    func tableView(
        _ tableView: UITableView,
        editingStyleForRowAt indexPath: IndexPath
    ) -> UITableViewCell.EditingStyle {
        return .none
    }
}
