//
//  Presenter.swift
//  TestTask_CleanSwift_UIKit
//
//  Created by Владимир Костин on 13.04.2021.
//

import UIKit
import CoreData

protocol PresentationLogic {
    func present(data: AsteroidsData, keys: [String])
}

class Presenter {
    
    // MARK: - External vars
    weak var viewController: DisplayLogic?
}


// MARK: - Presentation Logic
extension Presenter: PresentationLogic {
    
    func present(data: AsteroidsData, keys: [String]) {
        
        var asteroids = [CellModel]()
        var id = 0
        guard data.nEObjects.count != 0 else { return }
        
        //MARK: -Convert data from AsteroidDataModel to CellDataModel
        for i in 0...keys.count-1 {
            for c in 0...data.nEObjects[keys[i]]!.count-1 {
                id += 1
                let cell = CellModel(cellID: id,
                                     objectID: data.nEObjects[keys[i]]?[c].id ?? "",
                                     name: data.nEObjects[keys[i]]?[c].name ?? "",
                                     absoluteMagnitudeH: data.nEObjects[keys[i]]?[c].absoluteMagnitudeH ?? 0,
                                     isPotentiallyHazardous: data.nEObjects[keys[i]]?[c].hazardous ?? false,
                                     isSentryObject: data.nEObjects[keys[i]]?[c].isSentryObject ?? false,
                                     diameterMin: data.nEObjects[keys[i]]?[c].diam.meters.estDiamMin ?? 0,
                                     diameterMax: data.nEObjects[keys[i]]?[c].diam.meters.estDiamMax ?? 0,
                                     approachDate: data.nEObjects[keys[i]]?[c].approach[0].closeApproachDateFull ?? "",
                                     kmPerSec: NSString(string: data.nEObjects[keys[i]]?[c].approach[0].rV.kmPS ?? "0").doubleValue,
                                     kmPerHour: NSString(string: data.nEObjects[keys[i]]?[c].approach[0].rV.kmPH ?? "0").doubleValue,
                                     distanceAE: NSString(string: data.nEObjects[keys[i]]?[c].approach[0].missDistance.astronomical ?? "0").doubleValue,
                                     distanceKM: NSString(string: data.nEObjects[keys[i]]?[c].approach[0].missDistance.kilometers ?? "0").doubleValue)
                asteroids.append(cell)
            }
        }
        saveData(data: asteroids)
        viewController?.display(data: asteroids)
    }
    
    private func saveData(data: [CellModel]) {
        
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<StoredData> = StoredData.fetchRequest()
            
            //MARK: - Detete saved data
            if let objects = try? context.fetch(fetchRequest) { for object in objects {context.delete(object)} }
            do { try context.save() }
            catch let error as NSError { print(error.localizedDescription) }
            
            //MARK: - Save new data
            guard let entity = NSEntityDescription.entity(forEntityName: "StoredData", in: context) else {return}
            
            for i in 0...data.count - 1 {
                let newStore = StoredData(entity: entity, insertInto: context)
                newStore.id = UUID()//UUID(uuidString: String(i))
                newStore.objectId = data[i].objectID
                newStore.name = data[i].name
                newStore.magnitude = data[i].absoluteMagnitudeH
                newStore.hazard = data[i].isPotentiallyHazardous
                newStore.sentry = data[i].isSentryObject
                newStore.diamMin = data[i].diameterMin
                newStore.diamMax = data[i].diameterMax
                newStore.approach = data[i].approachDate
                newStore.kmPerSec = data[i].kmPerSec
                newStore.kmPerHour = data[i].kmPerHour
                newStore.distancKM = data[i].distanceKM
                newStore.distanceAE = data[i].distanceAE
                
                do { try context.save() }
                catch let error as NSError { print(error.localizedDescription) }
            }
        }
    }
}
