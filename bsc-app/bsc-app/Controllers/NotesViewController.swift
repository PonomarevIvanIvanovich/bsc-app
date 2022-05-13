//
//  NotesViewController.swift
//  bsc-app
//
//  Created by Иван Пономарев on 01.04.2022.
//

import Foundation
import UIKit

final class NotesViewController: UIViewController {

    weak var delegate: NotesViewDelegate?

    private let rightBarButton = UIBarButtonItem()
    private let backBarButton = UIBarButtonItem()
    private let imageBackButton = UIImage(named: "chevron.left")
    private let date = Date()
    private let appDate = AppDateFormatter()
    private let scrollView = UIScrollView()
    var indexPath: Int?

    private let headerTextFiled: UITextField = {
        let headerTextFiled = UITextField()
        headerTextFiled.font = UIFont(name: "SFProText-Medium", size: 24)
        headerTextFiled.placeholder = "Введите текст"
        headerTextFiled.translatesAutoresizingMaskIntoConstraints = false
        return headerTextFiled
    }()

    let dateTextFiled: UILabel = {
        let dateLabel = UILabel()
        dateLabel.font = UIFont(name: "SFProText-Medium", size: 14)
        dateLabel.textAlignment = .center
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        return dateLabel
    }()

    private let noteTextView: UITextView = {
        let noteTextView = UITextView()
        noteTextView.translatesAutoresizingMaskIntoConstraints = false
        noteTextView.font = UIFont.systemFont(ofSize: 16)
        noteTextView.isScrollEnabled = false
        noteTextView.becomeFirstResponder()
        return noteTextView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraint()
        setupBackBarButton()
        setupRightBarButton()
    }

    // MARK: - setup action button

    @objc func tapBackBarButton() {
        guard let model = createModel() else { return }
        guard let index = saveNewNote(notes: model) else { return }
        self.delegate?.goBackButton(model: model, index: index)
        navigationController?.popToRootViewController(animated: true)
    }

    @objc func tapReadyBarButton() {
        view.endEditing(true)
        guard let model  = createModel() else { return }
        updateNotesModel(notes: model)
    }

    // MARK: - Save end load

    private func updateNotesModel(notes: NotesModel) {
        if  let indexPath = indexPath {
            guard let check = NotesStorage.notesModel?[indexPath].isEmptyNotes else { return }
            if check {
                createAlert()
            }
            var arrayNotesModel = NotesStorage.notesModel
            arrayNotesModel?[indexPath] = notes
            NotesStorage.notesModel = arrayNotesModel
        }
    }

    private func saveNewNote(notes: NotesModel) -> Int? {
        guard let model  = createModel() else { return nil }
        var arrayNotesModel = NotesStorage.notesModel
        if let indexPath = indexPath {
            arrayNotesModel?[indexPath] = notes
            NotesStorage.notesModel = arrayNotesModel
            return indexPath
        } else {
            arrayNotesModel?.append(model)
            NotesStorage.notesModel = arrayNotesModel
            return (arrayNotesModel?.count ?? 1) - 1
        }
    }

    private func createModel() -> NotesModel? {
        if let newHeader = headerTextFiled.text,
           let newNotes = noteTextView.text {
            let notesModel = NotesModel(header: newHeader, notesText: newNotes, dateNotes: date)
            guard !notesModel.isEmptyNotes else {
                createAlert()
                return nil
            }
            return notesModel
        }
        return nil
    }

    func loadNote(_ model: NotesModel?) {
        dateTextFiled.text = appDate.format(date, dateFormat: "dd.MM.yyyy EEEE HH:mm")
        guard let model = model else { return }
        headerTextFiled.text = model.header
        noteTextView.text = model.notesText
    }

    // MARK: - Setup elements

    private func setupBackBarButton() {
        navigationItem.leftBarButtonItem = backBarButton
        backBarButton.target = self
        backBarButton.image = imageBackButton
        backBarButton.action = #selector(tapBackBarButton)
    }

    private func setupRightBarButton() {
        rightBarButton.title = "Готово"
        rightBarButton.target = self
        rightBarButton.action = #selector(tapReadyBarButton)
        navigationItem.rightBarButtonItem = rightBarButton
    }

    // MARK: - Date
    private func setupFormatter(fotmat: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = fotmat
        return formatter
    }

    // MARK: - Constraint

    private func setupConstraint() {
        setupDateTextFiledConstraint()
        setupHeaderTextFiledConstraint()
        setupTextViewConstraint()
        setupScrollViewConstraint()
    }

    private func setupScrollViewConstraint() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: headerTextFiled.bottomAnchor, constant: 12),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            view.keyboardLayoutGuide.topAnchor.constraint(
                equalToSystemSpacingBelow: scrollView.bottomAnchor,
                multiplier: 1.0)
        ])
    }

    private func setupDateTextFiledConstraint() {
        view.addSubview(dateTextFiled)
        NSLayoutConstraint.activate([
            dateTextFiled.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dateTextFiled.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            dateTextFiled.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            dateTextFiled.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    private func setupHeaderTextFiledConstraint() {
        view.addSubview(headerTextFiled)
        NSLayoutConstraint.activate([
            headerTextFiled.topAnchor.constraint(equalTo: dateTextFiled.bottomAnchor, constant: 20),
            headerTextFiled.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            headerTextFiled.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -70),
            headerTextFiled.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    private func setupTextViewConstraint() {
        scrollView.addSubview(noteTextView)
        NSLayoutConstraint.activate([
            noteTextView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            noteTextView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            noteTextView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            noteTextView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            noteTextView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }

    func createAlert() {
        let alert = UIAlertController(title: "Заполните заметку", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
}
