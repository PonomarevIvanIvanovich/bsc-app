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
    let date = Date()
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
        loadNote()
        setupRightBarButton()
        adjustableForKeyboard()
    }

    // MARK: - setup action button

    @objc func tapBackBarButton() {
        let index = saveNewNote(notes: createModel())

        self.delegate?.goBackButton(model: createModel(), index: index)
        navigationController?.popToRootViewController(animated: true)
    }

    @objc func tapReadyBarButton() {
        view.endEditing(true)
        updateNotesModel(notes: createModel())
    }

    // MARK: - Save end load

    private func updateNotesModel(notes: NotesModel) {
        if  let indexPath = indexPath {
            guard let check = NotesStorage.notesModel?[indexPath].isEmpt else { return }
            if check {
                createAlert()
            }
            var arrayNotesModel = NotesStorage.notesModel
            arrayNotesModel?[indexPath] = notes
            NotesStorage.notesModel = arrayNotesModel
        }
    }

    private func saveNewNote(notes: NotesModel) -> Int {
        var arrayNotesModel = NotesStorage.notesModel
        if let indexPath = indexPath {
            arrayNotesModel?[indexPath] = notes
            NotesStorage.notesModel = arrayNotesModel
            return indexPath
        } else {
            arrayNotesModel?.append(createModel())
            NotesStorage.notesModel = arrayNotesModel
            return (arrayNotesModel?.count ?? 1) - 1
        }
    }

    private func createModel() -> NotesModel {
        if let newHeader = headerTextFiled.text,
           let newNotes = noteTextView.text {
            let newDate = setupFormatter(fotmat: "dd.MM.yyyy").string(from: date)
            let notesModel = NotesModel(header: newHeader, notesText: newNotes, dateNotes: newDate)
            return (notesModel)
        }
        let notesModel = NotesModel(header: "model", notesText: "получила", dateNotes: "nil")
        return notesModel
    }

    private func loadNote() {
        guard let indexPath = indexPath else { return }
        if let header = NotesStorage.notesModel?[indexPath].header {
            headerTextFiled.text = header
        }
        let date = setupFormatter(fotmat: "dd.MM.yyyy EEEE HH:mm").string(from: date)
        dateTextFiled.text = date
        if let text = NotesStorage.notesModel?[indexPath].notesText {
            noteTextView.text = text
        }
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
    func setupFormatter(fotmat: String) -> DateFormatter {
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
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
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

    func adjustableForKeyboard() {
        let natification = NotificationCenter.default
        natification.addObserver(
            self,
            selector: #selector(abjustForKeyboard),
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        natification.addObserver(
            self,
            selector: #selector(abjustForKeyboard),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil)
    }

    @objc func abjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewAndFrame = noteTextView.convert(keyboardScreenEndFrame, from: noteTextView.window)
        if notification.name == UIResponder.keyboardWillHideNotification {
            noteTextView.contentInset = .zero
            navigationItem.rightBarButtonItem = nil
        } else {
            noteTextView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewAndFrame.height, right: 0)
            navigationItem.rightBarButtonItem = rightBarButton
        }
        noteTextView.scrollIndicatorInsets = noteTextView.contentInset
        noteTextView.scrollRangeToVisible(noteTextView.selectedRange)
    }

    func createAlert() {
        let alert = UIAlertController(title: "Заполните заметку", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
}
