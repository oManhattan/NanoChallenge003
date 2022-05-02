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
        
        UIFont.familyNames.forEach({ name in
            for font_name in UIFont.fontNames(forFamilyName: name) {
                print("\n\(font_name)")
            }
        })
        
        if isNewUser() {
            let context = persistentContainer.newBackgroundContext()
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
        
        saveContext(context: context)
    }
    
    private func createTopic(with name: String, belongsTo subject: Subject, in context: NSManagedObjectContext) {
        let newTopic = Topic(context: context)
        newTopic.setValue(name, forKey: "name")
        
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
        let subjectList: [String] = ["Conhecimentos básicos e fundamentais", "Movimento, equilíbrio e leis", "Fenômeno elétricos e mangéticos", "Potência, energia e trabalho", "Oscilações, radiação, ondas e óptica", "Mecânica e universo", "O calor e os fenômenos térmicos"]
        
        for subjectName in subjectList {
            createSubject(with: subjectName, in: context)
        }
    }
    
    private func populateTopics(in context: NSManagedObjectContext) {
        let topicList: [[String]] = [
        ["Gráficos e vetores", "Física e o cotidiano", "Noções de ordem de grandeza", "Sistema Internacional de Unidades"],
        ["Mecânica: tempo, espaço, velocidade e aceleração", "Inércia", "Dinâmica de massa", "Força e variação", "Leis de Newton", "Equilíbrio estático", "Hidrostática"],
        ["Correntes contínua e alternada", "Medidores elétricos", "Representação gráfica de circuitos", "Potência e consumo de energia em dispositivos elétricos", "Lei de Ohm", "Carga elétrica e corrente elétrica", "Campo elétrico e resistividade", "Campo magnético", "Imãs permanentes", "Circuitos elétricos simples", "Relações entre grandezas elétricas: tensão, corrente, potência e energia"],
        ["Trabalho da força gravitacional", "Energia potencial e energia cinética", "Forças conservativas e dissipativas", "Energia mecânica e dissipação de energia"],
        ["Reflexão e refração", "Óptica geométrica", "Formação de imagens", "Fenômenos ondulatórios", "Propagação"],
        ["Lei da Gravitação Universal", "Movimentos de corpos celestes", "Força peso", "Aceleração gravitacional", "Leis de Kepler", "A origem do universo e sua evolução"],
        ["Máquinas térmicas", "Dilataçnao térmica", "Leis da Termodinâmica", "Comportamento de gases ideais", "Conceitos de calor e de temperatura", "Transferência de calor e equlíbrio térmico", "Aplicações e fenômenos térmicos de uso cotidiano", "Mudanças de estado físico e calor latente de transformação", "Compreensão de fenômenos climáticos relacionados ao ciclo da água"]
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

