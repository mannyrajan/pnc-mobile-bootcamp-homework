import Foundation


// ============================================================
// EXERCISE 1: Constants and Variables
// ============================================================

let appName = "PNC Mobile"

var loginAttempts = 0
loginAttempts += 1

let accountBalance: Double = 4_250.75

var interestRate: Double = 0.035

print(appName)
print(loginAttempts)
print(accountBalance)
print(interestRate)


// ============================================================
// EXERCISE 2: Working with Strings
// ============================================================

let firstName = "Jane"
let lastName = "Smith"

let fullName = "\(firstName) \(lastName)"

let greeting = "Welcome to PNC Mobile, \(fullName). Your account is active."

let accountNumber = "1234567890"
let maskedAccount = "****\(String(accountNumber.suffix(4)))"

print(fullName)
print(greeting)
print(maskedAccount)
print("Full name character count: \(fullName.count)")


// ============================================================
// EXERCISE 3: Type Safety and Conversion
// ============================================================

let transactionCount = 47
let transactionTotal = 12_309.88

// let average = transactionTotal / transactionCount
// This does not compile because transactionTotal is Double
// and transactionCount is Int.

let averageTransaction = transactionTotal / Double(transactionCount)

let summary = "\(transactionCount) transactions averaging $\(String(format: "%.2f", averageTransaction)) each"

print(summary)

let rawInput = "2500"
let parsedAmount = Int(rawInput)

if let amount = parsedAmount {
    print("Parsed amount: \(amount)")
} else {
    print("Invalid input")
}


// ============================================================
// EXERCISE 4: Control Flow
// ============================================================

// 4a: If / Else If / Else

let balance: Double = 8_500.00

if balance > 25_000 {
    print("Private Banking eligible")
} else if balance > 10_000 {
    print("Preferred client")
} else if balance > 1_000 {
    print("Standard account")
} else {
    print("Low balance alert")
}


// 4b: Switch with pattern matching

let creditScore = 714

switch creditScore {
case 800...850:
    print("Credit rating: Exceptional")
case 740...799:
    print("Credit rating: Very Good")
case 670...739:
    print("Credit rating: Good")
case 580...669:
    print("Credit rating: Fair")
default:
    print("Credit rating: Poor")
}


// 4c: Switch on transaction type

let transactionType = "transfer"

switch transactionType {
case "deposit":
    print("Processing deposit")
case "withdrawal":
    print("Processing withdrawal")
case "transfer":
    print("Processing transfer")
default:
    print("Unknown transaction type: \(transactionType)")
}


// 4d: Guard statement

func processWithdrawal(amount: Double, availableBalance: Double) -> String {
    
    guard amount > 0 else {
        return "Invalid amount"
    }
    
    guard amount <= availableBalance else {
        return "Insufficient funds. Available: $\(String(format: "%.2f", availableBalance))"
    }
    
    return "Withdrawal of $\(String(format: "%.2f", amount)) approved"
}

// Test your function
print(processWithdrawal(amount: -50, availableBalance: 1000))
print(processWithdrawal(amount: 2000, availableBalance: 1000))
print(processWithdrawal(amount: 500, availableBalance: 1000))


// ============================================================
// EXERCISE 5: Loops and Collections
// ============================================================

// 5a: Multiplication table for 7

for num in 1...10 {
    print("7 x \(num) = \(7 * num)")
}


// 5b: Even numbers from 1 through 20

for num in 1...20 where num % 2 == 0 {
    print(num)
}


// 5c: Array basics

let accounts = ["Checking", "Savings", "Investment", "Credit Card"]

for account in accounts {
    print("• \(account)")
}


// 5d: Array with enumerated()

for (index, name) in accounts.enumerated() {
    print("\(index + 1). \(name)")
}


// 5e: While loop

var attempts = 0
var connected = false

while !connected && attempts < 3 {
    attempts += 1
    
    print("Connection attempt \(attempts)...")
    
    if attempts == 3 {
        connected = true
        print("Connected.")
    }
}
