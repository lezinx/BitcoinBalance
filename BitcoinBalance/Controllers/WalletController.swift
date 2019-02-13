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
    
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var checkBalanceButton: UIButton!
    var viewModel = WalletViewModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModelBinding()
    }
    
    func viewModelBinding() {
        
        addressTextField.rx.text.orEmpty
            .bind(to: viewModel.address)
            .disposed(by: disposeBag)
        
        checkBalanceButton.rx.tap.subscribe { _ in
            _ = self.viewModel.validateWallet()
            }.disposed(by: disposeBag)
        
        _ = viewModel.isSuccess.asObservable().subscribe{ _ in
            if self.viewModel.isSuccess.value == false {
                 self.showAlertForTitle(title: self.viewModel.errorMessage.value)
            }
        }.disposed(by: disposeBag)
        
        _ = viewModel.wallet.asObservable().subscribe { _ in
            guard let wallet = self.viewModel.wallet.value else {return}
        
                self.showAlertForTitle(title: "Balance: \(wallet.balance)\nTotal Received: \(wallet.totalReceived)\nTotal Sent: \(wallet.totalSent)")
         
            }.disposed(by: disposeBag)
        
    }

    func showAlertForTitle(title: String) {
        let alert = UIAlertController(title: "BTC", message: title, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.view.endEditing(true)
        self.present(alert, animated: true, completion: nil)
    }
}

