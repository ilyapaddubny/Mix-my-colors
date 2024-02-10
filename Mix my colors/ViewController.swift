//
//  ViewController.swift
//  Mix my colors
//
//  Created by Ilya Paddubny on 08.02.2024.
//

import UIKit


class ViewController: UIViewController, ColorPickerViewDelegate, UIColorPickerViewControllerDelegate {
    var firstColorPicker: ColorPickerView!
    var activeColorPicker: ColorPickerView?
    let resultLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 400, height: 50))
    let segmentedControl = UISegmentedControl(items: ["RU", "EN"])
    var secondColorPicker: ColorPickerView!
    let defaultLocalizer = LocalizeUtils.defaultLocalizer
    
    let resultView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        defaultLocalizer.setSelectedLanguage(lang: "ru")
        firstColorPicker = ColorPickerView()
        secondColorPicker = ColorPickerView()
        firstColorPicker.delegate = self
        secondColorPicker.delegate = self
        configureUI()
        mixResultColor()
        self.title = defaultLocalizer.stringFor(key: "Mix my colors")
        
    }
    
    func configureUI() {
        configureFirstPicker()
        configureSecondPicker()
        configureResultView()
        configureResultLabel()
        configureLanguageSegmentController()
    }
    
    private func configureFirstPicker() {
        view.addSubview(firstColorPicker)
        firstColorPicker.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            firstColorPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            firstColorPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            firstColorPicker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -50),
            firstColorPicker.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func configureSecondPicker() {
        view.addSubview(secondColorPicker)
        secondColorPicker.translatesAutoresizingMaskIntoConstraints = false
        secondColorPicker.colorCircleButton.backgroundColor = .blue
        secondColorPicker.updateColorLabel()
        
        NSLayoutConstraint.activate([
            secondColorPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            secondColorPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            secondColorPicker.topAnchor.constraint(equalTo: firstColorPicker.bottomAnchor),
            secondColorPicker.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    private func configureResultView() {
        view.addSubview(resultView)
        resultView.translatesAutoresizingMaskIntoConstraints = false
        resultView.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            resultView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resultView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            resultView.topAnchor.constraint(equalTo: secondColorPicker.bottomAnchor),
            resultView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        ])
    }
    
    func presentColorPicker(for colorPicker: ColorPickerView) {
        activeColorPicker = colorPicker
        let colorPickerVC = UIColorPickerViewController()
        colorPickerVC.supportsAlpha = false
        colorPickerVC.delegate = self
        present(colorPickerVC, animated: true)
    }
    
    func colorPickerViewController(_ viewController: UIColorPickerViewController,
                                   didSelect color: UIColor,
                                   continuously: Bool) {
        activeColorPicker?.colorCircleButton.backgroundColor = color
        activeColorPicker?.updateColorLabel()
        mixResultColor()
    }
    
    private func mixResultColor() {
        var redFirst: CGFloat = 0
        var greenFirst: CGFloat = 0
        var blueFirst: CGFloat = 0
        
        var redSecond: CGFloat = 0
        var greenSecond: CGFloat = 0
        var blueSecond: CGFloat = 0
        var alpha: CGFloat = 1
        
        firstColorPicker.colorCircleButton.backgroundColor?.getRed(&redFirst, green: &greenFirst, blue: &blueFirst, alpha: &alpha)
        secondColorPicker.colorCircleButton.backgroundColor?.getRed(&redSecond, green: &greenSecond, blue: &blueSecond, alpha: &alpha)
        
        let redMixed    = (redFirst + redSecond) / 2.0
        let greenMixed  = (greenFirst + greenSecond) / 2.0
        let blueMixed   = (blueFirst + blueSecond) / 2.0
        
        resultView.backgroundColor = UIColor(red: redMixed, green: greenMixed, blue: blueMixed, alpha: alpha)
        
        configureResultLabel()
    }

    func configureResultLabel() {
        view.addSubview(resultLabel)
        resultLabel.textAlignment = .center
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            resultLabel.bottomAnchor.constraint(equalTo: resultView.topAnchor, constant: -6),
        ])
        
        updateResultColorLabel()
    }
    
    func configureLanguageSegmentController() {
        // Set the frame and position it in the bottom-left corner
        let screenHeight = UIScreen.main.bounds.height
        let segmentWidth: CGFloat = 80
        let segmentHeight: CGFloat = 30
        let segmentX = 20
        let segmentY = Int(screenHeight) - 40 - Int(segmentHeight) // 20 points from bottom
        segmentedControl.frame = CGRect(x: CGFloat(segmentX), y: CGFloat(segmentY), width: segmentWidth, height: segmentHeight)
        
        // Set the initial selected segment index
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(languageChanged(_:)), for: .valueChanged)
        
        view.addSubview(segmentedControl)
    }
    
    @objc func languageChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            defaultLocalizer.setSelectedLanguage(lang: "ru")
            
        case 1:
            defaultLocalizer.setSelectedLanguage(lang: "en")
            
        default:
            break
        }
        
        self.refreshlabels()
    }
    
    func refreshlabels() {
        self.title = defaultLocalizer.stringFor(key: "Mix my colors")
        firstColorPicker.updateColorLabel()
        secondColorPicker.updateColorLabel()
        updateResultColorLabel()
    }
    
    func updateResultColorLabel() {
        if let colorDescription = resultView.backgroundColor?.accessibilityName {
            resultLabel.text = defaultLocalizer.colorNameLocalizer(colorDescription)
        }
    }
    
}


