//
//  GrogJSON.swift
//  Grog 2500
//
//  Created by John Pavley on 5/4/17.
//  Copyright © 2017 John Pavley. All rights reserved.
//

import Foundation

func initLocalStory(fileName: String) -> [GrogStorybook]? {
    do {
        if let file = Bundle.main.url(forResource: fileName, withExtension: "json") {
            let data = try Data(contentsOf: file)
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            if let object = json as? [String: Any] {
                // json is a dictionary
                print(object)
                return [GrogStorybook]()
            } else if let object = json as? [Any] {
                // json is an array
                print(object)
                return [GrogStorybook]()
            } else {
                print("JSON is invalid")
            }
        } else {
            print("no file")
        }
    } catch {
        print(error.localizedDescription)
    }
    return nil
}

