//
//  ValidateViewModel.swift
//  BitcoinBalance
//
//  Created by Ziong on 2/12/19.
//  Copyright © 2019 Ziong. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


protocol ValidateViewModel {
    
    var address: BehaviorRelay<String> {get set}
    var errorMessage: BehaviorRelay<String> {get set }
    
    func validateWallet() -> Bool
}
