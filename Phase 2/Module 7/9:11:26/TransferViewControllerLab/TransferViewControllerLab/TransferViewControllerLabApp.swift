import UIKit

class BEFORE_ExistingMassiveViewController: UIViewController {
    var fromAccount: Account!
    var toAccount: Account!
    @IBOutlet weak var amountField: UITextField!

    @IBAction func transferButtonTapped() {
        guard let text = amountField.text,
              let amount = Decimal(string: text) else {
            showAlert(message: "Please enter a valid amount")
            return
        }

        guard amount > 0 else {
            showAlert(message: "Amount must be greater than zero")
            return
        }

        guard fromAccount.balance >= amount else {
            showAlert(message: "Insufficient funds")
            return
        }

        var request = URLRequest(
            url: URL(string: "https://api.pncmobile.com/transfer")!
        )

        request.httpMethod = "POST"

        request.httpBody = try? JSONEncoder().encode([
            "from": fromAccount.id.uuidString,
            "to": toAccount.id.uuidString,
            "amount": "\(amount)"
        ])

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            DispatchQueue.main.async {
                if error != nil {
                    self?.showAlert(message: "Transfer failed. Please try again.")
                } else {
                    self?.navigationController?.popToRootViewController(animated: true)
                }
            }
        }.resume()
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: "Transfer",
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(title: "OK", style: .default)
        )

        present(alert, animated: true)
    }
}

// MARK: - Model

struct Account: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let maskedNumber: String
    let balance: Decimal
}

// MARK: - AccountsRepository

protocol AccountsRepository {
    func transfer(
        amount: Decimal,
        from: Account,
        to: Account
    ) async throws
}

// MARK: - TransferEligibilityService

enum TransferError: Error, Equatable {
    case invalidAmount
    case insufficientFunds
}

struct TransferEligibilityService {

    func canTransfer(
        amount: Decimal,
        from account: Account
    ) -> Result<Void, TransferError> {

        guard amount > 0 else {
            return .failure(.invalidAmount)
        }

        guard account.balance >= amount else {
            return .failure(.insufficientFunds)
        }

        return .success(())
    }
}

// MARK: - TransferViewModel

final class TransferViewModel {

    private let repository: AccountsRepository
    private let eligibilityService: TransferEligibilityService

    var onError: ((TransferError) -> Void)?
    var onSuccess: (() -> Void)?

    init(
        repository: AccountsRepository,
        eligibilityService: TransferEligibilityService = TransferEligibilityService()
    ) {
        self.repository = repository
        self.eligibilityService = eligibilityService
    }

    func attemptTransfer(
        amount: Decimal,
        from: Account,
        to: Account
    ) async {

        let result = eligibilityService.canTransfer(
            amount: amount,
            from: from
        )

        switch result {

        case .failure(let error):
            onError?(error)

        case .success:

            do {
                try await repository.transfer(
                    amount: amount,
                    from: from,
                    to: to
                )

                onSuccess?()

            } catch {
                onError?(.insufficientFunds)
            }
        }
    }
}
```

