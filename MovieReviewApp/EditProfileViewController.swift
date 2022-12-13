//
//  EditProfileViewController.swift
//  MovieReviewApp
//
//  Created by 김도현 on 2022/12/08.
//

import UIKit

struct Profile {
    var nickname: String
    var introduction: String
    var profileImage: UIImage?
    
    init(nickname: String, introduction: String = "", profileImage: UIImage?) {
        self.nickname = nickname
        self.introduction = introduction
        self.profileImage = profileImage
    }
}

class EditProfileViewController: UIViewController {
    
    let profileImageView: UIImageView  = {
        let imageView: UIImageView = UIImageView(image: UIImage(systemName: "person.fill"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .systemGray3
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        imageView.largeContentImageInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let nameLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.text = "이름"
        label.textColor = .systemGray4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let nameTextFiled: UITextField = {
        let textfiled: UITextField = UITextField()
        textfiled.textColor = .black
        textfiled.font = .systemFont(ofSize: 14, weight: .medium)
        textfiled.translatesAutoresizingMaskIntoConstraints = false
        return textfiled
    }()
    let introductionLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.text = "소개"
        label.textColor = .systemGray4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let introductionTextFiled: UITextField = {
        let textfiled: UITextField = UITextField()
        textfiled.textColor = .black
        textfiled.font = .systemFont(ofSize: 14, weight: .medium)
        textfiled.placeholder = "소개를 입력해주세요."
        textfiled.translatesAutoresizingMaskIntoConstraints = false
        return textfiled
    }()
    let pickerViewController: UIImagePickerController = UIImagePickerController()
    var profile: Profile?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        title = "프로필 변경"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonClick))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "확인", style: .done, target: self, action: #selector(doneButtonClick))
                
        pickerViewController.delegate = self
        
        viewAdd()
        viewAutoLayoutSetting()
    }
    
    private func viewAdd() {
        view.addSubview(profileImageView)
        view.addSubview(nameLabel)
        view.addSubview(nameTextFiled)
        view.addSubview(introductionLabel)
        view.addSubview(introductionTextFiled)
    }
    
    private func viewAutoLayoutSetting() {
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        let profileImageViewConstraints = [
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            profileImageView.widthAnchor.constraint(equalToConstant: 50)
        ]
        
        let nameLabelConstraints = [
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 20),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
        ]
        
        let nameTextFiledConstraints = [
            nameTextFiled.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            nameTextFiled.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            nameTextFiled.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ]
        
        let introductionLabelConstraints = [
            introductionLabel.topAnchor.constraint(equalTo: nameTextFiled.bottomAnchor, constant: 20),
            introductionLabel.leadingAnchor.constraint(equalTo: nameTextFiled.leadingAnchor)
        ]
        
        let introductionTextFiledConstraints = [
            introductionTextFiled.topAnchor.constraint(equalTo: introductionLabel.bottomAnchor, constant: 5),
            introductionTextFiled.leadingAnchor.constraint(equalTo: nameTextFiled.leadingAnchor),
            introductionTextFiled.trailingAnchor.constraint(equalTo: nameTextFiled.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(profileImageViewConstraints)
        NSLayoutConstraint.activate(nameLabelConstraints)
        NSLayoutConstraint.activate(nameTextFiledConstraints)
        NSLayoutConstraint.activate(introductionLabelConstraints)
        NSLayoutConstraint.activate(introductionTextFiledConstraints)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        
        let cameraGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(photoPresent))
        
        let cameraImageView = UIImageView(image: UIImage(systemName: "camera.fill"))
        cameraImageView.frame.size = CGSize(width: 30, height: 20)
        cameraImageView.tintColor = .white
        cameraImageView.center = profileImageView.center
        cameraImageView.addGestureRecognizer(cameraGestureRecognizer)
        cameraImageView.isUserInteractionEnabled = true
        
        view.addSubview(cameraImageView)
    }
    
    @objc
    func photoPresent() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "직접 찍기", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "앨범에서 선택", style: .default, handler: { _ in
            self.openLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "삭제하기", style: .default, handler: { _ in
            self.removeProfileImage()
        }))
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        cancelAction.setValue(UIColor.systemPink, forKey: "titleTextColor")
        
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true)
    }
    
    private func removeProfileImage() {
        profileImageView.image = UIImage(systemName: "person.fill")
    }
    
    @objc
    func cancelButtonClick() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    func  doneButtonClick() {
        navigationController?.popViewController(animated: true)
    }

}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func openLibrary() {
        pickerViewController.sourceType = .photoLibrary
        present(pickerViewController, animated: true)
    }
    
    private func openCamera() {
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            pickerViewController.sourceType = .camera
            present(pickerViewController, animated: true)
        } else {
            print("Camera not available")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = image
        }

        dismiss(animated: true, completion: nil)

    }
}
