import XCTest
@testable import PNCMobileApp


final class FakeAccountsRepository: AccountsRepository {

    private(set) var transferCallCount = 0

    var shouldThrow = false

    func transfer(
        amount: Decimal,
        from: Account,
        to: Account
    ) async throws {

        transferCallCount += 1

        if shouldThrow {
            throw TransferError.insufficientFunds
        }
    }
}

// MARK: - Tests

final class TransferViewModelTests: XCTestCase {

    func makeAccounts(
        balance: Decimal
    ) -> (from: Account, to: Account) {

        let from = Account(
            name: "Checking",
            maskedNumber: "•••• 4471",
            balance: balance
        )

        let to = Account(
            name: "Savings",
            maskedNumber: "•••• 9902",
            balance: 0
        )

        return (from, to)
    }

    func test_transferBelowBalance_succeeds() async {

        let fakeRepo = FakeAccountsRepository()

        let viewModel = TransferViewModel(
            repository: fakeRepo
        )

        let (from, to) = makeAccounts(
            balance: 500
        )

        var succeeded = false

        viewModel.onSuccess = {
            succeeded = true
        }

        await viewModel.attemptTransfer(
            amount: 100,
            from: from,
            to: to
        )

        XCTAssertTrue(
            succeeded,
            "A transfer under the available balance should succeed."
        )

        XCTAssertEqual(
            fakeRepo.transferCallCount,
            1,
            "The repository should be called exactly once."
        )
    }

    func test_transferAboveBalance_failsWithoutCallingRepository() async {

        let fakeRepo = FakeAccountsRepository()

        let viewModel = TransferViewModel(
            repository: fakeRepo
        )

        let (from, to) = makeAccounts(
            balance: 50
        )

        var receivedError: TransferError?

        viewModel.onError = {
            receivedError = $0
        }

        await viewModel.attemptTransfer(
            amount: 100,
            from: from,
            to: to
        )

        XCTAssertEqual(
            receivedError,
            .insufficientFunds
        )

        XCTAssertEqual(
            fakeRepo.transferCallCount,
            0,
            "Eligibility should be checked BEFORE the repository is ever called."
        )
    }

    func test_zeroOrNegativeAmount_isRejected() async {

        let fakeRepo = FakeAccountsRepository()

        let viewModel = TransferViewModel(
            repository: fakeRepo
        )

        let (from, to) = makeAccounts(
            balance: 500
        )

        var receivedError: TransferError?

        viewModel.onError = {
            receivedError = $0
        }

        await viewModel.attemptTransfer(
            amount: 0,
            from: from,
            to: to
        )

        XCTAssertEqual(
            receivedError,
            .invalidAmount
        )
    }
}
```

