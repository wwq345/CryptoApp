//
//  PortfolioService.swift
//  CryptoTracker
//
//  Created by i564206 on 2022/3/20.
//

import Foundation
import CoreData
import UIKit

class PortfolioDataService{
    
    private let container: NSPersistentContainer
    private let containerName: String = "PortfolioContainer"
    private let entityName: String = "PortfolioEntity"
    @Published var saveEntity: [PortfolioEntity] = []
    
    init(){
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                print("Error occured in loading Core Data \(error)")
            }
            self.getPortfolio()
        }
    }
    
    func updatePortfolio(amount: Double, coin: CoinModel){
        
        if let entity = saveEntity.first(where: {$0.coinID == coin.id}){
            if amount > 0 {
                update(entity: entity, amount: amount)
            }else{
                remove(entity: entity)
            }
        }else{
            add(coin: coin, amount: amount)
        }
        
//        if let entity = saveEntity.first(where: { (saveEntity) -> Bool in
//            return saveEntity.coinID == coin.id
//        }){
//
//        }
    }
    
    private func getPortfolio(){
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        do {
            saveEntity = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching Portfolio Entites \(error)")
        }
    }
    private func add(coin: CoinModel, amount:Double){
        //update to context
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChange()
    }
    
    private func update(entity: PortfolioEntity, amount: Double){
        entity.amount = amount
        applyChange()
    }
    
    private func remove(entity: PortfolioEntity){
        container.viewContext.delete(entity)
        applyChange()
    }
    
    
    private func save(){
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error in saving Core Data \(error)")
        }
    }
    
    private func applyChange(){
        save()
        getPortfolio()
    }
}
