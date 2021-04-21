//
//  MainViewController.swift
//  TestTask_CleanSwift_UIKit
//
//  Created by Владимир Костин on 13.04.2021.
//

// MARK: - В этом проекте использован открытый API api.nasa.gov, раздел о состоянии астероидов в Солнечной системе.

import UIKit
import CoreData

protocol DisplayLogic: class {
    func display(data: [CellModel])
}

class MainViewController: UITableViewController {
    
    private var interactor: InteractorLogic?
    private var dataToDisplay = [CellModel]()
    private var storedData: [StoredData] = []
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchStoredData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        interactor?.fetchData()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    private func setup() {
        let viewController = self
        let presenter = Presenter()
        let interactor = Interactor()
        interactor.presenter = presenter
        presenter.viewController = viewController
        viewController.interactor = interactor
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = dataToDisplay.count
        return count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        cell.cellID.text = String(dataToDisplay[indexPath.row].cellID)
        let stringSpeed = NSString(format: "%.2f", dataToDisplay[indexPath.row].kmPerSec)
        cell.headLine.text = "Name: \(dataToDisplay[indexPath.row].name); rV: \(stringSpeed) km/s."
        cell.Body.text = "Close approach: \(dataToDisplay[indexPath.row].approachDate) (UTC)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let dvc = storyboard?.instantiateViewController(identifier: "DVC") as? DetailViewController  else { return }
        dvc.nameText = "Name: \(dataToDisplay[indexPath.row].name);"
        dvc.idText = "Object ID: \(dataToDisplay[indexPath.row].objectID);"
        dvc.diamText = "Estimated diameter: \(NSString(format: "%.2f", dataToDisplay[indexPath.row].diameterMin)) - \(NSString(format: "%.2f", dataToDisplay[indexPath.row].diameterMax)) meters;"
        dvc.velocityText = "Relative velocity: \(NSString(format: "%.2f", dataToDisplay[indexPath.row].kmPerSec)) km/s (\(NSString(format: "%.2f", dataToDisplay[indexPath.row].kmPerHour)) km/h);"
        dvc.distText = "Miss distance: \(NSString(format: "%.1f", dataToDisplay[indexPath.row].distanceKM)) km (\(NSString(format: "%.2f", dataToDisplay[indexPath.row].distanceAE)) AU);"
        dvc.magnText = "Absolute magnitude: \(NSString(format: "%.2f", dataToDisplay[indexPath.row].absoluteMagnitudeH)) (H)"
        dvc.dateText = "Close approach date: \(dataToDisplay[indexPath.row].approachDate) UTC;"
        dvc.hazarText = dataToDisplay[indexPath.row].isPotentiallyHazardous ? "Potentially hazardous asteroid;" : "Potentially non-hazardous asteroid;"
        dvc.sentryText = dataToDisplay[indexPath.row].isSentryObject ? "Is a sentry object." : "Is a non-sentry object."
        
        self.navigationController?.pushViewController(dvc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension MainViewController: DisplayLogic {
    func display(data: [CellModel]) {
        dataToDisplay.removeAll()
        dataToDisplay.append(contentsOf: data)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func fetchStoredData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<StoredData> = StoredData.fetchRequest()
        
        do { storedData = try context.fetch(fetchRequest) }
        catch let error as NSError { print(error.localizedDescription) }
        
        dataToDisplay.removeAll()
        
        for i in 0...storedData.count-1 {
            let dataToAppend = CellModel(cellID: i,
                                         objectID: storedData[i].objectId ?? "",
                                         name: storedData[i].name ?? "",
                                         absoluteMagnitudeH: storedData[i].magnitude,
                                         isPotentiallyHazardous: storedData[i].hazard,
                                         isSentryObject: storedData[i].sentry,
                                         diameterMin: storedData[i].diamMin,
                                         diameterMax: storedData[i].diamMax,
                                         approachDate: storedData[i].approach ?? "",
                                         kmPerSec: storedData[i].kmPerSec,
                                         kmPerHour: storedData[i].kmPerHour,
                                         distanceAE: storedData[i].distanceAE,
                                         distanceKM: storedData[i].distancKM)
            dataToDisplay.append(dataToAppend)
        }
    }
}
