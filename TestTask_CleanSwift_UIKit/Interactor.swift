//
//  Interactor.swift
//  TestTask_CleanSwift_UIKit
//
//  Created by Владимир Костин on 13.04.2021.
//

import Foundation

protocol InteractorLogic {
    func fetchData()
}

class Interactor {
    var presenter: PresentationLogic?
}

extension Interactor: InteractorLogic {
   
    func fetchData() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let days = 2 //Set a days count for request
        let date = Date() //Getting the current date
        let timeShift = TimeInterval(3600*3) //Correct time to Coordinated Universal Time (UTC)
        let endDate = dateFormatter.string(from: date - timeShift) //Creat end date for request
        let startDate = dateFormatter.string(from: date - TimeInterval(3600*24*days) - timeShift)//Creat start date for request
        
        // Creating keys for processing the received dictionaries
        var keys = [String]()
        for i in 0...days {
            keys.append(dateFormatter.string(from: date - TimeInterval(3600*24*i) - timeShift))
        }
        // Request
        let urlString = "https://api.nasa.gov/neo/rest/v1/feed?start_date=\(startDate)&end_date=\(endDate)&api_key=DEMO_KEY"
        guard let url = URL(string: urlString) else {return}
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, responce, error in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let asteroids = try decoder.decode(AsteroidsData.self, from: data)
                    //Send data to Presenter
                    self.presenter?.present(data: asteroids, keys: keys)
                } catch let error as NSError { print(error.localizedDescription) }
            }
        }
        task.resume()
    }
}
