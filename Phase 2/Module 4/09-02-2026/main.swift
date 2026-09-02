// ============================================================
// MODULE 4: Swift Programming Fundamentals
// Day 3 Exercises — Protocols, ARC, Optionals, Error Handling
// Enterprise Mobile Application Development Bootcamp
// ============================================================

import Foundation

// ============================================================
// PART A: PROTOCOLS
// ============================================================

// ============================================================
// EXERCISE 1: Defining and Adopting Protocols
// ============================================================

// TODO 1a: Define Displayable protocol

protocol Displayable {
    var displayDescription: String { get }
    func printDetails()
}

// TODO 1b: Default implementation

extension Displayable {
    func printDetails() {
        print(displayDescription)
    }
}

// TODO 1c: Transaction conforming to Displayable

struct Transaction: Displayable {
    let date: String
    let description: String
    let amount: Double

    var formattedAmount: String {
        String(format: "%@%.2f", amount >= 0 ? "+" : "-", abs(amount))
    }

    var displayDescription: String {
        "\(date) \(description): \(formattedAmount)"
    }
}

// Test Transaction
let transaction1 = Transaction(
    date: "Jan 15, 2024",
    description: "Direct Deposit",
    amount: 2500.00
)

let transaction2 = Transaction(
    date: "Jan 16, 2024",
    description: "Coffee Shop",
    amount: -5.75
)

transaction1.printDetails()

// TODO 1d: Protocol as a type

func printAll(items: [Displayable]) {
    for item in items {
        item.printDetails()
    }
}

let transactions: [Displayable] = [
    transaction1,
    transaction2
]

printAll(items: transactions)


// ============================================================
// EXERCISE 2: Protocol-Oriented Design with Dependency Injection
// ============================================================

// TODO 2a: AccountDataSource protocol

protocol AccountDataSource {
    func fetchBalance(for accountId: String) -> Double
    func fetchTransactionCount(for accountId: String) -> Int
}

// TODO 2b: MockAccountDataSource

struct MockAccountDataSource: AccountDataSource {
    
    func fetchBalance(for accountId: String) -> Double {
        return 4_250.75
    }
    
    func fetchTransactionCount(for accountId: String) -> Int {
        return 47
    }
}

// TODO 2c: LiveAccountDataSource

struct LiveAccountDataSource: AccountDataSource {
    
    func fetchBalance(for accountId: String) -> Double {
        return Double.random(in: 100...50_000)
    }
    
    func fetchTransactionCount(for accountId: String) -> Int {
        return Int.random(in: 1...500)
    }
}

// TODO 2d: AccountDashboard

class AccountDashboard {
    
    let dataSource: AccountDataSource
    
    init(dataSource: AccountDataSource) {
        self.dataSource = dataSource
    }
    
    func showSummary(for accountId: String) {
        let balance = dataSource.fetchBalance(for: accountId)
        let transactionCount = dataSource.fetchTransactionCount(for: accountId)
        
        print(
            String(
                format: "Account %@: Balance $%.2f | Transactions: %d",
                accountId,
                balance,
                transactionCount
            )
        )
    }
}

// Test MockAccountDataSource
let mockDashboard = AccountDashboard(
    dataSource: MockAccountDataSource()
)

mockDashboard.showSummary(for: "ACC-001")

// Test LiveAccountDataSource
let liveDashboard = AccountDashboard(
    dataSource: LiveAccountDataSource()
)

liveDashboard.showSummary(for: "ACC-002")


// ============================================================
// PART B: AUTOMATIC REFERENCE COUNTING
// ============================================================

// ============================================================
// EXERCISE 3a: Retain Cycles and weak References
// ============================================================

class Customer {
    
    let name: String
    var account: Account?
    
    init(name: String) {
        self.name = name
    }
    
    deinit {
        print("Customer \(name) deallocated")
    }
}

class Account {
    
    let number: String
    
    // weak breaks the retain cycle
    weak var owner: Customer?
    
    init(number: String) {
        self.number = number
    }
    
    deinit {
        print("Account \(number) deallocated")
    }
}

do {
    let customer = Customer(name: "Jane")
    let account = Account(number: "ACC-001")
    
    customer.account = account
    account.owner = customer
}

// Both deinit messages should appear because Account.owner is weak.


// ============================================================
// EXERCISE 3b: Capture lists in closures
// ============================================================

class TransactionProcessor {
    
    let accountId: String
    var onComplete: (() -> Void)?
    
    init(accountId: String) {
        self.accountId = accountId
    }
    
    deinit {
        print("TransactionProcessor \(accountId) deallocated")
    }
    
    func startProcessing() {
        
        onComplete = { [weak self] in
            
            guard let self = self else {
                return
            }
            
            print("Processing complete for \(self.accountId)")
        }
    }
    
    func complete() {
        onComplete?()
    }
}

// Test TransactionProcessor

do {
    let processor = TransactionProcessor(accountId: "ACC-001")
    
    processor.startProcessing()
    processor.complete()
}


// ============================================================
// PART C: OPTIONALS — DEEP DIVE
// ============================================================

// ============================================================
// EXERCISE 4a: Optional chaining
// ============================================================

struct Address {
    let street: String
    let city: String
    let zip: String?
}

struct UserProfile {
    let name: String
    var address: Address?
}

let user = UserProfile(
    name: "Jane Smith",
    address: Address(
        street: "123 Main St",
        city: "Columbus",
        zip: "43001"
    )
)

let userNoAddress = UserProfile(
    name: "Bob",
    address: nil
)

// Optional chaining + nil coalescing

print("ZIP: \(user.address?.zip ?? "No ZIP available")")

print(
    "ZIP: \(userNoAddress.address?.zip ?? "No ZIP available")"
)


// ============================================================
// EXERCISE 4b: if let with multiple bindings
// ============================================================

func transfer(
    from sourceId: String?,
    to destId: String?,
    amount: Double?
) {
    
    if let sourceId = sourceId,
       let destId = destId,
       let amount = amount,
       amount > 0 {
        
        print(
            String(
                format: "Transfer $%.2f from %@ to %@ approved",
                amount,
                sourceId,
                destId
            )
        )
        
    } else {
        print("Transfer failed: missing required fields")
    }
}

transfer(
    from: "ACC-001",
    to: "ACC-002",
    amount: 500.0
)

transfer(
    from: nil,
    to: "ACC-002",
    amount: 500.0
)

transfer(
    from: "ACC-001",
    to: "ACC-002",
    amount: nil
)


// ============================================================
// EXERCISE 4c: Optional map and flatMap
// ============================================================

let rawBalanceString: String? = "4250.75"
let rawInvalidString: String? = "abc"
let nilString: String? = nil

let formattedBalance = rawBalanceString
    .flatMap { Double($0) }
    .map { String(format: "$%.2f", $0) }

let formattedInvalidBalance = rawInvalidString
    .flatMap { Double($0) }
    .map { String(format: "$%.2f", $0) }

let formattedNilBalance = nilString
    .flatMap { Double($0) }
    .map { String(format: "$%.2f", $0) }

print(
    "rawBalanceString → \(String(describing: formattedBalance))"
)

print(
    "rawInvalidString → \(String(describing: formattedInvalidBalance))"
)

print(
    "nilString → \(String(describing: formattedNilBalance))"
)


// ============================================================
// EXERCISE 4d: Force unwrap — when and ONLY when it's safe
// ============================================================

// Safe because the URL is a literal written by the developer.

let apiURL = URL(string: "https://api.pnc.com/v1")!

print("API URL: \(apiURL)")

// NEVER force unwrap a URL created from user input:
//
// let userURL = URL(string: userInputString)!
//
// User input may not be a valid URL. If URL(string:) returns nil,
// the force unwrap would cause the application to crash.
//
// Instead, safely unwrap it:
//
// if let userURL = URL(string: userInputString) {
//     // Use userURL
// } else {
//     // Handle invalid URL
// }


// ============================================================
// PART D: TYPED ERROR HANDLING
// ============================================================

// ============================================================
// EXERCISE 5a: Define TransferError
// ============================================================

enum TransferError: LocalizedError {
    
    case invalidAmount
    
    case insufficientFunds(
        available: Double
    )
    
    case accountNotFound(
        id: String
    )
    
    case dailyLimitExceeded(
        limit: Double,
        attempted: Double
    )
    
    case networkUnavailable
    
    
    var errorDescription: String? {
        
        switch self {
            
        case .invalidAmount:
            return "Transfer amount must be greater than $0.00."
            
        case .insufficientFunds(let available):
            return String(
                format: "Insufficient funds. Available balance: $%.2f.",
                available
            )
            
        case .accountNotFound(let id):
            return "Account not found: \(id)."
            
        case .dailyLimitExceeded(let limit, let attempted):
            return String(
                format: "Daily transfer limit of $%.2f exceeded. Attempted: $%.2f.",
                limit,
                attempted
            )
            
        case .networkUnavailable:
            return "Network unavailable. Please try again later."
        }
    }
}


// ============================================================
// EXERCISE 5b: Throwing function
// ============================================================

func executeTransfer(
    amount: Double,
    fromBalance: Double,
    toAccountId: String,
    dailyUsed: Double,
    dailyLimit: Double
) throws -> String {
    
    // Invalid amount
    if amount <= 0 {
        throw TransferError.invalidAmount
    }
    
    // Account not found
    if toAccountId.isEmpty {
        throw TransferError.accountNotFound(
            id: toAccountId
        )
    }
    
    // Insufficient funds
    if amount > fromBalance {
        throw TransferError.insufficientFunds(
            available: fromBalance
        )
    }
    
    // Daily limit exceeded
    if dailyUsed + amount > dailyLimit {
        throw TransferError.dailyLimitExceeded(
            limit: dailyLimit,
            attempted: dailyUsed + amount
        )
    }
    
    // Simulated network failure
    if toAccountId == "ERR_NET" {
        throw TransferError.networkUnavailable
    }
    
    return String(
        format: "Transfer of $%.2f to account %@ complete",
        amount,
        toAccountId
    )
}


// ============================================================
// EXERCISE 5c: Handle all error cases
// ============================================================

func testTransfer(
    amount: Double,
    fromBalance: Double,
    toAccountId: String,
    dailyUsed: Double,
    dailyLimit: Double
) {
    
    do {
        
        let result = try executeTransfer(
            amount: amount,
            fromBalance: fromBalance,
            toAccountId: toAccountId,
            dailyUsed: dailyUsed,
            dailyLimit: dailyLimit
        )
        
        print(result)
        
    } catch let error as TransferError {
        
        switch error {
            
        case .invalidAmount:
            print(error.localizedDescription)
            
        case .insufficientFunds:
            print(error.localizedDescription)
            
        case .accountNotFound:
            print(error.localizedDescription)
            
        case .dailyLimitExceeded:
            print(error.localizedDescription)
            
        case .networkUnavailable:
            print(error.localizedDescription)
        }
        
    } catch {
        print("Unexpected error: \(error.localizedDescription)")
    }
}


// Success
testTransfer(
    amount: 500.00,
    fromBalance: 2_000.00,
    toAccountId: "ACC-002",
    dailyUsed: 1_000.00,
    dailyLimit: 5_000.00
)

// Invalid amount
testTransfer(
    amount: -100.00,
    fromBalance: 2_000.00,
    toAccountId: "ACC-002",
    dailyUsed: 1_000.00,
    dailyLimit: 5_000.00
)

// Insufficient funds
testTransfer(
    amount: 3_000.00,
    fromBalance: 2_000.00,
    toAccountId: "ACC-002",
    dailyUsed: 1_000.00,
    dailyLimit: 5_000.00
)

// Account not found
testTransfer(
    amount: 500.00,
    fromBalance: 2_000.00,
    toAccountId: "",
    dailyUsed: 1_000.00,
    dailyLimit: 5_000.00
)

// Daily limit exceeded
testTransfer(
    amount: 1_500.00,
    fromBalance: 2_000.00,
    toAccountId: "ACC-002",
    dailyUsed: 4_000.00,
    dailyLimit: 5_000.00
)

// Network unavailable
testTransfer(
    amount: 500.00,
    fromBalance: 2_000.00,
    toAccountId: "ERR_NET",
    dailyUsed: 1_000.00,
    dailyLimit: 5_000.00
)


// ============================================================
// EXERCISE 5d: try?
// ============================================================

// Failure becomes nil

let failedTransfer = try? executeTransfer(
    amount: -100,
    fromBalance: 2_000,
    toAccountId: "ACC-002",
    dailyUsed: 1_000,
    dailyLimit: 5_000
)

print(
    failedTransfer ?? "Transfer failed"
)


// Success becomes an optional String

let successfulTransfer = try? executeTransfer(
    amount: 250,
    fromBalance: 2_000,
    toAccountId: "ACC-003",
    dailyUsed: 1_000,
    dailyLimit: 5_000
)

print(
    successfulTransfer ?? "Transfer failed"
)


// ============================================================
// PART E: GENERICS — INTRODUCTION
// ============================================================

// ============================================================
// EXERCISE 6a: Generic printFirst
// ============================================================

func printFirst<T>(_ items: [T]) {
    
    if let first = items.first {
        print(first)
    } else {
        print("Array is empty")
    }
}

printFirst([1, 2, 3])

printFirst([
    "Apple",
    "PNC",
    "Swift"
])

printFirst([
    3.14,
    2.71,
    1.61
])

printFirst([Int]())


// ============================================================
// EXERCISE 6b: Generic Stack
// ============================================================

struct Stack<Element> {
    
    private var items: [Element] = []
    
    mutating func push(_ item: Element) {
        items.append(item)
    }
    
    mutating func pop() -> Element? {
        return items.popLast()
    }
    
    var top: Element? {
        return items.last
    }
    
    var isEmpty: Bool {
        return items.isEmpty
    }
    
    var count: Int {
        return items.count
    }
}


// Test Stack<Double>

var transactionAmounts = Stack<Double>()

transactionAmounts.push(250.00)
transactionAmounts.push(45.67)
transactionAmounts.push(1200.00)

let poppedAmount = transactionAmounts.pop()

print(
    String(
        format: "Popped: %.2f",
        poppedAmount ?? 0
    )
)

print(
    String(
        format: "Top: %.2f",
        transactionAmounts.top ?? 0
    )
)

print("Count: \(transactionAmounts.count)")

print("Is empty: \(transactionAmounts.isEmpty)")


// ============================================================
// EXERCISE 6c: Generic function with Comparable constraint
// ============================================================

func findLargest<T: Comparable>(
    _ items: [T]
) -> T? {
    
    return items.max()
}


// Test Int

print(
    "Largest Int: \(findLargest([10, 42, 7, 25]) ?? 0)"
)

// Test Double

print(
    "Largest Double: \(findLargest([2.5, 9.8, 4.1, 7.3]) ?? 0.0)"
)

// Test String

print(
    "Largest String: \(findLargest(["Apple", "PNC", "Swift"]) ?? "None")"
)

// Test empty array

print(
    "Largest empty array: \(String(describing: findLargest([Int]())) )"
)


// ============================================================
// FINAL REFLECTION
// ============================================================

// 1. What is a retain cycle? Draw it. How do you break one?
//
// A retain cycle happens when two objects strongly reference each other.
//
// Customer ----strong----> Account
// Customer <---strong----- Account
//
// Neither object can be deallocated because each keeps the other alive.
//
// A weak reference breaks the cycle:
//
// Customer ----strong----> Account
// Customer <-----weak----- Account
//
// In this exercise, Account.owner is weak.
//
//
// 2. What is the difference between try, try?, and try!?
//
// try:
// Executes a throwing function and requires do-catch handling or
// passes the error to another throwing function.
//
// try?:
// Converts a throwing operation into an optional.
// Success gives an optional value and failure gives nil.
//
// try!:
// Forces a throwing operation to succeed.
// If the function throws an error, the application crashes.
// It should only be used when failure is known to be impossible.
//
//
// 3. When would you use a protocol instead of a base class?
//
// Use a protocol when you want to define a contract that can be
// adopted by different and potentially unrelated types.
//
// Protocols are especially useful for dependency injection,
// testing, composition, and avoiding unnecessary inheritance.
//
//
// 4. What constraint do you add to a generic type parameter when
//    you need to compare or sort elements?
//
// Use the Comparable constraint:
//
// func findLargest<T: Comparable>(_ items: [T]) -> T?
//
// Comparable allows values to be compared using operators such as
// < and > and allows functions such as max() to be used.
//
// ============================================================
// END OF DAY 3 EXERCISES
// ============================================================