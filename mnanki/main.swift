//
//  main.swift
//  mnanki
//
//  Created by Aiden Liu on 2020/2/13.
//  Copyright © 2020 Aiden Liu. All rights reserved.
//

import Foundation
if (CommandLine.argc>1){
        switch CommandLine.arguments[1] {
        case "link":
            print("link")
            link();
        case "cell":
            print("cell")
            cell();
        default:
            print("Unknown Agrument")
        }
}else{            print("Missing Agrument")}


