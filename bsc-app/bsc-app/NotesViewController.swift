//
//  ViewController.swift
//  bsc-app
//
//  Created by Иван Пономарев on 27.03.2022.
//

import UIKit

class NotesViewController: UIViewController {

    struct Keys {
        static let keyTextView = "keyTextView"
        static let keyTextFild = "keyTextFiled"
    }

    let textFiled: UITextField = {
        let textFiled = UITextField()
        textFiled.placeholder = "Заголовок"
        textFiled.translatesAutoresizingMaskIntoConstraints = false
        textFiled.font = .boldSystemFont(ofSize: 22)
        return textFiled
    }()

    let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        textView.becomeFirstResponder()
        return textView
    }()

    private let rightBarButton = UIBarButtonItem()
    private let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRightBarButton()
        setupConstreint()
        loadData()
    }

    func setupConstreint() {
        setupTextFiledConstreint()
        setupTextViewConstreint()
    }

    @objc func didRightBarButtonTapped() {
        view.endEditing(true)
        saveData()
    }

    func setupRightBarButton() {
        rightBarButton.title = "Готово"
        rightBarButton.target = self
        rightBarButton.action = #selector(didRightBarButtonTapped)
        navigationItem.rightBarButtonItem = rightBarButton
    }

    func saveData() {
        defaults.set(textView.text, forKey: Keys.keyTextView)
        defaults.set(textFiled.text, forKey: Keys.keyTextFild)
    }

    func loadData() {
        textView.text = UserDefaults.standard.string(forKey: Keys.keyTextView)
        textFiled.text = UserDefaults.standard.string(forKey: Keys.keyTextFild)
    }

    func setupTextFiledConstreint() {
        view.addSubview(textFiled)
        textFiled.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        textFiled.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        textFiled.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        textFiled.heightAnchor.constraint(equalToConstant: 30).isActive = true
        }

    func setupTextViewConstreint() {
        view.addSubview(textView)
        textView.topAnchor.constraint(equalTo: textFiled.bottomAnchor, constant: 8).isActive = true
        textView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        textView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        textView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
    }
}
