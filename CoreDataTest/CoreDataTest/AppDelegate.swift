//
//  AppDelegate.swift
//  CoreDataTest
//
//  Created by Matheus Cavalcanti de Arruda on 16/04/22.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        for family: String in UIFont.familyNames
//                {
//                    print(family)
//                    for names: String in UIFont.fontNames(forFamilyName: family)
//                    {
//                        print("== \(names)")
//                    }
//                }
        
        if isNewUser() {
            let context = persistentContainer.newBackgroundContext()
            UserDefaults.standard.set(0, forKey: "sortingOption")
            UserDefaults.standard.set(0, forKey: "sortingOptionTopic")
            populateSubject(in: context)
            populateTopics(in: context)
            setIsNotNewUser()
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data Info creation
    
    private func isNewUser() -> Bool {
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }
    
    private func setIsNotNewUser() {
        UserDefaults.standard.set(true, forKey: "isNewUser")
    }
    
    private func deleteAll() {
        let context = persistentContainer.newBackgroundContext()
        
        let subjectList = fetchSubjects(in: context)
        
        for subject in subjectList {
            let topicList = subject.topic
            
            for topic in topicList! {
                context.delete(topic)
                subject.removeFromTopic(topic)
            }
        }
        
        for subject in subjectList {
            context.delete(subject)
        }
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    private func saveContext(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    private func createSubject(with name: String, in context: NSManagedObjectContext) {
        let newSubject = Subject(context: context)
        newSubject.setValue(name, forKey: "name")
        newSubject.setValue(Date.distantPast, forKey: "latestDate")
        newSubject.setValue(1, forKey: "grayProgress")
        newSubject.setValue(0, forKey: "greenProgress")
        newSubject.setValue(0, forKey: "yellowProgress")
        newSubject.setValue(0, forKey: "redProgress")
        saveContext(context: context)
    }
    
    private func createTopic(with name: String, belongsTo subject: Subject, in context: NSManagedObjectContext) {
        let newTopic = Topic(context: context)
        newTopic.setValue(name, forKey: "name")
        newTopic.setValue(Date.distantPast, forKey: "latestSavedDate")
        newTopic.setValue(0, forKey: "latestSavedStatus")
        subject.addToTopic(newTopic)
        
        saveContext(context: context)
    }
    
    private func fetchSubjects(in context: NSManagedObjectContext) -> [Subject] {
        let fetchRequest = NSFetchRequest<Subject>(entityName: "Subject")
        var subjectList: [Subject] = []
        
        do {
            subjectList = try context.fetch(fetchRequest)
        } catch {
            print(error)
        }
        
        return subjectList
    }
    
    private func populateSubject(in context: NSManagedObjectContext) {
        let subjectList: [String] = ["Conhecimentos b??sicos e fundamentais", "Movimento, equil??brio e leis", "Fen??meno el??tricos e mang??ticos", "Pot??ncia, energia e trabalho", "Oscila????es, radia????o, ondas e ??ptica", "Mec??nica e universo", "O calor e os fen??menos t??rmicos"]
        
        for i in subjectList {
            createSubject(with: i, in: context)
        }
    }
    
    private func populateTopics(in context: NSManagedObjectContext) {
        let topicList: [[String]] = [
        ["Gr??ficos e vetores", "F??sica e o cotidiano", "No????es de ordem de grandeza", "Sistema Internacional de Unidades"],
        ["Mec??nica: tempo, espa??o, velocidade e acelera????o", "In??rcia", "Din??mica de massa", "For??a e varia????o", "Leis de Newton", "Equil??brio est??tico", "Hidrost??tica"],
        ["Correntes cont??nua e alternada", "Medidores el??tricos", "Representa????o gr??fica de circuitos", "Pot??ncia e consumo de energia em dispositivos el??tricos", "Lei de Ohm", "Carga el??trica e corrente el??trica", "Campo el??trico e resistividade", "Campo magn??tico", "Im??s permanentes", "Circuitos el??tricos simples", "Rela????es entre grandezas el??tricas: tens??o, corrente, pot??ncia e energia"],
        ["Trabalho da for??a gravitacional", "Energia potencial e energia cin??tica", "For??as conservativas e dissipativas", "Energia mec??nica e dissipa????o de energia"],
        ["Reflex??o e refra????o", "??ptica geom??trica", "Forma????o de imagens", "Fen??menos ondulat??rios", "Propaga????o"],
        ["Lei da Gravita????o Universal", "Movimentos de corpos celestes", "For??a peso", "Acelera????o gravitacional", "Leis de Kepler", "A origem do universo e sua evolu????o"],
        ["M??quinas t??rmicas", "Dilata????o t??rmica", "Leis da Termodin??mica", "Comportamento de gases ideais", "Conceitos de calor e de temperatura", "Transfer??ncia de calor e equl??brio t??rmico", "Aplica????es e fen??menos t??rmicos de uso cotidiano", "Mudan??as de estado f??sico e calor latente de transforma????o", "Compreens??o de fen??menos clim??ticos relacionados ao ciclo da ??gua"]
        ]
        
        let subjectList = fetchSubjects(in: context)
        
        for i in 0..<subjectList.count {
            
            for item in topicList[i] {
                
                createTopic(with: item, belongsTo: subjectList[i], in: context)
            }
        }
    }
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "CoreDataTest")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

