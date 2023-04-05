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
        
        view.backgroundColor = .white
        showbutton.setTitle("login", for: .normal)
        showbutton.backgroundColor = UIColor.systemBrown
        showbutton.layer.cornerRadius = 10
        showbutton.translatesAutoresizingMaskIntoConstraints = false
        showbutton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        showbutton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        showbutton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        showbutton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -200).isActive = true

        showbutton.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        print("load first screen")
    }
    
    @objc func clickButton() {
        let layout = DinamiclySizeLayout()
        print("button clicked. Go to collectionView")
        let cvc = TestCollectionViewController(collectionViewLayout: layout)
        cvc.title = "Test cells"
        navigationController?.pushViewController(cvc, animated: true)
    }


}

