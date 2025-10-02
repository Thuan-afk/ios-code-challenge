//
//  PhotosViewController.swift
//  IOSCodeChallenge
//
//  Created by Hoa Thuan on 01/10/2025.
//

import UIKit
import Combine

class PhotosViewController: BaseViewController {
    
    private var viewModel: PhotosViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var searchTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Search by ID or Author..."
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.cornerRadius = 12
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.systemGray4.cgColor
        tf.backgroundColor = UIColor.systemGray6
        tf.clipsToBounds = true
        tf.setLeftPadding(8)
        tf.setRightPadding(8)
        return tf
    }()
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(PhotosTableViewCell.self, forCellReuseIdentifier: PhotosTableViewCell.reuseIdentifier)
        tv.dataSource = self
        tv.delegate = self
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 300
        tv.separatorStyle = .none
        return tv
    }()
    
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    static func create(with viewModel: PhotosViewModel) -> PhotosViewController {
        let view = PhotosViewController()
        view.viewModel = viewModel
        return view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Picsum Photos"
        
        viewModel.loadImages()
    }
    
    override func setupSubview() {
        view.addSubview(searchTextField)
        view.addSubview(tableView)
        view.addSubview(loadingIndicator)
    }

    override func updateConstraint() {
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchTextField.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 8),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        loadingIndicator.center = view.center
    }

    override func bindViewModel() {
        viewModel.$photos
                    .receive(on: DispatchQueue.main)
                    .sink { [weak self] _ in
                        self?.tableView.reloadData()
                    }
                    .store(in: &cancellables)
                
                viewModel.$errorMessage
                    .compactMap { $0 }
                    .sink { error in
                        print("Error: \(error)")
                    }
                    .store(in: &cancellables)
        
        viewModel.$isLoading
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.loadingIndicator.startAnimating()
                } else {
                    self?.loadingIndicator.stopAnimating()
                }
            }
            .store(in: &cancellables)
    }
}

extension PhotosViewController: UITableViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height - 100 {
            viewModel.loadImages()
        }
    }
}

extension PhotosViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.photos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotosTableViewCell.reuseIdentifier, for: indexPath) as? PhotosTableViewCell else {
            return UITableViewCell()
        }
        let item = viewModel.photos[indexPath.row]
        cell.configure(photo: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard viewModel.isLoading else { return nil }
        let spinner = UIActivityIndicatorView(style: .medium)
        spinner.startAnimating()
        spinner.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44)
        return spinner
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        viewModel.isLoading ? 44 : 0
    }
}
