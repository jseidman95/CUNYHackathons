//
//  MainTabViewController.swift
//  CUNYHackathons
//
//  Created by Jesse Seidman on 11/29/17.
//  Copyright © 2017 Jesse Seidman. All rights reserved.
//

import UIKit

/*
 * This class was created just for the extension below that changes the height of the tab bar
 */
class MainTabViewController: UITabBarController {}

extension UITabBar
{
    //set the height of the tab bar to consistently be 70
    override open func sizeThatFits(_ size: CGSize) -> CGSize
    {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 70
        return sizeThatFits
    }
}
