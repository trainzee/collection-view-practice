//
//  TestCollectionViewController.swift
//  CellTest
//
//  Created by Dmitry on 19.03.2023.
//

import UIKit

private let reuseIdentifier = "Cell"

class TestCollectionViewController: UICollectionViewController {
    
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    let itemsPerRow: CGFloat = 2
    
    var imageslist: [ImageInfo] = []
    var apiKey = "Njwk9mCwCt9TabED1YemFimxTRb8H8TekIIOClVLxQQ"
    
    var viewModel: PhotoViewModel!

//    func getPhoto() {
//        NetworkingManager.shared.fetchImageData(page: 1, withCompletion: { images in
//            images.forEach({ image in
//                self.imageslist.append(image)
//            })
//            self.collectionView.reloadData()
//            print("Reloaded collectionView")
//        })
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("run viewdidload")
        
        if let layout = collectionView.collectionViewLayout as? DinamiclySizeLayout{
            layout.delegate = self
        }
        
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        
        viewModel = PhotoViewModel(delegate: self)
        viewModel.getPhoto()
        
        self.collectionView!.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("run numberOfSections")
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("run numberOfItems")
        print("imageslist.count = \(viewModel.imageslist.count)")
        return viewModel.imageslist.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
        cell.backgroundColor = .red
        cell.imageView.layer.cornerRadius = 20
        print("run cellforitem \(indexPath.row)")
        if isLoadingCell(for: indexPath) {
            print("loadingCell")
        }else {
            cell.imageView.fatchImage(urladdress: viewModel.imageslist(at: indexPath.row))
        }
//        if viewModel.imageslist.isEmpty {
//        }else {
//            print("requets done. Array filled")
//            cell.imageView.fatchImage(urladdress: viewModel.imageslist[indexPath.item].urls.thumb)
//            print("image fatch from url")
//            print(viewModel.imageslist[indexPath.item].urls.thumb)
//            print("end fatching")
//            }
        return cell
    }
}

extension TestCollectionViewController: PinterestLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, _ width: CGFloat) -> CGFloat {
        if isLoadingCell(for: indexPath) {
            return width * 1;
        }
        let ratio = Double(viewModel.imageslist[indexPath.item].height) / Double(viewModel.imageslist[indexPath.item].width)
        return width * CGFloat(ratio)
    }
}


extension TestCollectionViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print("prefetching images at index \(indexPaths)")
        let newIndexPaths = indexPaths.map { indexPath in
            IndexPath(row: indexPath.row + 20, section: 0)
        }
        if newIndexPaths.contains(where: isLoadingCell
            ) {
            print("perfetching")
            viewModel.getPhoto()
        }
    }
}

extension TestCollectionViewController: PhotosVMDelegate {
    func fetchCompleted(with newIndexPathReload: [IndexPath]?) {
        print("fetch completed")
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
//        guard let newIndexPathReload = newIndexPathReload else {
//            collectionView.reloadData()
//            print("else guard")
//            return
//        }
//        let indexPathsToReload = visibleIndexPathToReload(intersecting: newIndexPathReload)
//        print("newIndexPathReload = \(newIndexPathReload)")
//        print("indexPathsToReload \(indexPathsToReload)")
//        collectionView.reloadItems(at: indexPathsToReload)
    }
    
    func fetchFailed(with reason: String) {
        print("error")
    }
}

extension TestCollectionViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        print("indexPath.row is \(indexPath.row)")
        return indexPath.row >= viewModel.currentCount
    }
    
    func visibleIndexPathToReload(intersecting indexPaths: [IndexPath]) -> [IndexPath] {
        let indexPathsForVisibleRows = collectionView.indexPathsForVisibleItems
        let indexPathIntersection = Set(indexPathsForVisibleRows).intersection(indexPaths)
        print("indexPathsForVisibleRows = \(indexPathsForVisibleRows)")
        print("indexPathIntersection = \(Array(indexPathIntersection))")
        return Array(indexPathIntersection)
    }
}



extension UIImageView {
    func fatchImage(urladdress: String) {
        print("SOSI HUUUUUUUIIII")
        guard let url = URL(string: urladdress) else{
            return
        }
        DispatchQueue.global().async { [weak self] in
            if let imageData = try? Data(contentsOf: url) {
                if let loadImage = UIImage(data: imageData) {
                    DispatchQueue.main.async {
                        self?.image = loadImage
                    }
                }
            }
        }
    }
}
