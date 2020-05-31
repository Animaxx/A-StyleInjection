//
//  StyleChangeDemoController.swift
//  SwiftExample
//
//  Created by Animax Deng on 5/31/20.
//  Copyright © 2020 Animax. All rights reserved.
//

import UIKit
import A_StyleInjection

class StyleChangeDemoController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func onClick(_ sender: Any) {
        A_StyleManager.shared().setupStyleSourceRepository(StylePlistProvider("NewStyleSheet"))
    }
    
}
