//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

import UIKit

class SinglePrimeViewController: UIViewController {
    @IBOutlet private var inputTextField: UITextField!
    @IBOutlet private var computePrimeButton: UIButton!
    @IBOutlet private var responseTextView: UITextView!

    private lazy var viewModel = SinglePrimeViewModel()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        computePrimeButton.addGradient()
    }

    @IBAction func computePrimeButtonPressed() {
        inputTextField.resignFirstResponder()
        responseTextView.text = viewModel.computeResponse()
    }
}

extension SinglePrimeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_: UITextField) {
        computePrimeButton.isEnabled = viewModel.updateAndValidateInput("")
    }

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let text = textField.text else { return true }
        let newText = String(NSString(string: text).replacingCharacters(in: range, with: string))
        computePrimeButton.isEnabled = viewModel.updateAndValidateInput(newText)
        return true
    }
}
