import Foundation

// ============================================================
// EXERCISE 3: Structs — Value Types
// ============================================================

struct Transaction {
    let id: String
    let date: Date
    let amount: Double
    var description: String
    let isDebit: Bool
    var isPending: Bool = false
    
    var formattedAmount: String {
        let sign = isDebit ? "-$" : "+$"
        return sign + String(format: "%.2f", abs(amount))
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    mutating func markAsPending() {
        isPending = true
    }
}


// ============================================================
// TODO 3b
// ============================================================

let t1 = Transaction(
    id: "txn_001",
    date: Date(),
    amount: 2500.00,
    description: "Direct Deposit",
    isDebit: false
)

let t2 = Transaction(
    id: "txn_002",
    date: Date(),
    amount: 45.67,
    description: "Starbucks",
    isDebit: true
)

print(t1.formattedAmount, t1.description)
print(t2.formattedAmount, t2.description)


// ============================================================
// TODO 3c: Value Semantics
// ============================================================

var t3 = t1

t3.description = "Modified"

print("t1 description:", t1.description)
print("t3 description:", t3.description)

// t1 remains unchanged because structs are value types.
// Assigning t1 to t3 creates a separate copy.


// ============================================================
// TODO 3d: Mutating Method
// ============================================================

var pendingTransaction = t2

pendingTransaction.markAsPending()

print("t2 is pending:", t2.isPending)
print("pendingTransaction is pending:", pendingTransaction.isPending)


// ============================================================
// EXERCISE 4: Classes — Reference Types
// ============================================================

class BankAccount {
    let id: String
    let accountNumber: String
    var balance: Double
    let owner: String
    
    init(
        id: String,
        accountNumber: String,
        owner: String,
        initialBalance: Double = 0.0
    ) {
        self.id = id
        self.accountNumber = accountNumber
        self.owner = owner
        self.balance = initialBalance
    }
    
    func deposit(amount: Double) {
        if amount > 0 {
            balance += amount
        }
    }
    
    func withdraw(amount: Double) -> Bool {
        if amount > 0 && amount <= balance {
            balance -= amount
            return true
        }
        
        return false
    }
    
    func printSummary() {
        print(
            "Account \(accountNumber) | Owner: \(owner) | Balance: $\(String(format: "%.2f", balance))"
        )
    }
}


// ============================================================
// TODO 4b
// ============================================================

let checking = BankAccount(
    id: "acc_001",
    accountNumber: "1234567890",
    owner: "Jane Smith",
    initialBalance: 1000.00
)

let savings = BankAccount(
    id: "acc_002",
    accountNumber: "0987654321",
    owner: "Jane Smith",
    initialBalance: 5000.00
)

checking.deposit(amount: 500)

let withdrawalSuccessful = checking.withdraw(amount: 200)

print("Withdrawal successful:", withdrawalSuccessful)

checking.printSummary()
savings.printSummary()


// ============================================================
// TODO 4c: Reference Semantics
// ============================================================

let checkingRef = checking

checkingRef.deposit(amount: 500)

print("checking balance:", checking.balance)
print("checkingRef balance:", checkingRef.balance)

// Classes use reference semantics.
// checking and checkingRef refer to the same BankAccount object.
// Therefore, changing one also changes the other.


// ============================================================
// TODO 4d: Inheritance
// ============================================================

class PremiumBankAccount: BankAccount {
    let overdraftLimit: Double
    
    init(
        id: String,
        accountNumber: String,
        owner: String,
        initialBalance: Double = 0.0,
        overdraftLimit: Double
    ) {
        self.overdraftLimit = overdraftLimit
        
        super.init(
            id: id,
            accountNumber: accountNumber,
            owner: owner,
            initialBalance: initialBalance
        )
    }
    
    override func withdraw(amount: Double) -> Bool {
        if amount > 0 && amount <= balance + overdraftLimit {
            balance -= amount
            return true
        }
        
        return false
    }
}


// Test PremiumBankAccount

let premium = PremiumBankAccount(
    id: "acc_003",
    accountNumber: "5555555555",
    owner: "John Smith",
    initialBalance: 100,
    overdraftLimit: 500
)

let firstWithdrawal = premium.withdraw(amount: 400)

print("Withdraw $400:", firstWithdrawal)
premium.printSummary()

let secondWithdrawal = premium.withdraw(amount: 800)

print("Withdraw $800:", secondWithdrawal)
premium.printSummary()


// ============================================================
// EXERCISE 5: Enumerations
// ============================================================

// ============================================================
// TODO 5a
// ============================================================

enum TransactionType: String, CaseIterable {
    case credit
    case debit
    case transfer
    case fee
    
    // ========================================================
    // TODO 5b
    // ========================================================
    
    var displayName: String {
        switch self {
        case .credit:
            return "Credit"
        case .debit:
            return "Debit"
        case .transfer:
            return "Transfer"
        case .fee:
            return "Fee"
        }
    }
}


// ============================================================
// TODO 5c
// ============================================================

enum AccountError {
    case insufficientFunds(available: Double, requested: Double)
    case accountInactive
    case dailyLimitExceeded(limit: Double)
    case invalidAmount
}

func describeError(_ error: AccountError) -> String {
    switch error {
    case let .insufficientFunds(available, requested):
        return "Insufficient funds. Available: $\(String(format: "%.2f", available)), requested: $\(String(format: "%.2f", requested))"
        
    case .accountInactive:
        return "The account is inactive."
        
    case let .dailyLimitExceeded(limit):
        return "Daily transaction limit exceeded. Limit: $\(String(format: "%.2f", limit))"
        
    case .invalidAmount:
        return "The transaction amount is invalid."
    }
}


// Test all four errors

let error1 = AccountError.insufficientFunds(
    available: 100,
    requested: 250
)

let error2 = AccountError.accountInactive

let error3 = AccountError.dailyLimitExceeded(
    limit: 1000
)

let error4 = AccountError.invalidAmount

print(describeError(error1))
print(describeError(error2))
print(describeError(error3))
print(describeError(error4))


// ============================================================
// TODO 5d
// ============================================================

for type in TransactionType.allCases {
    print("\(type.rawValue) → \"\(type.rawValue)\"")
}
