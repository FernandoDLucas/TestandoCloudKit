//
//  AddAlbum.swift
//  MyFavorites
//
//  Created by Fernando de Lucas da Silva Gomes on 26/10/20.
//

import Foundation
import UIKit
import CloudKit


class AddAlbum: UIViewController {
    
    
    var imageData = Data()
    
    let imagePicker = UIImagePickerController()
    
    let labelArtista : UITextField = {
        let labelId = UITextField()
        labelId.backgroundColor = .gray
        labelId.textAlignment = .center
        labelId.font = .systemFont(ofSize: 20)
        labelId.placeholder = "Artista"
        return labelId
    }()
    
    let labelTitulo: UITextField = {
        let labelId = UITextField()
        labelId.backgroundColor = .gray
        labelId.textAlignment = .center
        labelId.font = .systemFont(ofSize: 20)
        labelId.placeholder = "Titulo"
        return labelId
    }()
    
    
    let labelAno: UITextField = {
        let labelId = UITextField()
        labelId.backgroundColor = .gray
        labelId.textAlignment = .center
        labelId.font = .systemFont(ofSize: 20)
        labelId.placeholder = "Ano"
        return labelId
    }()
    
    let pickerImage: UIImageView = {
        let pickerView = UIImageView()
        pickerView.backgroundColor = .cyan
        pickerView.isUserInteractionEnabled = true
        return pickerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        self.imagePicker.delegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(backNow))
        setLabels()
        setPicker()
    }
    
    @objc func backNow(){
        let documentsFolder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let imageurl = documentsFolder.appendingPathComponent("imagetemp.jpg")
        print(imageurl)

        do {
            try imageData.write(to: imageurl)
        } catch (let error) {
            print(error.localizedDescription)
        }

        let newAlbum = Album(id: CKRecord.ID(), title: labelTitulo.text!, artist: labelArtista.text!, cover: CKAsset(fileURL: imageurl), ano: Int(labelAno.text!) ?? 2020)

        CloudKitModel.current.saveAlbum(album: newAlbum) { response in
            switch response{
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    func setLabels(){
        view.addSubview(labelArtista)
        view.addSubview(labelTitulo)
        view.addSubview(labelAno)
        labelArtista.translatesAutoresizingMaskIntoConstraints = false
        labelAno.translatesAutoresizingMaskIntoConstraints = false
        labelTitulo.translatesAutoresizingMaskIntoConstraints = false
        labelArtista.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200).isActive = true
        labelArtista.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        labelArtista.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        
        labelTitulo.topAnchor.constraint(equalTo: labelArtista.bottomAnchor, constant: 10).isActive = true
        labelTitulo.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        labelAno.topAnchor.constraint(equalTo: labelTitulo.bottomAnchor, constant: 10).isActive = true
        labelAno.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
    }
    
    func setPicker(){
        view.addSubview(pickerImage)
        pickerImage.translatesAutoresizingMaskIntoConstraints = false
        pickerImage.topAnchor.constraint(equalTo: labelAno.bottomAnchor).isActive = true
        pickerImage.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        pickerImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        pickerImage.heightAnchor.constraint(equalToConstant: 300).isActive = true 
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tootlePicker))
        pickerImage.addGestureRecognizer(gesture)
    }
    
    @objc func tootlePicker(){
        self.imagePicker.allowsEditing = false
        self.imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
}


extension AddAlbum: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.pickerImage.contentMode = .scaleAspectFit
            if let data = image.pngData() {
                pickerImage.image = UIImage(data: data)
                imageData = data
                print(data)
            }
        }
        dismiss(animated: true, completion: nil)
    }
}
