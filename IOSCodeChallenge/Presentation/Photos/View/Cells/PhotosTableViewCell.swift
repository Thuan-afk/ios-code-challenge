//
//  PhotosTableViewCell.swift
//  IOSCodeChallenge
//
//  Created by Hoa Thuan on 02/10/2025.
//

import UIKit

class PhotosTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: PhotosTableViewCell.self)

    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    private lazy var authorLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private lazy var sizeLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupSubview()
        updateConstraint()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
    }

    func setupSubview() {
        contentView.addSubview(photoImageView)
        contentView.addSubview(authorLabel)
        contentView.addSubview(sizeLabel)
    }

    func updateConstraint() {
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])

        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            authorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            authorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            authorLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 8),
            authorLabel.heightAnchor.constraint(equalToConstant: 22)
        ])

        sizeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sizeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            sizeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            sizeLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 4),
            sizeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            authorLabel.heightAnchor.constraint(equalToConstant: 22)
        ])
    }

    func configure(photo: Photo) {
        photoImageView.image = UIImage(systemName: "photo")?.withTintColor(.gray)
        
        DispatchQueue.global(qos: .background).async {
            PhotoCacheManager.shared.loadImage(from: photo.resizedURL()) { [weak self] image in
                if let image = image {
                    DispatchQueue.main.async {
                        self?.photoImageView.image = image
                    }
                }
            }
        }
        
        authorLabel.text = photo.author
        sizeLabel.text = "Size: \(photo.width) x \(photo.height)"
    }

}
