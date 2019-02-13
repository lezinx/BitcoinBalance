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
    let isSuccess: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    
    func validateWallet() -> Bool {
        guard patternWallet(wallet: address.value), validateWalletCheckSum(wallet: address.value) else {
            print("Invalid Address: \(address.value)")
            isSuccess.accept(false)
            return false
            
        }
        isSuccess.accept(true)
        return true
        
    }
    
    init() {
        _ = isSuccess.asObservable().subscribe { (isSuccess) in
            guard let isSuccess = isSuccess.element else {return }
            if isSuccess {
                self.fetchWallet(completion: { (response: DataResponse<WalletModel>) in
                 self.wallet.accept(response.value)
                })
            }
        }.disposed(by: disposeBag)
    }
    
    
    func validateWalletCheckSum(wallet: String) -> Bool {
        // Decoding into 25 bytes
        let decodedWalletByte: [UInt8] = wallet.bytesFromBase58()
        if decodedWalletByte.count != 25 {
            return false
        }
        
        let netwokrId = [decodedWalletByte[0]]
        // 20 bytes
        let privateKeyHash = decodedWalletByte[1...20]
        // 4 bytes
        // Wallet's checksum that we take from address
        let checkSum = decodedWalletByte[21...]
        // Calculating wallet's checksum
        let networkIdData = Data(bytes: netwokrId)
        let privateKeyHashData = Data(bytes: privateKeyHash)
        // Hashing data through SHA256 twice
        let hashing = (networkIdData + privateKeyHashData).sha256().sha256()
        let calculatedCheckSum = [UInt8](hashing)[...3]
        
        return checkSum == calculatedCheckSum ? true : false
    }
    
    // Checking address validation pattern using regex
    func patternWallet(wallet: String) -> Bool {
        let walletRegEx = "^(bc1|[13])[a-zA-HJ-NP-Z0-9]{25,39}$"
        let walletText = NSPredicate(format: "SELF MATCHES %@", walletRegEx)
        return walletText.evaluate(with: wallet)
        
    }
    
    deinit {
        print("bye")
    }
    
    func fetchWallet(completion : @escaping (DataResponse<WalletModel>) -> ()) {
        AF.request("https://blockexplorer.com/api/addr/\(address.value)").responseDecodable { (response: DataResponse<WalletModel>) in
            guard response.result.isSuccess else {
                print("Error \(response.result.error.debugDescription)")
                completion(response)
                return
            }
            completion(response)
        }
    }
}
