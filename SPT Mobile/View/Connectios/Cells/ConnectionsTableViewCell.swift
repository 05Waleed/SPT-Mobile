//
//  ConnectionsTableViewCell.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 27.09.2024.
//

import UIKit

class ConnectionsTableViewCell: UITableViewCell {

    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var platformNumber: UILabel!
    @IBOutlet weak var departureTime: UILabel!
    @IBOutlet weak var arrivalTime: UILabel!
    @IBOutlet weak var directionName: UILabel!
    @IBOutlet weak var lineNumber: UILabel!
    @IBOutlet weak var vehicleImg: UIImageView!
    @IBOutlet weak var backView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.cornerRadius = 20
    }
        
    func updateData(from data: APIResponseDataModelForSelectedLocation?, indexPath: IndexPath) {
        guard let connection = data?.connection[indexPath.row] else { return }
        
        updateVehicleImage(for: connection)
        updateLineNumber(for: connection)
        updatePlatformNumber(for: connection)
        updateDirectionName(for: connection)
        updateTimes(for: connection)
    }

    private func updateVehicleImage(for connection: Connections) {
        if let transportType = connection.legs.first?.type {
            let imageName: String
            switch transportType {
            case .expressTrain:
                imageName = "strain"
                lineNumber.backgroundColor = .accent
                lineNumber.textColor = .white
            case .railway, .strain:
                imageName = "strain"
            case .tram:
                imageName = "tram"
            case .bus:
                imageName = "bus 1"
            default:
                imageName = ""
            }
            vehicleImg.image = UIImage(named: imageName)
        }
    }

    private func updateLineNumber(for connection: Connections) {
        if let leg = connection.legs.first, let line = leg.g {
            lineNumber.text = "\(line)\(leg.l ?? "")"
        } else {
            lineNumber.text = ""
        }
    }

    private func updatePlatformNumber(for connection: Connections) {
        if let platform = connection.legs.first?.track {
            platformNumber.text = connection.legs.first?.type == .tram ? "Stop \(platform)" : "Pl.\(platform)"
        } else {
            platformNumber.text = ""
        }
    }

    private func updateDirectionName(for connection: Connections) {
        directionName.text = connection.legs.first?.terminal ?? ""
    }

    private func updateTimes(for connection: Connections) {
        duration.text = HelperFunctions.convertSecondsToHoursMinutes(seconds: connection.duration)
        arrivalTime.text = HelperFunctions.getTime(from: connection.arrival)
        departureTime.text = HelperFunctions.getTime(from: connection.legs.first?.departure ?? "")
    }
}
