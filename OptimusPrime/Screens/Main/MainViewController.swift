//  Copyright © 2019 Pedro Daniel Prieto Martínez. Distributed under MIT License.

import UIKit

class MainViewController: UIViewController {
    @IBOutlet private var singlePrimeButton: UIButton!
    @IBOutlet private var chainPrimeButton: UIButton!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        singlePrimeButton.addGradient()
        chainPrimeButton.addGradient()
    }
}
