//
//  PlanViewControllerExtension.swift
//  SPT Mobile
//
//  Created by Muhammad Waleed on 27.10.2024.
//

import UIKit

// MARK: - Methods for Fetching State
extension PlanViewController {
    func cellForRowWhileFetching(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return headerCellConfigurationWhileFetching(in: tableView, at: indexPath)
        case 1:
            return loaderCellConfigurationWhileFetching(in: tableView, at: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func heightForRowWhileFetching(in tableView: UITableView, at indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return headerCellHeightWhileFetching()
        case 1:
            return loaderCellHeightWhileFetching()
        default:
            return CGFloat.zero
        }
    }
    
    /// Private Methods for Fetching State: Cell Configuration
    private func headerCellConfigurationWhileFetching(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConnectionHeaderTableViewCell", for: indexPath) as! ConnectionHeaderTableViewCell
        tableView.separatorStyle = .none
        cell.updateWhileLoading()
        return cell
    }
    
    private func loaderCellConfigurationWhileFetching(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LoaderTableViewCell", for: indexPath) as! LoaderTableViewCell
        tableView.separatorStyle = .none
        cell.showLoader()
        return cell
    }
    
    /// Private Methods for Fetching State: Cell Height
    private func headerCellHeightWhileFetching() -> CGFloat {
        return 80.0
    }
    
    private func loaderCellHeightWhileFetching() -> CGFloat {
        return 150.0
    }
}

// MARK: -  Methods for Updating Date
extension PlanViewController {
    func cellForRowWhileUpdatingData(in tableView: UITableView, at indexPath: IndexPath, planViewData: APIResponseDataModel) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return headerCellConfigurationWithData(in: tableView, at: indexPath, from: planViewData)
        default:
            return upcomingCellConfigurationWithData(in: tableView, at: indexPath, from: planViewData)
        }
    }
    
    func heightForRowWhileUpdatingData(in tableView: UITableView, at indexPath: IndexPath, leg: Leg?) -> CGFloat {
        return upcomingCellHeightWithData(at: indexPath, from: leg!)
    }
    
    /// Private Methods for Updating Data State: Cell Configuration
    private func headerCellConfigurationWithData(in tableView: UITableView, at indexPath: IndexPath, from: APIResponseDataModel) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConnectionHeaderTableViewCell", for: indexPath) as! ConnectionHeaderTableViewCell
        tableView.separatorStyle = .singleLine
        cell.updateResponse(from: from)
        return cell
    }
    
    /// Private Methods for Updating Data State: Cell Height
    private func upcomingCellConfigurationWithData(in tableView: UITableView, at indexPath: IndexPath, from: APIResponseDataModel) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpcomingTableViewCell") as! UpcomingTableViewCell
        tableView.separatorStyle = .singleLine
        cell.updateData(from: from, indexPath: indexPath)
        cell.updateImage(from: from, indexPath: indexPath)
        return cell
    }
    
    private func upcomingCellHeightWithData(at indexPath: IndexPath, from: Leg) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 85.0
        default:
            return from.terminal != nil && from.departure != nil && from.g != nil && from.l != nil ? 45.0 : 0.0
        }
    }
}

// MARK: - Methods for Showing Error
extension PlanViewController {
    func cellForRowWithError(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            return headerCellWithError(in: tableView, at: indexPath)
        case 1:
            return descriptionWithError(in: tableView, at: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    func errorCellHeight(in tableView: UITableView, at indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return headerCellHeightWithError()
        case 1:
            return errorCellHeightWithError()
        default:
            return CGFloat.zero
        }
    }
    
    /// Private Methods for Error State: Cell Configuration
    private func headerCellWithError(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConnectionHeaderTableViewCell") as! ConnectionHeaderTableViewCell
        tableView.separatorStyle = .none
        cell.updateError()
        return cell
    }
    
    private func descriptionWithError(in tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ErrorTableViewCell", for: indexPath) as! ErrorTableViewCell
        tableView.separatorStyle = .none
        // No additional configuration needed; the cell is just a static UI representation of an error state.
        return cell
    }
    
    /// Private Methods for Error State: Cell Height
    private func headerCellHeightWithError() -> CGFloat {
        return 80.0
    }
    
    private func errorCellHeightWithError() -> CGFloat {
        return 200.0
    }
}
