//
//  NotesViewController.swift
//  bsc-app
//
//  Created by Иван Пономарев on 01.04.2022.
//

import Foundation
import UIKit

class NotesViewController: UIViewController {

    private let rightBarButton = UIBarButtonItem()
    let date = Date()

    let headerTextFiled: UITextField = {
        let textFiled = UITextField()
        textFiled.placeholder = "Заголовок"
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        textFiled.font = .boldSystemFont(ofSize: 22)
        return textFiled
    }()

    let dateTextFiled: UITextField = {
        let dateTextFiled = UITextField()
        dateTextFiled.translatesAutoresizingMaskIntoConstraints = false
        return dateTextFiled
    }()

    let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        textView.becomeFirstResponder()
        textView.backgroundColor = .systemGray.withAlphaComponent(0.1)
        return textView
    }()

    let datePicker: UIDatePicker = {
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
        setupConstreint()
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
        let notes = NotesModel(header: newHeader, notesText: newNotes, dateNotes: newDate)
        NotesStorege.notesModel =  notes
    }

    func loadData() {
        headerTextFiled.text = NotesStorege.notesModel.header
        dateTextFiled.text = NotesStorege.notesModel.dateNotes
        textView.text = NotesStorege.notesModel.notesText
    }

// MARK: - date
    func setupFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "d MMMM  yyyy"
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

    func setupConstreint() {
        setupHeaderTextFiledConstreint()
        setupDateTextFiledConstreint()
        setupTextViewConstreint()
    }

    func setupHeaderTextFiledConstreint() {
        view.addSubview(headerTextFiled)
        headerTextFiled.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerTextFiled.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                              constant: 16).isActive = true
        headerTextFiled.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                               constant: -16).isActive = true
        headerTextFiled.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }

    func setupDateTextFiledConstreint() {
        view.addSubview(dateTextFiled)
        dateTextFiled.topAnchor.constraint(equalTo: headerTextFiled.bottomAnchor, constant: 6).isActive = true
        dateTextFiled.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        dateTextFiled.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                             constant: -16).isActive = true
        dateTextFiled.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }

    func setupTextViewConstreint() {
        view.addSubview(textView)
        textView.topAnchor.constraint(equalTo: dateTextFiled.bottomAnchor, constant: 6).isActive = true
        textView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        textView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        textView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
    }
}

extension NotesViewController {
    func notesIsEmpty() {
        if  NotesStorege.notesModel.isEmpt == true {
            let alert = UIAlertController(title: "Заполните заметку", message: nil, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(alertAction)
            present(alert, animated: true, completion: nil)
        }
    }
}
