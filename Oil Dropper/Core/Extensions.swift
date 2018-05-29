//
//  ViewControllerExtension.swift
//  Oil Dropper
//
//  Created by Alexander Lester on 3/22/18.
//  Copyright © 2018 Designs By LAGB. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func alert(Title: String, Message: String?)
    {
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
