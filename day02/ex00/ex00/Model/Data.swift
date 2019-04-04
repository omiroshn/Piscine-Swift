//
//  Data.swift
//  ex00
//
//  Created by Lesha Miroshnik on 4/4/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import Foundation

struct Data {
    let name: String
    let description: String
    let deathTime: String

    static func getNames() -> [Data] {
        let d1 = Data(name: "Light Yagami", description: "Died as Ryuk himself took his life by writing his name in his Death Note just before Light suffered from a bullet wound", deathTime: "25 june")
        let d2 = Data(name: "L", description: "Kira used this to make L as a threat to Misa. And when a shinigami write to protect a people, they disintegrated into a dust. They dies. He dies because light always wanted him dead so he used rem to kill l and rem wrote the watari and l name his death note after that he dies.", deathTime: "5 may")
        let d3 = Data(name: "Misa Amane", description: "The author speculated that after someone \"like Matsuda probably let it slip\" that Light died, Misa fell into despair and \"committed suicide... something like that\". Her death date is given as slightly over a year after Light's.", deathTime: "12 july")
        return [d1,d2,d3]
    }
}
