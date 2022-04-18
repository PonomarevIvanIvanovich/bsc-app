//
//  NotesViewController.swift
//  bsc-app
//
//  Created by Иван Пономарев on 01.04.2022.
//

import Foundation
import UIKit

 final class NotesViewController: UIViewController {

    private let rightBarButton = UIBarButtonItem()
    let date = Date()

    private let headerTextFiled: UITextField = {
        let textFiled = UITextField()
        textFiled.placeholder = "Заголовок"
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        textFiled.font = .boldSystemFont(ofSize: 22)
        return textFiled
    }()

    private let dateTextFiled: UITextField = {
        let dateTextFiled = UITextField()
        dateTextFiled.translatesAutoresizingMaskIntoConstraints = false
        return dateTextFiled
    }()

    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        textView.becomeFirstResponder()
        textView.backgroundColor = .systemGray.withAlphaComponent(0.1)
        return textView
    }()

    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = .white
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        return datePicker
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraint()
        setupRightBarButton()
        setupDatePicker()
        loadData()
    }

    @objc func didRightBarButtonTapped() {
        view.endEditing(true)
        saveData()
        notesIsEmpty()
    }

    func setupRightBarButton() {
        rightBarButton.title = "Готово"
        rightBarButton.target = self
        rightBarButton.action = #selector(didRightBarButtonTapped)
        navigationItem.rightBarButtonItem = rightBarButton
    }

// MARK: - Save end load

    func saveData() {
        let newHeader = headerTextFiled.text!.trimmingCharacters(in: .whitespaces)
        let newNotes = textView.text!.trimmingCharacters(in: .whitespaces)
        let newDate = dateTextFiled.text!.trimmingCharacters(in: .whitespaces)
        var notes = NotesStorage.notesModel
        notes = NotesModel(header: newHeader, notesText: newNotes, dateNotes: newDate)
        NotesStorage.notesModel = notes
    }

    func loadData() {
        headerTextFiled.text = NotesStorage.notesModel?.header
        dateTextFiled.text = NotesStorage.notesModel?.dateNotes
        textView.text = NotesStorage.notesModel?.notesText
    }

// MARK: - date
    func setupFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "d MMMM yyyy"
        return formatter
    }

    func setupDatePicker() {
        dateTextFiled.placeholder = setupFormatter().string(from: date)
        dateTextFiled.inputView = datePicker
        dateTextFiled.inputAccessoryView = createToolBar()
    }

    func createToolBar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let doneBar = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolBar.setItems([doneBar], animated: true)
        return toolBar
    }

    @objc func donePressed() {
        dateTextFiled.text = setupFormatter().string(from: datePicker.date)
        view.endEditing(true)
    }

// MARK: - Constreint

    func setupConstraint() {
        setupHeaderTextFiledConstraint()
        setupDateTextFiledConstraint()
        setupTextViewConstraint()
    }

    func setupHeaderTextFiledConstraint() {
        view.addSubview(headerTextFiled)
        NSLayoutConstraint.activate([
        headerTextFiled.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        headerTextFiled.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
        headerTextFiled.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
        headerTextFiled.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    func setupDateTextFiledConstraint() {
        view.addSubview(dateTextFiled)
        NSLayoutConstraint.activate([
        dateTextFiled.topAnchor.constraint(equalTo: headerTextFiled.bottomAnchor, constant: 6),
        dateTextFiled.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
        dateTextFiled.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
        dateTextFiled.heightAnchor.constraint(equalToConstant: 20)
        ])
    }

    func setupTextViewConstraint() {
        view.addSubview(textView)
        NSLayoutConstraint.activate([
        textView.topAnchor.constraint(equalTo: dateTextFiled.bottomAnchor, constant: 6),
        textView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16),
        textView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16),
        textView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor),
        textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
    }
}

extension NotesViewController {
    func notesIsEmpty() {
        if  NotesStorage.notesModel?.isEmpt == true {
            let alert = UIAlertController(title: "Заполните заметку", message: nil, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
        }
    }
}
