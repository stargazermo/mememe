//
//  Meme.swift
//  MemeMe
//
//  Created by MoXiafang on 6/5/15.
//  Copyright (c) 2015 MoXiafang. All rights reserved.
//

import UIKit
import Foundation

struct Meme: Equatable {
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImage: UIImage
}

//this function is necessary to enable "find" when deleting from detail view
func == (lhs: Meme, rhs: Meme) -> Bool {
    if lhs.topText == rhs.topText &&
        lhs.bottomText == rhs.bottomText &&
        lhs.originalImage == rhs.originalImage &&
        lhs.memedImage == rhs.memedImage {
            return true
    } else {
        return false
    }
}