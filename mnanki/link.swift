//
//  main.swift
//  link
//
//  Created by Aiden Liu on 2019/9/27.
//  Copyright © 2019 Aiden Liu. All rights reserved.
//

import Foundation
import AppKit
func link(){
let pb = NSPasteboard.general
if let text = pb.string(forType: .string)
{
    let pattern = "^marginnote3app://note/"
    let pathRange = text.range(of: pattern, options:.regularExpression)
    if pathRange != nil
    {
        if let url = URL(string: text) {
        let output=NSAttributedString(string: "##", attributes: .some([NSAttributedString.Key.link:url]))
        pb.clearContents()
        pb.writeObjects([output])
        print("1")
        }
    }
}
else {print("0")}
}
