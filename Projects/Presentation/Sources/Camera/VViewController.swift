//
//  VViewController.swift
//  Today_Memory_iOS
//
//  Created by 박준하 on 2023/07/11.
//
import UIKit
import PhotosUI
import SnapKit

class VViewController: UIViewController {
    
    private var selections = [String : PHPickerResult]()
    private var selectedAssetIdentifiers = [String]()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.spacing = 10
        stack.axis = .vertical
        stack.distribution = .equalCentering
        return stack
    }()
    
    lazy var button: UIButton = {
        let button = UIButton(frame: CGRect(x: (view.frame.width/2)-50, y: 720, width: 100, height: 60))
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 20
        button.setTitle("PHPicker", for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(button)
        view.addSubview(stackView)
        
        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(20)
        }
        
        button.addTarget(self, action: #selector(buttonHandler), for: .touchUpInside)
    }
    
    @objc func buttonHandler(_ sender: UIButton) {
        presentPicker()
    }
    
    private func presentPicker() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = PHPickerFilter.any(of: [.images])
        config.selectionLimit = 3
        config.selection = .ordered
        config.preferredAssetRepresentationMode = .current
        config.preselectedAssetIdentifiers = selectedAssetIdentifiers
        
        let imagePicker = PHPickerViewController(configuration: config)
        imagePicker.delegate = self
        
        self.present(imagePicker, animated: true)
    }
    
    
    private func displayImage() {
        self.stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let dispatchGroup = DispatchGroup()
        var imagesDict = [String: UIImage]()

        for (identifier, result) in selections {
            
            dispatchGroup.enter()
                        
            let itemProvider = result.itemProvider
            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    
                    guard let image = image as? UIImage else { return }
                    
                    imagesDict[identifier] = image
                    dispatchGroup.leave()
                }
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            
            guard let self = self else { return }
            
            for identifier in self.selectedAssetIdentifiers {
                guard let image = imagesDict[identifier] else { return }
                self.addImage(image)
            }
        }
    }
    
    
    private func addImage(_ image: UIImage) {
        
        let imageView = UIImageView()
        imageView.image = image
        
        imageView.snp.makeConstraints {
            $0.width.height.equalTo(200)
        }
        
        self.stackView.addArrangedSubview(imageView)
    }
}



extension VViewController : PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        
        var newSelections = [String: PHPickerResult]()
        
        for result in results {
            let identifier = result.assetIdentifier!
            newSelections[identifier] = selections[identifier] ?? result
        }
        
        selections = newSelections
        selectedAssetIdentifiers = results.compactMap { $0.assetIdentifier }
        
        if selections.isEmpty {
            stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        } else {
            displayImage()
        }
    }
}
