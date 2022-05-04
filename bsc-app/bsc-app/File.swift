//
//  File.swift
//  bsc-app
//
//  Created by Иван Пономарев on 18.04.2022.
//

import Foundation

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
