//
//  ProductsCollectionViewCell.swift
//  SuperpositionIV
//
//  Created by Kemi Airewele on 3/1/20.
//  Copyright © 2020 Kemi Airewele. All rights reserved.
//

import Foundation
import UIKit

class ProductsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productType: UILabel!
    @IBOutlet weak var addProductButton: RoundButton!
}

class UserProductsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productType: UILabel!
}
