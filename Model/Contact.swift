//
//  Contact.swift
//  Chat App For HCI
//
//  Created by Sudeep Raj on 6/25/18.
//  Copyright © 2018 Sudeep Raj. All rights reserved.
//

import Foundation

class Contact {
    private var _name = "";
    private var _id = "";
    
    init(id: String, name: String) {
        _id = id;
        _name = name;
    }
    
    var name: String {
        get {
            return _name;
        }
    }
    
    var id: String {
        return _id;     //also a getter
    }
    
    
}
