//
//  DeathNoteViewController.swift
//  ex00
//
//  Created by Lesha Miroshnik on 4/4/19.
//  Copyright © 2019 Lesha Miroshnik. All rights reserved.
//

import UIKit

class DeathNoteViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var deads: [Data] = Data.getNames()
    
    // MARK: - Segue
    
    @IBAction func unWindToHomeVC(segue: UIStoryboardSegue) {}
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {}
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deads.count
    }
    
    func setBGImage(withCell cell : DeathNoteTableViewCell) -> DeathNoteTableViewCell {
        let offsetX: CGFloat = 10;
        let offsetY: CGFloat = 10;
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: offsetX, y: offsetY), size: CGSize(width: cell.frame.width - offsetX * 2, height: cell.frame.height - offsetY * 2)))
        let image = UIImage(named: "oldpaper.jpg")
        imageView.image = image
        imageView.layer.cornerRadius = 8.0
        imageView.layer.masksToBounds = true
        cell.backgroundView = UIView()
        cell.backgroundView!.addSubview(imageView)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "deathNoteInfoCell") as! DeathNoteTableViewCell
        
        cell.dead = deads[indexPath.row]
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            cell = self.setBGImage(withCell: cell)
        }
        
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
