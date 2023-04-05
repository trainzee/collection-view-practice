////
////  ImageLoader.swift
////  CellTest
////
////  Created by Dmitry on 04.04.2023.
////
//
//import Foundation
//
//protocol PhotosVMDelegate: AnyObject {
//    func fetchCompleted(with newIndexPathReload: [IndexPath]?)
//    func fetchFailed(with reason: String)
//}
//
//class PhotoViewModel {
//    weak var delegate: PhotosVMDelegate?
//
//    var imageslist: [ImageInfo] = []
//    var runningRequest = [UUID: URLSessionDataTask]()
//
//    var currentPage = 1
//    var total = 0
//    var isFetchInProgress = false
//
//    var client = NetworkingManager()
//
//    init(delegate: PhotosVMDelegate) {
//        self.delegate = delegate
//    }
//
//    var currentCount: Int {
//        print("current count is \(imageslist.count)")
//        return imageslist.count
//    }
//
//    func imageslist(at index: Int) -> String{
//        return imageslist[index].urls.thumb
//    }
//
//    func getPhoto() {
//        guard !isFetchInProgress else {
//            return
//        }
//
//        isFetchInProgress = true
//
//
//
//        client.fetchImageData(page: currentPage) { imagesInfo in
//            switch imagesInfo {
//            case .fail(let error):
//                DispatchQueue.main.async {
//                    self.isFetchInProgress = false
//                    self.delegate?.fetchFailed(with: error.reason)
//                }
//            case .success(let response):
//                DispatchQueue.main.async {
//                    self.currentPage += 1
//                    print("currentpage + 1")
//                    self.isFetchInProgress = false
//
//                    self.total = response.total
//                    print("total = \(self.total)")
//                    print("response.result = \(response.results.count)")
//                    self.imageslist.append(contentsOf: response.results)
//
//                    print("imagelist.count = \(self.imageslist.count)")
//                    if self.currentPage > 1 {
//                        print("currentpage > 1")
//                        let indexPathToReload = self.calculateIndexPathsToReload(from: response.results)
//                        self.delegate?.fetchCompleted(with: indexPathToReload)
//                    }else {
//                        self.delegate?.fetchCompleted(with: .none)
//                    }
//                }
//            }
//        }
//    }
//
//    func calculateIndexPathsToReload(from receivedImages: [ImageInfo]) -> [IndexPath] {
//        let startIndex = imageslist.count - receivedImages.count
//        let endIndex = startIndex + receivedImages.count
//        print((startIndex..<endIndex).map { IndexPath(row: $0, section: 0)})
//        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
//    }
//}
