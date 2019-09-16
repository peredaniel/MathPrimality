//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

import UIKit

class PrimeListViewController: UIViewController {
    @IBOutlet private var lowerBoundTextField: UITextField!
    @IBOutlet private var upperBoundTextField: UITextField!
    @IBOutlet private var computePrimesListButton: UIButton!
    @IBOutlet private var responseLabel: UILabel!

    private lazy var viewModel = PrimeListViewModel()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        computePrimesListButton.addGradient()
    }

    @IBAction func computePrimesListButtonPressed() {
        lowerBoundTextField.resignFirstResponder()
        upperBoundTextField.resignFirstResponder()
        responseLabel.text = viewModel.computeResponse()
    }
}

extension PrimeListViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == lowerBoundTextField {
            computePrimesListButton.isEnabled = viewModel.updateAndValidateInputs(
                lower: "",
                upper: upperBoundTextField.text
            )
        } else if textField == upperBoundTextField {
            computePrimesListButton.isEnabled = viewModel.updateAndValidateInputs(
                lower: lowerBoundTextField.text,
                upper: ""
            )
        }
    }

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        guard let text = textField.text else { return true }
        let newText = String(NSString(string: text).replacingCharacters(in: range, with: string))
        if textField == lowerBoundTextField {
            computePrimesListButton.isEnabled = viewModel.updateAndValidateInputs(
                lower: newText,
                upper: upperBoundTextField.text
            )
        } else if textField == upperBoundTextField {
            computePrimesListButton.isEnabled = viewModel.updateAndValidateInputs(
                lower: lowerBoundTextField.text,
                upper: newText
            )
        }
        return true
    }
}
