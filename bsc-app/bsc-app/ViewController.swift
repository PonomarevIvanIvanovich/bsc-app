//
//  ViewController.swift
//  bsc-app
//
//  Created by Иван Пономарев on 27.03.2022.
//

import UIKit

class ViewController: UIViewController {
    
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
        textView.backgroundColor = .black.withAlphaComponent(0.1)
        textView.isScrollEnabled = false
        return textView
    }()
    
    let button: UIButton = {
        let button = UIButton()
        button.setTitle("Готово", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstreint()
    }
    
    func setupConstreint(){
        setupTextFiledConstreint()
        setupButtonConstreint()
        setupTextViewConstreint()
    }
    
    func setupTextFiledConstreint(){
        view.addSubview(textFiled)
        textFiled.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        textFiled.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textFiled.heightAnchor.constraint(equalToConstant: 40).isActive = true
        textFiled.widthAnchor.constraint(equalToConstant: 110).isActive = true
        }
    
    func setupTextViewConstreint(){
        view.addSubview(textView)
        textView.topAnchor.constraint(equalTo: textFiled.bottomAnchor, constant: 8).isActive = true
        textView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        textView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        textView.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
    }

    func setupButtonConstreint(){
        view.addSubview(button)
        button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        button.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    @objc func buttonTapped(){
        view.endEditing(true)
    }
}
