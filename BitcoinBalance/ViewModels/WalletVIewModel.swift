//
//  AddressViewModel.swift
//  BitcoinBalance
//
//  Created by Ziong on 2/11/19.
//  Copyright © 2019 Ziong. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import RxCocoa
import RxSwift


class WalletViewModel: ValidateViewModel {
    
    let disposeBag = DisposeBag()
    var address: BehaviorRelay<String> = BehaviorRelay(value: "")
    var wallet: BehaviorRelay<WalletModel?> = BehaviorRelay(value: nil)
    var errorMessage: BehaviorRelay<String> = BehaviorRelay(value: "Invalid Address")
    
    
    func validateWallet() -> Bool {
        guard patternWallet(wallet: address.value) else {
            
            print("Invalid Address: \(address.value)")
            assertionFailure()
            return false
        }
        return true
        
    }
    
    // Checking address validation pattern using regex
    func patternWallet(wallet: String) -> Bool {
        let walletRegEx = "^(bc1|[13])[a-zA-HJ-NP-Z0-9]{25,39}$"
        let walletText = NSPredicate(format: "SELF MATCHES %@", walletRegEx)
        return walletText.evaluate(with: wallet)
        
    }
    
    func fetchWallet(completion : @escaping (DataResponse<WalletModel>) -> ()) {
        AF.request("https://blockexplorer.com/api/addr/\(address.value)").responseDecodable { (response: DataResponse<WalletModel>) in
            guard response.result.isSuccess else {
                print("Error")
                assertionFailure()
                completion(response)
                return
            }
            completion(response)
        }
    }
}
