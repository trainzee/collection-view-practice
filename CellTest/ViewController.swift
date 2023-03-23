//
//  ViewController.swift
//  CellTest
//
//  Created by Dmitry on 19.03.2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let showbutton = UIButton()
        view.addSubview(showbutton)
        
        showbutton.setTitle("login", for: .normal)
        showbutton.backgroundColor = UIColor.systemBlue
        showbutton.translatesAutoresizingMaskIntoConstraints = false
        showbutton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        showbutton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        showbutton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        showbutton.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        showbutton.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
    }
    
    @objc func clickButton() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (view.frame.size.width / 3)-5,
                                 height: (view.frame.size.width / 3)-5)
        
        layout.minimumLineSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        layout.minimumInteritemSpacing = 1
        
        
        let cvc = TestCollectionViewController(collectionViewLayout: layout)
        cvc.title = "Test cells"
        navigationController?.pushViewController(cvc, animated: true)
    }


}

