//
//  ViewController.swift
//  MyFavorites
//
//  Created by Fernando de Lucas da Silva Gomes on 26/10/20.
//

import UIKit

class ViewController: UIViewController {
    
    let collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    var listOfAlbuns : [Album] = [] {
        didSet{
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "MYList"
        collectionView.delegate = self
        collectionView.dataSource = self
        setcollectionView()
        fetchByArtist()
        // Do any additional setup after loading the view.
    }
    
    func setcollectionView(){
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    @IBAction func addAlbum(_ sender: Any) {
        self.navigationController?.pushViewController(AddAlbum(), animated: true)
    }
    
    
    func fetchAlbum(){
        CloudKitModel.current.fetchAllAlbum { result in
            switch result {
            case .success(let albuns):
                self.listOfAlbuns = albuns
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchByArtist(){
        CloudKitModel.current.fetchByArtist(artist: "Taylor Swift") {  result in
            switch result {
            case .success(let albuns):
                self.listOfAlbuns = albuns
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
}


extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        listOfAlbuns.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let album = listOfAlbuns[indexPath.row]
        let fileUrl = album.cover.fileURL
        do{
            let data = try Data(contentsOf: fileUrl!)
            let image = UIImage(data: data)
            let imageview = UIImageView(image: image)
            imageview.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
            imageview.contentMode = .scaleAspectFill
            cell.addSubview(imageview)
        } catch{
            
        }
        return cell
    }
    
    
}
