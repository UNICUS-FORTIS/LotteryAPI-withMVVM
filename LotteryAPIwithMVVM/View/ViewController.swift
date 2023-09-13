//
//  ViewController.swift
//  LotteryAPIwithMVVM
//
//  Created by LOUIE MAC on 2023/09/14.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private let viewModel = LotteryViewModel()
    let pickerView = UIPickerView()
    
    lazy var numberTextField: UITextField = {
        let tf = UITextField()
        tf.inputView = pickerView
        tf.tintColor = .clear
        tf.backgroundColor = .lightGray
        tf.placeholder = "터치해서 회차를 선택하세요"
        tf.textAlignment = .center
        return tf
    }()
    
    private var winningNumberCollection: [UILabel] = (1...7).map { _ in
        let label = UILabel()
        label.text = ""
        label.textColor = .systemPink
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.text = "당신은 ~ 안돼는!! 로또당첨번호!!!"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20)
        return label
    }()
    
    private let stackView: UIStackView = {
       let sv = UIStackView()
        sv.axis = .horizontal
        sv.alignment = .center
        sv.distribution = .equalSpacing
        return sv
    }()
    
    private let firstWinningAmount: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        label.text = ""
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configures()
        setConstraints()
        bind()
    }
    
    private func configures() {
        view.backgroundColor = .white
        pickerView.delegate = self
        pickerView.dataSource = self
        view.addSubview(numberTextField)
        view.addSubview(welcomeLabel)
        view.addSubview(stackView)
        view.addSubview(firstWinningAmount)
        winningNumberCollection.forEach { stackView.addArrangedSubview($0) }
        viewModel.makeRound()
    }
    
    private func bind() {
        for (idx, obj) in winningNumberCollection.enumerated() {
            let object = viewModel.numbersArray[idx]
            object.bind { text in
                obj.text = "\(text)"
            }
        }
        viewModel.winning.bind { number in
            self.firstWinningAmount.text = "1등 당첨금: \(number)원"
        }
    }
    
    private func setConstraints() {
        numberTextField.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.08)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(30)
            make.centerX.equalToSuperview()
        }
        
        welcomeLabel.snp.makeConstraints { make in
            make.top.equalTo(numberTextField.snp.bottom).offset(50)
            make.width.equalToSuperview().multipliedBy(0.8)
            make.height.equalToSuperview().multipliedBy(0.1)
            make.centerX.equalToSuperview()
        }
        
        stackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.equalTo(view).multipliedBy(0.1)
            make.width.equalTo(view).multipliedBy(0.8)
        }
        
        firstWinningAmount.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(stackView.snp.bottom).offset(30)
            make.height.equalTo(view).multipliedBy(0.1)
            make.width.equalTo(view).multipliedBy(0.8)
        }

    }
    
}

extension ViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      
        let row = viewModel.dateArray[row]
        
        viewModel.fetchLottoAPI(round: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(viewModel.dateArray[row])"
    }
}

extension ViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.numberOfInComponent()
    }
}
