//
//  PhotoDetailViewController.swift
//  VK_oAuth2
//
//  Created by iMac on 20.07.2021.
//

import UIKit
import SDWebImage



class PhotoDetailViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var coordinator: MainCoordinator?
    
    var someClosure: (() -> Void)?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.layer.masksToBounds = true
        return scrollView
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var collectionView: UICollectionView?
    
    private var photo: Photo
    private var otherPhotos = [Photo]()
    private var imageViewScale = CGFloat()

    init(mainPhoto: Photo, andOtherPhotos otherPhotos: [Photo]) {
        self.photo = mainPhoto
        self.otherPhotos = otherPhotos
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = getStringFromUnixDate()
        view.backgroundColor = .systemBackground
        
        view.addSubview(scrollView)
        

        configureImageView()
        configureBarButtons()
        configureCollectionView()
        makeConstraints()
        
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        pinchGesture.delegate = self
        self.view.addGestureRecognizer(pinchGesture)
        
    }
    
    //MARK: - Private func-s
    private func getStringFromUnixDate() -> String {
        
        let date = Date(timeIntervalSince1970: TimeInterval(photo.date))
        
        return DateFormatter.titleDateFormatter.string(from: date)
    }
    

    private func configureBarButtons() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapShareButton))

        let navBar = navigationController?.navigationBar
        navBar?.tintColor = .label
        navBar?.topItem?.backButtonTitle = ""
 
    }
    
    private func configureImageView() {
        
        imageView.sd_setImage(with: URL(string: photo.urlString), placeholderImage: UIImage(systemName: "photo"))
        scrollView.addSubview(imageView)
    }
    
    func configureCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 3)
        let size = view.width / 7 - 2
        layout.itemSize = CGSize(width: size, height: size)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.dataSource = self
        
        collectionView?.backgroundColor = .systemBackground
        
        collectionView?.register(AlbumPhotosCollectionViewCell.self, forCellWithReuseIdentifier: AlbumPhotosCollectionViewCell.identifire)
        
        guard let cv = collectionView else {
            return
        }
        scrollView.addSubview(cv)
    }
    
    private func makeConstraints() {
        
        scrollView.snp.makeConstraints { (make) in
            make.leading.width.equalToSuperview()
            make.top.equalTo(view.snp.topMargin)
            make.bottom.equalTo(view.snp.bottomMargin)
        }
        
        let collectionOffset = view.width/7 + 20 + view.layoutMargins.bottom + view.layoutMargins.top
        let imageOffset = (view.height-view.width)/2 - collectionOffset
        
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(imageOffset)
            make.width.height.equalTo(view.width)
        }

        collectionView?.snp.makeConstraints({ (make) in
            make.centerX.width.equalToSuperview()
            make.height.equalTo(view.width / 7)
            make.bottom.equalTo(view.snp.bottomMargin).inset(20)
        })
    }
    
    //MARK: - Actions
    @objc private func handlePinch(pinchGesture: UIPinchGestureRecognizer){
        if pinchGesture.state == .began {
            self.imageViewScale = 1.0
        }
        
        let newScale = 1.0 + pinchGesture.scale - self.imageViewScale

        self.imageView.transform = self.imageView.transform.scaledBy(x: newScale, y: newScale)
        
        self.imageViewScale = pinchGesture.scale
        
    }
    
    @objc private func didTapShareButton() {
                
        coordinator?.showAlertSheetToSaveOrShare()
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        var title = ""
        var message = ""
        
        if let error = error {
            title  = NSLocalizedString("saveInGalleryFailedTitle", comment: "")
            message = error.localizedDescription
        } else {
            title = NSLocalizedString("saveInGallerySuccessTitle", comment: "")
            message = NSLocalizedString("saveInGallerySuccessMessage", comment: "")
        }
        
        coordinator?.presentAlert(withTitle: title, andMessage: message)
        
    }
    

}

extension PhotoDetailViewController: PhotoDetailViewShareMenuDelegate {
    
    func didTapSaveInGallery() {
        
        guard let image = imageView.image else { return }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
}


extension PhotoDetailViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return otherPhotos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumPhotosCollectionViewCell.identifire, for: indexPath) as? AlbumPhotosCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let otherPhoto = otherPhotos[indexPath.row]
        let model = AlbumPhotosViewModel(with: URL(string: otherPhoto.urlString))
        
        cell.configure(with: model)
        return cell
    }
    
    
}

