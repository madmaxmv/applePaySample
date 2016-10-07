//
//  ViewController.swift
//  ApplePaySample
//
//  Created by Максим on 07.10.16.
//  Copyright © 2016 Personal. All rights reserved.
//

import PassKit
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var buyWithApplePay: PKPaymentButton!
    
    let SupportedPaymentNetworks = [PKPaymentNetwork.visa, PKPaymentNetwork.masterCard]
    let ApplePayMerchantID = "merchant.applePaySampleMerchantID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pay() {
        let request = PKPaymentRequest()
        request.merchantIdentifier = ApplePayMerchantID
        request.supportedNetworks = SupportedPaymentNetworks
        request.merchantCapabilities = PKMerchantCapability.capability3DS
        request.countryCode = "RU"
        request.currencyCode = "RUB"
        
        request.paymentSummaryItems = [
            PKPaymentSummaryItem(label: "Something", amount: 0.2) // 20 коп.
        ]
        
        let applePayController = PKPaymentAuthorizationViewController(paymentRequest: request)
        applePayController.delegate = self
        
        self.present(applePayController, animated: true, completion: nil)
    }
    
}

extension ViewController: PKPaymentAuthorizationViewControllerDelegate {
    @available(iOS 8.0, *)
    public func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {
        completion(PKPaymentAuthorizationStatus.success)
        print(payment.token.transactionIdentifier)
        print(payment.token.paymentData)
        do {
            let dataJSON = try JSONSerialization.jsonObject(with: payment.token.paymentData, options: [.mutableLeaves, .allowFragments, .mutableContainers])
            print(dataJSON)
        } catch {
            print("Error")
        }
    }
    
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
