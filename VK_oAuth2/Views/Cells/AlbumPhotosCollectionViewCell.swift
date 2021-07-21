//
//  AlbumPhotosCollectionViewCell.swift
//  VK_oAuth2
//
//  Created by iMac on 20.07.2021.
//

import UIKit
import SnapKit
import SDWebImage

class AlbumPhotosCollectionViewCell: UICollectionViewCell {
    
    static let identifire = "AlbumPhotosCollectionViewCell"
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
    
    private func makeConstraints() {
        imageView.snp.makeConstraints { (make) in
            make.center.width.height.equalToSuperview()
        }
    }
    
    public func configure(with model: AlbumPhotosViewModel) {
        imageView.sd_setImage(with: model.url, placeholderImage: UIImage(systemName: "photo"))
    }
}
