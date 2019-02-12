//
//  ViewController.swift
//  BitcoinBalance
//
//  Created by Ziong on 2/11/19.
//  Copyright © 2019 Ziong. All rights reserved.
//

import UIKit
import Alamofire
import RxCocoa
import RxSwift

class WalletController: UIViewController {

    let viewModel = WalletViewModel()
    let disposeBag = DisposeBag()
    let mainView = MainView(frame: UIScreen.main.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = mainView
        viewModelBinding()
    }
    
    
    func viewModelBinding() {
        mainView.addressTextField.rx.text.orEmpty
            .bind(to: viewModel.address)
            .disposed(by: disposeBag)
        
        mainView.checkBalanceButton.rx.tap.subscribe(onNext:{ [unowned self] _ in
            if self.viewModel.validateWallet() {
                self.viewModel.fetchWallet(completion: { (response: DataResponse<WalletModel>) in
                    guard response.result.isSuccess else {
                        self.showAlertForTitle(title: self.viewModel.errorMessage.value)
                        return
                    }
                    self.viewModel.wallet.accept(response.value)
                    if let wallet = self.viewModel.wallet.value {
                        self.showAlertForTitle(title: "Balance: \(wallet.balance)\nTotal Received: \(wallet.totalReceived)\nTotal Sent: \(wallet.totalSent)")
                    }
                })
            } else {
                self.showAlertForTitle(title: self.viewModel.errorMessage.value)
            }
        }).disposed(by: disposeBag)
        
    }
    
    func showAlertForTitle(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.view.endEditing(true)
        self.present(alert, animated: true, completion: nil)
    }
}

