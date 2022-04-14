//
//  NotesViewController.swift
//  bsc-app
//
//  Created by Иван Пономарев on 01.04.2022.
//

import Foundation
import UIKit

class NotesViewController: UIViewController {

    weak var delegate: NotesViewDelegate?

    private let rightBarButton = UIBarButtonItem()
    private let backBarButton = UIBarButtonItem()
    private let imageBackButton = UIImage(named: "chevron.left" )
    private let date = Date()
    private let scrollView = UIScrollView()
    var indexPath: Int?

    private let headerTextFiled: UITextField = {
        let headerTextFiled = UITextField()
        headerTextFiled.font = UIFont(name: "SFProText-Medium", size: 24)
        headerTextFiled.placeholder = "Введите текст"
        headerTextFiled.translatesAutoresizingMaskIntoConstraints = false
        return headerTextFiled
    }()

    private let dateTextFiled: UILabel = {
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
        noteTextView.adjustableForKeyboard()
        return noteTextView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraint()
        setupRightBarButton()
        setupBackBarButton()
        loadNote()
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

    func updateNotesModel(notes: NotesModel) {
        if indexPath != nil {
            var arrayNotesModel = NotesStorage.notesModel
            arrayNotesModel?[indexPath!] = notes
            NotesStorage.notesModel = arrayNotesModel
        }
        view.endEditing(true)
    }

    func saveNewNote(notes: NotesModel) -> Int {
        var arrayNotesModel = NotesStorage.notesModel
        if indexPath == nil {
            arrayNotesModel?.append(createModel())
            NotesStorage.notesModel = arrayNotesModel
            return (arrayNotesModel?.count ?? 1) - 1
        } else {
            arrayNotesModel?[indexPath!] = notes
            NotesStorage.notesModel = arrayNotesModel
            return indexPath!
        }
    }

    func createModel() -> NotesModel {
        let newHeader = headerTextFiled.text!
        let newNotes = noteTextView.text!
        let newDate = dateTextFiled.text!
        let notesModel = NotesModel(header: newHeader, notesText: newNotes, dateNotes: newDate)
        return (notesModel)
    }

    func loadNote() {
        if indexPath != nil {
            if let header  = NotesStorage.notesModel?[indexPath!].header {
                headerTextFiled.text = header
            }
            let date = setupFormatter().string(from: date)
            dateTextFiled.text = date
            if let text = NotesStorage.notesModel?[indexPath!].notesText {
                noteTextView.text = text
            }
        }
    }

    // MARK: - Setup elements

    func setupBackBarButton() {
        navigationItem.leftBarButtonItem = backBarButton
        backBarButton.target = self
        backBarButton.image = imageBackButton
        backBarButton.action = #selector(tapBackBarButton)
    }

    func setupRightBarButton() {
        rightBarButton.title = "Готово"
        rightBarButton.target = self
        rightBarButton.action = #selector(tapReadyBarButton)
        navigationItem.rightBarButtonItem = rightBarButton
    }

    // MARK: - Date
    func setupFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "dd.MM.yyyy EEEE HH:mm"
        return formatter
    }

    // MARK: - Constreint

    func setupConstraint() {
        setupDateTextFiledConstraint()
        setupHeaderTextFiledConstraint()
        setupTextViewConstraint()
        setupScrollViewConstraint()
    }

    func setupScrollViewConstraint() {
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

    func setupDateTextFiledConstraint() {
        dateTextFiled.text = setupFormatter().string(from: date)
        view.addSubview(dateTextFiled)
        NSLayoutConstraint.activate([
            dateTextFiled.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            dateTextFiled.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            dateTextFiled.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            dateTextFiled.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    func setupHeaderTextFiledConstraint() {
        view.addSubview(headerTextFiled)
        NSLayoutConstraint.activate([
            headerTextFiled.topAnchor.constraint(equalTo: dateTextFiled.bottomAnchor, constant: 20),
            headerTextFiled.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            headerTextFiled.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -70),
            headerTextFiled.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    func setupTextViewConstraint() {
        scrollView.addSubview(noteTextView)
        NSLayoutConstraint.activate([
            noteTextView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 10),
            noteTextView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            noteTextView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            noteTextView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            noteTextView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
}

extension UITextView {
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
        let keyboardViewAndFrame = convert(keyboardScreenEndFrame, from: window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            contentInset = .zero
        } else {
            contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewAndFrame.height, right: 0)
        }
        scrollIndicatorInsets = contentInset
        scrollRangeToVisible(selectedRange)
    }
}
extension NotesViewController {
    func notesIsEmpty() {
        if  NotesStorage.notesModel?[indexPath!].isEmpt == true {
            let alert = UIAlertController(title: "Заполните заметку", message: nil, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
        }
    }
}
