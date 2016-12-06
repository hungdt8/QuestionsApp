//
//  LoadMoreFooterView.swift
//  FurusatoWalking
//
//  Created by Hung Le Duc on 10/13/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

import UIKit

class LoadMoreFooterView: UIView {

    class func instanceFromNib() -> LoadMoreFooterView {
        return UINib(nibName: "LoadMoreFooterView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! LoadMoreFooterView
    }

}
