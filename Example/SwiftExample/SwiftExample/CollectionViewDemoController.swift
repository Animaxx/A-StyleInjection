//
//  CollectionViewDemoController.swift
//  SwiftExample
//
//  Created by Animax Deng on 5/31/20.
//  Copyright © 2020 Animax. All rights reserved.
//

import UIKit
import A_StyleInjection

class DemoCollectionCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var input: UITextField!
}

class CollectionViewDemoController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 500
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! DemoCollectionCell
        
        cell.label.text = "\(indexPath.row)"
        
        return cell
    }

    @IBAction func onClickSetStyle(_ sender: Any) {
        A_StyleManager.shared().setupStyleSourceRepository(StylePlistProvider("StyleSheet"))
    }
}
