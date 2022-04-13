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
        let headerTextFiled = UITextField()
        headerTextFiled.font = UIFont(name: "SFProText-Medium", size: 24)// надо?
        headerTextFiled.placeholder = "Введите текст"
        headerTextFiled.translatesAutoresizingMaskIntoConstraints = false
        return headerTextFiled
    }()

    let dateLabel: UITextField = {
        let dateLabel = UITextField()
        dateLabel.font = UIFont(name: "SFProText-Medium", size: 14) // ???
        dateLabel.textAlignment = .center
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        return dateLabel
    }()

    let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.isScrollEnabled = false
        textView.becomeFirstResponder()
        return textView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        dateLabel.placeholder = setupFormatter().string(from: date)// куда жевать?
        view.backgroundColor = .white // ???
        setupConstraint()
        setupRightBarButton()
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

    @objc func didLeftBarButtonTapped() {

    }

// MARK: - Save end load

    func saveData() {
        let newHeader = headerTextFiled.text!.trimmingCharacters(in: .whitespaces)
        let newNotes = textView.text!.trimmingCharacters(in: .whitespaces)
        let newDate = dateLabel.text!.trimmingCharacters(in: .whitespaces)
        let notes = NotesModel(header: newHeader, notesText: newNotes, dateNotes: newDate)
        NotesStorege.notesModel =  notes
    }

    func loadData() {
        headerTextFiled.text = NotesStorege.notesModel.header
        dateLabel.text = NotesStorege.notesModel.dateNotes
        textView.text = NotesStorege.notesModel.notesText
    }

// MARK: - date
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
    }

    func setupDateTextFiledConstraint() {
        view.addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }

    func setupHeaderTextFiledConstraint() {
        view.addSubview(headerTextFiled)
        headerTextFiled.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20).isActive = true
        headerTextFiled.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,
                                              constant: 20).isActive = true
        headerTextFiled.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,
                                               constant: -70).isActive = true
        headerTextFiled.heightAnchor.constraint(equalToConstant: 44).isActive = true
    }

    func setupTextViewConstraint() {
        view.addSubview(textView)
        textView.topAnchor.constraint(equalTo: headerTextFiled.bottomAnchor, constant: 12).isActive = true
        textView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20).isActive = true
        textView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
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
