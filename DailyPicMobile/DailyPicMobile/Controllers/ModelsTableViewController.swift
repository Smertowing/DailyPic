//
//  ModelsTableViewController.swift
//  DailyPicMobile
//
//  Created by Kiryl Holubeu on 3/24/19.
//  Copyright © 2019 brakhmen. All rights reserved.
//

import UIKit

class ModelsTableViewController: UITableViewController {
    private var entityModels: [EntityModel] = []
    private var deleteEntityIndexPath: IndexPath?
    
    override func viewDidAppear(_ animated: Bool) {
        loadEntityModels()
    }
    
    @IBAction func refresh() {
        loadEntityModels()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addNewEntitySegue" {
            guard let addController = segue.destination as? AddEntityViewController else {
                return
            }
            addController.delegate = self
        }
    }
    
    private func loadEntityModels() {
        DailyPicClient.getAll { [weak self] models, error in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.handleError(error)
            } else {
                strongSelf.entityModels = models!
                strongSelf.tableView.reloadData()
            }
        }
    }
    
    fileprivate func handleError(_ error: DailyPicClientError) {
        switch error {
        case .couldNotAdd(let model):
            UIAlertController.showError(with: "Could not add model \(model.id ?? "")", on: self)
        case .couldNotDelete(let model):
            UIAlertController.showError(with: "Could not delete model with id: \(model.id ?? "")", on: self)
        case .couldNotLoadModels:
            UIAlertController.showError(with: "Could not access models on server", on: self)
        case .couldNotCreateClient:
            UIAlertController.showError(with: "Could not create client for server transmission", on: self)
        }
    }
}

extension ModelsTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entityModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EntityModelTableViewCell.cellIdentifier, for: indexPath) as! EntityModelTableViewCell
        let entity = entityModels[indexPath.row]
        cell.dateLabel.text = entity.date.displayDate.uppercased()
        cell.timeLabel.text = entity.date.displayTime
        if let imageData = Data(base64Encoded: entity.picture) {
            cell.entityImageView.image = UIImage(data: imageData)
            cell.entityImageView.contentMode = .scaleAspectFit
        }
        cell.backgroundColor = entity.backgroundColor
        return cell
    }
}

extension ModelsTableViewController: AddEntityDelegate {
    func didAdd(entity: EntityModel, from controller: AddEntityViewController) {
        DailyPicClient.add(model: entity) { [weak self] (savedEntry: EntityModel?, error: DailyPicClientError?) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.handleError(error)
            } else {
                strongSelf.navigationController?.popToViewController(strongSelf, animated: true)
                // avoid animating to top of empty table view, causing crash
                if strongSelf.tableView.numberOfRows(inSection: 0) > 0 {
                    let path = IndexPath(row: 0, section: 0)
                    strongSelf.tableView.scrollToRow(at: path, at: UITableView.ScrollPosition.top, animated: true)
                }
            }
        }
    }
}

extension ModelsTableViewController {
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteEntityIndexPath = indexPath
            let entry = entityModels[indexPath.row]
            confirmDelete(entry: entry)
        }
    }
    
    func confirmDelete(entry: EntityModel) {
        let alert = UIAlertController(title: "Delete Entity", message: "Are you sure you want to delete entity from your journal?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: deleteEntryHandler))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { [weak self] action in
            guard let strongSelf = self else {
                return
            }
            strongSelf.deleteEntityIndexPath = nil
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func deleteEntryHandler(action: UIAlertAction) {
        guard let indexPath = deleteEntityIndexPath else {
            deleteEntityIndexPath = nil
            return
        }
        DailyPicClient.delete(model: entityModels[indexPath.row]) { [weak self] (error: DailyPicClientError?) in
            guard let strongSelf = self else {
                return
            }
            if let error = error {
                strongSelf.handleError(error)
            } else {
                strongSelf.tableView.beginUpdates()
                strongSelf.entityModels.remove(at: indexPath.row)
                strongSelf.tableView.deleteRows(at: [indexPath], with: .automatic)
                strongSelf.deleteEntityIndexPath = nil
                strongSelf.tableView.endUpdates()
            }
        }
    }
}

