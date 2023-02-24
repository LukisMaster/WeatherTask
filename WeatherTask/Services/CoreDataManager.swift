//
//  CoreDataManager.swift
//  WeatherTask
//
//  Created by Sergey Nestroyniy on 24.02.2023.
//

import Foundation
import CoreData

class CoreDataManager {
    
    // MARK: - Properties
    
    static let shared = CoreDataManager()
    private let persistentContainer: NSPersistentContainer
    
    // MARK: - Init
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "WeatherDataModel")
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error \(error), \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - Core Data Stack
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        guard viewContext.hasChanges else { return }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    // MARK: - Fetch Request
    
    func fetchWeatherData() -> [Weather] {
        let request: NSFetchRequest<Weather> = Weather.fetchRequest()
        do {
            let weathers = try viewContext.fetch(request)
            return weathers
        } catch {
            print("Error fetching weathers: \(error.localizedDescription)")
            return []
        }
    }
    
    // MARK: - Insert Request
    
    func insertWeatherData(temperature: Int16, location: String) {
        let weather = Weather(context: viewContext)
        weather.tempCelsius = temperature
        weather.cityName = location
        weather.date = Date()
        saveContext()
    }
}
