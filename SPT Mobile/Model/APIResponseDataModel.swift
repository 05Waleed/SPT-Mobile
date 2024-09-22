//
//  APIResponseDataModel.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 01.09.2024.
//

import Foundation

// This model is used to update UI on PlanView
struct APIResponseDataModel {
    let connection: [Connection]
    let legs: [Leg]?
    let stop: [Stop]
}

// This model is used to update UI on ConnectionsView from selected location
struct APIResponseDataModelForSelectedLocation {
    let connection: [Connections]
    let legs: [Legs]?
    let stop: [Stops]
}
