//
//  PhotosTableViewCell.swift
//  IOSCodeChallenge
//
//  Created by Hoa Thuan on 02/10/2025.
//

import UIKit

class PhotosTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = String(describing: PhotosTableViewCell.self)

    private lazy var contentCellView: UIView = {
        let v = UIView()
        return v
    }()
    
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
    
    let skeletonView = SkeletonView()

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
        showSkeleton(true)
        photoImageView.image = nil
    }

    func setupSubview() {
        contentView.addSubview(contentCellView)
        contentCellView.addSubview(photoImageView)
        contentCellView.addSubview(authorLabel)
        contentCellView.addSubview(sizeLabel)
        contentView.addSubview(skeletonView)
    }

    func updateConstraint() {
        if let superview = contentCellView.superview {
            contentCellView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                contentCellView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                contentCellView.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
                contentCellView.topAnchor.constraint(equalTo: superview.topAnchor),
                contentCellView.bottomAnchor.constraint(equalTo: superview.bottomAnchor)
            ])
        }
        
        if let superview = photoImageView.superview {
            photoImageView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                photoImageView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
                photoImageView.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
                photoImageView.topAnchor.constraint(equalTo: superview.topAnchor),
                photoImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
            ])
        }

        if let superview = authorLabel.superview {
            authorLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                authorLabel.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 8),
                authorLabel.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -8),
                authorLabel.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 8),
                authorLabel.heightAnchor.constraint(equalToConstant: 22)
            ])
        }

        if let superview = sizeLabel.superview {
            sizeLabel.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                sizeLabel.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 8),
                sizeLabel.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -8),
                sizeLabel.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 4),
                sizeLabel.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -16),
                sizeLabel.heightAnchor.constraint(equalToConstant: 22)
            ])
        }
        
        if let superview = skeletonView.superview {
            skeletonView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                skeletonView.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 4),
                skeletonView.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -4),
                skeletonView.topAnchor.constraint(equalTo: superview.topAnchor, constant: 4),
                skeletonView.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -4)
            ])
        }
    }

    func configure(photo: Photo) {        
        PhotoCacheManager.shared.loadImage(from: photo.resizedURL(), originalWidth: photo.width, originalHeight: photo.height) { [weak self] image in
            self?.photoImageView.image = image
            self?.showSkeleton(false)
        }
        
        authorLabel.text = photo.author
        sizeLabel.text = "Size: \(photo.width) x \(photo.height)"
    }

    private func showSkeleton(_ show: Bool) {
        skeletonView.isHidden = !show
        contentCellView.isHidden = show
    }
}
