//
//  File.swift
//  bsc-app
//
//  Created by Иван Пономарев on 08.04.2022.
//

import Foundation
import UIKit

final class NotesListViewController: UIViewController, NotesViewDelegate {
    var interactor: NotesListInteractor?
    private let addNoteButton = UIButton()
    private let noteList = UITableView(frame: .zero, style: .plain)
    private let identifier = "Cell"
    private let rightBarButtom = UIBarButtonItem()
    private let imageBasket = UIImage(named: "Vector")
    private let imagePlus = UIImage(named: "plus")
    private var config = UIButton.Configuration.filled()
    private var buttonTopConstraint: NSLayoutConstraint?
    private var buttonBotConstraint: NSLayoutConstraint?
    private var lastSelectedIndexPath: IndexPath?
    private var arrayDelete = [IndexPath]()
    private var displayedNotes: [NotesListSceneModel.NotesViewModel] = []
    var image = UIImage()
    static let activityIndicator = UIActivityIndicatorView()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        print("NotesListViewController init")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("NotesListViewController deinit")
    }

    func display(_ viewModel: NotesListSceneModel.InitForm.ViewModel) {
        reload(notes: viewModel.notesViewModels)
    }

    func display(_ viewModel: NotesListSceneModel.DeleteItems.ViewModel) {
        reload(notes: viewModel.notesViewModels)
    }

    private func reload(notes: [NotesListSceneModel.NotesViewModel]) {
        displayedNotes = notes
        noteList.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        NotesListViewController.activityIndicator.startAnimating()
        setupConstraint()
        setupNoteList()
        setupRightBarButtom()
        setupAddNoteButton()
        view.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        title = "Заметки"
        interactor?.request(NotesListSceneModel.InitForm.Request())
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

    func goBackButton(model: NotesListSceneModel.NotesViewModel?, index: Int?) {
        guard let newModel = model else { return }
        if let index = index {
            if displayedNotes.indices.contains(index) {
                displayedNotes[index] = newModel
            } else {
                displayedNotes.append(newModel)
            }
            noteList.reloadData()
        } else {
            displayedNotes.append(newModel)
            noteList.reloadData()
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
            interactor?.request(NotesListSceneModel.DeleteItems.Request(arraySorted: arraySorted))
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

    private func createNotesViewController(model: NotesListSceneModel.NotesViewModel?, index: IndexPath?) {
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
        setupCtivityConstraint()
    }

    private func setupCtivityConstraint() {
        view.addSubview(NotesListViewController.activityIndicator)
        NotesListViewController.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NotesListViewController.activityIndicator.hidesWhenStopped = true
        NSLayoutConstraint.activate([
            NotesListViewController.activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            NotesListViewController.activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
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
        displayedNotes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? NoteViewCell
        else { return UITableViewCell() }
        cell.headerlabel.text = displayedNotes[indexPath.row].header
        cell.textLabelCell.text = displayedNotes[indexPath.row].notesText
        cell.dateLabel.text = displayedNotes[indexPath.row].dateNotes
        cell.loadImage(imageURL: displayedNotes[indexPath.row].userShareIcon)
        return cell
    }
}

extension NotesListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !tableView.isEditing {
            self.createNotesViewController(model: displayedNotes[indexPath.row], index: indexPath)
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
