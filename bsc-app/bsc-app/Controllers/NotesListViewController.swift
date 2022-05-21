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
    private let parsIdenifire = "ParsCell"
    private let appDate = AppDateFormatter()
    private let rightBarButtom = UIBarButtonItem()
    private let imageBasket = UIImage(named: "Vector")
    private let imagePlus = UIImage(named: "plus")
    private var config = UIButton.Configuration.filled()
    private var buttonTopConstraint: NSLayoutConstraint?
    private var buttonBotConstraint: NSLayoutConstraint?
    private var lastSelectedIndexPath: IndexPath?
    private var arrayDelete = [IndexPath]()
    private var arrayParsNote = [WelcomeNotes]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraint()
        setupNoteList()
        setupRightBarButtom()
        setupAddNoteButton()
        createArrayPars()
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

    func goBackButton(model: NotesModel?, parsModel: WelcomeNotes?, index: Int) {
        guard let parsModel = parsModel else {
            return  noteList.reloadData()
        }
        arrayParsNote[index] = parsModel
        noteList.reloadData()
    }

    @objc func tapAddNoteButton() {
        downAnimatedButton { _ in
            self.createNotesViewController(parsModel: nil, model: nil, index: nil)
        }
    }

    @objc func topRightBarButtom() {
        noteList.setEditing(!noteList.isEditing, animated: true)
        if noteList.isEditing {
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
            var arraySorted = arrayDelete.sorted(by: > )
            print(arraySorted)
            var array = NotesStorage.notesModel
            for indexPath in arraySorted {
                if indexPath.section == 1 {
                    array?.remove(at: indexPath.row)
                } else {
                    arrayParsNote.remove(at: indexPath.row)
                }
            }
            NotesStorage.notesModel = array
            noteList.reloadData()
        }

        arrayDelete.removeAll()
    }

    // MARK: - Animated

    private func downAnimatedButton(complition: ((Bool) -> Void)?) {
        UIView.animate(
            withDuration: 0.7,
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
            withDuration: 0.7,
            delay: 0.2,
            usingSpringWithDamping: 0.3,
            initialSpringVelocity: 0.8,
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
        noteList.register(NoteViewCell.self, forCellReuseIdentifier: parsIdenifire)
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

    private func createNotesViewController(parsModel: WelcomeNotes?, model: NotesModel?, index: IndexPath?) {
        let notesViewController = NotesViewController()
        if let parsModel = parsModel {
            notesViewController.loadNote(parsModel: parsModel, model: nil)
        } else {
        notesViewController.loadNote(parsModel: nil, model: model)
        }
        notesViewController.delegate = self
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
        buttonTopConstraint = addNoteButton.topAnchor.constraint(equalTo: view.bottomAnchor)
        addNoteButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        addNoteButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        addNoteButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }

    func createArrayPars() {
        let worker = Worker()
        worker.request(complition: { (welcomeNotes, _) in
            guard let welcome = welcomeNotes else { return }
            self.arrayParsNote = welcome
            self.noteList.reloadData()
        })
    }
}

extension NotesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return NotesStorage.notesModel?.count ?? 0
        } else {
            return arrayParsNote.count
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        if arrayParsNote.isEmpty {
            return 1
        } else {
            return 2
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? NoteViewCell {
            if indexPath.section == 0 {
                cell.headerlabel.text = arrayParsNote[indexPath.row].header
                cell.textLabelCell.text = arrayParsNote[indexPath.row].text
                cell.dateLabel.text = appDate.format(arrayParsNote[indexPath.row].date, dateFormat: "dd.MM.yyyy")
                return cell
            } else {
                cell.headerlabel.text = NotesStorage.notesModel?[indexPath.row].header
                if let date = NotesStorage.notesModel?[indexPath.row].dateNotes {
                    cell.dateLabel.text = appDate.format(date, dateFormat: "dd.MM.yyyy")
                }
                cell.textLabelCell.text = NotesStorage.notesModel?[indexPath.row].notesText
                return cell
            }
        }
        let cell = UITableViewCell(style: .default, reuseIdentifier: identifier)
        cell.textLabel?.text = "error"
        return cell
    }
}

extension NotesListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !tableView.isEditing {
            if indexPath.section == 0 {
                self.createNotesViewController(
                    parsModel: arrayParsNote[indexPath.row],
                    model: nil,
                    index: indexPath)
            } else {
                self.createNotesViewController(
                    parsModel: nil,
                    model: NotesStorage.notesModel?[indexPath.row],
                    index: indexPath)
            }
        } else {
            arrayDelete.append(indexPath)
            print(arrayDelete)
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
                    print(arrayDelete)
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
