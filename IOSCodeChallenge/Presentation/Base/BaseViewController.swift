//
//  BaseViewController.swift
//  IOSCodeChallenge
//
//  Created by Hoa Thuan on 02/10/2025.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 62/225, green: 180/225, blue: 137/225, alpha: 1)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]

        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        
        view.backgroundColor = .systemBackground
        
        setupSubview()
        updateConstraint()
        bindViewModel()
    }
    
    func setupSubview() {}
    func updateConstraint() {}
    func bindViewModel() {}
}
