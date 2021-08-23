//
//  PhotosViewController.swift
//  VK_oAuth2
//
//  Created by iMac on 19.07.2021.
//

import UIKit
import SnapKit

class PhotosViewController: UIViewController {
    
    var coordinator: MainCoordinator?
    
    private var collectionView: UICollectionView?
    
    private var photos = [Photo]()
    private var viewModels = [AlbumPhotosViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("TitleForPhotosVC", comment: "")
        view.backgroundColor = .systemBackground
        
        configureCollectionView()

        
        makeConstraints()
        
        let buttonTitle = NSLocalizedString("exitButtonTitle", comment: "")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: buttonTitle, style: .done, target: self, action: #selector(didTapExitButton))
        navigationItem.rightBarButtonItem?.tintColor = .label

        navigationController?.navigationBar.backgroundColor = nil
        
        fetchPhotos()
    }
    
    //MARK: - Private func-s
    private func configureCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let space = CGFloat(2)
        layout.minimumLineSpacing = space //между строками
        layout.minimumInteritemSpacing = space //между ячейками в строке
        //layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        let size = (view.frame.width - space)/2
        layout.itemSize = CGSize(width: size, height: size)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.delegate   = self
        collectionView?.dataSource = self
   
        collectionView?.backgroundColor = .systemBackground
        
        collectionView?.register(AlbumPhotosCollectionViewCell.self, forCellWithReuseIdentifier: AlbumPhotosCollectionViewCell.identifire)
        
        
        guard let collectionView = collectionView else { return }
        
        view.addSubview(collectionView)
    }
    
    
    private func makeConstraints() {
        collectionView?.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.top.equalToSuperview()
        }
    }
    
    
    private func fetchPhotos() {
        
        APICaller.shared.getAlbumPhotos { [weak self] (result) in
            
            DispatchQueue.main.async {
                
                switch result {
                case .success(let photos):
                    self?.photos = photos
                    self?.collectionView?.reloadData()
                    
                case .failure(let error):
                    self?.showErrorMessage(with: error.localizedDescription)
                }
            }
        }
    }
    
    private func showErrorMessage(with error: String) {
        
        let title = NSLocalizedString("failedToGetPhotosAlertTitle", comment: "")
        let alert = UIAlertController(title: title, message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
        
        let buttonTitle = NSLocalizedString("noInternetConnectionButtonTitle", comment: "")
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: { [weak self] (_) in
            self?.fetchPhotos()
        }))
        present(alert, animated: true)
    }
    
    //MARK: - Actions
    @objc private func didTapExitButton() {
        
        coordinator?.didTapExitButton()
//        let signOutTitle       = NSLocalizedString("signOutTitle", comment: "")
//        let signOutMessage     = NSLocalizedString("signOutMessage", comment: "")
//        let signOutCancelTitle = NSLocalizedString("signOutCancelTitle", comment: "")
//        let signOutButtonTitle = NSLocalizedString("signOutButtonTitle", comment: "")
//        
//        let alert = UIAlertController(title: signOutTitle,
//                                      message: signOutMessage, preferredStyle: .alert)
//        
//        alert.addAction(UIAlertAction(title: signOutCancelTitle, style: .cancel, handler: nil))
//        
//        alert.addAction(UIAlertAction(title: signOutButtonTitle, style: .destructive, handler: { [weak self] _ in
//
//            AuthManager.shared.signOut { (success) in
//                if success {
//                    DispatchQueue.main.async {
//
//                        let loginVC = LoginViewController()
//                        loginVC.modalPresentationStyle = .fullScreen
//                        self?.present(loginVC, animated: true)
//                    }
//                }
//            }
//        }))
//        
//        present(alert, animated: true)
    }

}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumPhotosCollectionViewCell.identifire, for: indexPath) as? AlbumPhotosCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let photo = photos[indexPath.row]
        let model = AlbumPhotosViewModel(with: URL(string: photo.urlString))
        
        cell.configure(with: model)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let photo = photos[indexPath.row]
        
        let otherPhotos = photos.filter{ $0.id != photo.id }
        
        //DELETE
//        let detailVC = PhotoDetailViewController(mainPhoto: photo, andOtherPhotos: otherPhotos)

        coordinator?.pushDetailPhotoVC(mainPhoto: photo, andOtherPhotos: otherPhotos)
        //coordinator?.navigationController?.pushViewController(detailVC, animated: true)
       // navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
