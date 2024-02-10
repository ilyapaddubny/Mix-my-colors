//
//  ColorPickerView.swift
//  Mix my colors
//
//  Created by Ilya Paddubny on 08.02.2024.
//

import UIKit

protocol ColorPickerViewDelegate: AnyObject {
    func presentColorPicker(for colorPicker: ColorPickerView)
}

class ColorPickerView: UIView  {
    weak var delegate: ColorPickerViewDelegate?

    let defaultLocalizer = LocalizeUtils.defaultLocalizer
    let colorLabel = UILabel()
    let colorCircleButton = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 150))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    
    func configureUI() {
        configureColorPickerView()
    }
    
    func configureColorPickerView() {
        configureLabel()
        configureColoredButton()
        updateColorLabel()
    }
    
    func configureLabel() {
        addSubview(colorLabel)
        colorLabel.textAlignment = .center
        colorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            colorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            colorLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
            colorLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            colorLabel.topAnchor.constraint(equalTo: topAnchor, constant: 70)
        ])
    }
    
    func configureColoredButton() {
        addSubview(colorCircleButton)
        colorCircleButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            colorCircleButton.widthAnchor.constraint(equalToConstant: 150),
            colorCircleButton.heightAnchor.constraint(equalToConstant: 150),
            colorCircleButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            colorCircleButton.topAnchor.constraint(equalTo: colorLabel.topAnchor, constant: 30)
        ])
        
        colorCircleButton.backgroundColor = .red
        colorCircleButton.layer.cornerRadius = colorCircleButton.frame.height / 2.0
        colorCircleButton.layer.borderWidth = 4.0
        colorCircleButton.layer.borderColor = UIColor.gray.cgColor
        colorCircleButton.addTarget(self, action: #selector(onButtonTapped), for: .touchUpInside) // Add this line
    }
    
    @objc private func onButtonTapped() {
        delegate?.presentColorPicker(for: self)
    }
    
    func updateColorLabel() {
        if let colorDescription = colorCircleButton.backgroundColor?.accessibilityName {
            colorLabel.text = defaultLocalizer.colorNameLocalizer(colorDescription)
        }
    }
    
}


