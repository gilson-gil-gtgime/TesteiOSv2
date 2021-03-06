//
//  AccountPresenter.swift
//  TesteiOSv2
//
//  Created by Gilson Gil on 16/02/19.
//  Copyright (c) 2019 Gilson Gil. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol AccountPresentationLogic {
  func presentAccountDetails(response: Account.ShowAccountDetails.Response)
  func presentStatements(response: Account.FetchStatements.Response)
}

final class AccountPresenter: AccountPresentationLogic {
  weak var viewController: AccountDisplayLogic?

  func presentAccountDetails(response: Account.ShowAccountDetails.Response) {
    let userAccount = response.userAccount
    let name = userAccount.name
    let account = "\(userAccount.bankAccount) / \(userAccount.agency)"
    let balance = String(format: "R$%.2f", arguments: [userAccount.balance])

    let accountDetails = Account.AccountDetails(name: name, account: account, balance: balance)
    let viewModel = Account.ShowAccountDetails.ViewModel(accountDetails: accountDetails)
    viewController?.displayAccountDetails(viewModel: viewModel)
  }

  func presentStatements(response: Account.FetchStatements.Response) {
    let displayedStatements: [Account.FetchStatements.ViewModel.DisplayedStatement] = response.statements.compactMap {
      let title = $0.title
      let description = $0.description
      let date = DateFormatter.displayDateFormatter.string(from: $0.date)
      let value = NumberFormatter.currencyFormatter.string(from: NSNumber(value: $0.value)) ?? "\($0.value)"
      return Account.FetchStatements.ViewModel.DisplayedStatement(title: title,
                                                                  description: description,
                                                                  date: date,
                                                                  value: value)
    }
    let viewModel = Account.FetchStatements.ViewModel(displayedStatements: displayedStatements)
    viewController?.displayStatements(viewModel: viewModel)
  }
}
