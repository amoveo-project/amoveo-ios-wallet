//
// Created by Igor Efremov on 27/11/2018.
// Copyright (c) 2018 Exantech. All rights reserved.
//

import UIKit
import SnapKit
import BetterSegmentedControl

final class AlternativeCurrencyViewController: CommonViewLayer, UIPickerViewDelegate, UIPickerViewDataSource, UIGestureRecognizerDelegate {
    private let downArrow: UIImageView = {
        let iv = UIImageView(image: EXAGraphicsResources.downArrow)
        return iv
    }()

    private let currentCurrencyTitleLabel: AWLabel = {
        let lbl = AWLabel("Choose currency")
        lbl.textColor = UIColor.awGray
        lbl.textAlignment = .left
        lbl.font = UIFont.awFont(ofSize: 12.0, type: .regular)
        return lbl
    }()

    private let currentCurrencyActionLabel: AWLabel = {
        let lbl = AWLabel("")
        lbl.textColor = UIColor.white
        lbl.font = UIFont.awFont(ofSize: 16.0, type: .regular)
        return lbl
    }()

    private let lineView: UIView = {
        let v = UIView(frame: CGRect.zero)
        v.backgroundColor = UIColor.exaPlaceholderColor

        return v
    }()

    private let showInDashboardTitleLabel: AWLabel = {
        let lbl = AWLabel("Show in Dashboard")
        lbl.textColor = UIColor.awGray
        lbl.textAlignment = .left
        lbl.font = UIFont.awFont(ofSize: 12.0, type: .regular)
        return lbl
    }()

    private let typeOfInfoInDashboardSelectorControl = BetterSegmentedControl(
            frame: CGRect(x: 20, y: 0, width: 300, height: 36),
            segments: LabelSegment.segments(withTitles: AlternativeCurrencyTypeShow.all.map { $0.title },
                    normalFont: UIFont.awFont(ofSize: 16.0, type: .medium),
                    normalTextColor: UIColor.rgb(0x8a8c96),
                    selectedFont: UIFont.awFont(ofSize: 16.0, type: .medium),
                    selectedTextColor: UIColor.mainColor),
            index: 0, options: [.backgroundColor(.white), .indicatorViewBackgroundColor(UIColor.awYellow)])

    private let picker: UIPickerView = {
        let p = UIPickerView()
        p.backgroundColor = UIColor.white
        p.layer.cornerRadius = 10.0
        p.showsSelectionIndicator = true

        return p
    }()

    var pickerHidden = true

    private let ds: [String] = AlternativeCurrency.all.map{ $0.rawValue }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBackButton()
    }

    func applyStyles() {
        navigationItem.title = "Alternative currency"
        view.backgroundColor = UIColor.mainColor

        typeOfInfoInDashboardSelectorControl.applyStyles()
    }

    func applyLayout() {
        let sideOffset = 20
        currentCurrencyTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(20)
            make.width.equalToSuperview().inset(sideOffset)
            make.height.equalTo(14)
        }

        currentCurrencyActionLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(currentCurrencyTitleLabel.snp.bottom).offset(10)
            make.width.equalToSuperview().inset(sideOffset)
            make.height.equalTo(20)
        }

        downArrow.snp.makeConstraints { (make) in
            make.top.equalTo(currentCurrencyActionLabel.snp.centerY)
            make.right.equalToSuperview().offset(-sideOffset)
            make.width.equalTo(EXAGraphicsResources.downArrow.size.width)
            make.height.equalTo(EXAGraphicsResources.downArrow.size.height)
        }

        lineView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(currentCurrencyActionLabel.snp.bottom).offset(10)
            make.width.equalToSuperview().inset(sideOffset)
            make.height.equalTo(1)
        }

        showInDashboardTitleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(currentCurrencyActionLabel.snp.bottom).offset(40)
            make.width.equalToSuperview().inset(sideOffset)
            make.height.equalTo(14)
        }

        typeOfInfoInDashboardSelectorControl.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(showInDashboardTitleLabel.snp.bottom).offset(10)
            make.width.equalToSuperview().inset(sideOffset)
            make.height.equalTo(36)
        }

        picker.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.bottom.equalToSuperview().offset(230)
            make.width.equalToSuperview()
            make.height.equalTo(44 * 5)
        }
    }

    @objc func onTapCurrency() {
        togglePicker()
    }

    private func hidePicker() {
        if !pickerHidden {
            togglePicker()

            if let theStringValue = currentCurrencyActionLabel.text {
                if let theSelectedCurrency = AlternativeCurrency(rawValue: theStringValue) {
                    AppState.sharedInstance.settings.selectedCurrency = theSelectedCurrency
                }
            }
        }
    }

    private func togglePicker() {
        pickerHidden = !pickerHidden
        let pickerHeight = pickerHidden ? 230 : 10

        UIView.animate(withDuration: 0.6) {
            self.picker.snp.updateConstraints { (make) in
                make.bottom.equalToSuperview().offset(pickerHeight)
            }
            self.view.layoutIfNeeded()
        }
    }

    @objc func onTap() {
        hidePicker()
    }

    func applyDefaultValues() {
        currentCurrencyActionLabel.text = AppState.sharedInstance.settings.selectedCurrency.rawValue

        picker.delegate = self
        picker.dataSource = self
        picker.selectRow(AppState.sharedInstance.settings.selectedCurrency.index , inComponent: 0, animated: false)

        let tap = UITapGestureRecognizer(target: self, action: #selector(AlternativeCurrencyViewController.pickerTapped(_:)))
        tap.cancelsTouchesInView = false
        tap.delegate = self
        picker.addGestureRecognizer(tap)

        currentCurrencyActionLabel.addTapTouch(self, action: #selector(onTapCurrency))
        self.view.addTapTouch(self, action: #selector(onTap))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let theType = AlternativeCurrencyTypeShow(rawValue: Int(typeOfInfoInDashboardSelectorControl.index)) {
            AppState.sharedInstance.settings.showInDashboard = theType
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentCurrencyActionLabel.text = ds[row]
    }

    @objc func pickerTapped(_ tapRecognizer: UITapGestureRecognizer) {
        if tapRecognizer.state == UIGestureRecognizer.State.ended {
            let rowHeight : CGFloat  = picker.rowSize(forComponent: 0).height
            let selectedRowFrame: CGRect = picker.bounds.insetBy(dx: 0.0, dy: (picker.frame.size.height - rowHeight) / 2.0 )
            let userTappedOnSelectedRow = selectedRowFrame.contains(tapRecognizer.location(in: picker))
            if userTappedOnSelectedRow {
                hidePicker()
            }
        }
    }

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ds.count
    }

    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        guard row < ds.count else {
            return nil
        }

        return NSAttributedString(string: ds[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor.mainColor,
                                                            NSAttributedString.Key.font: UIFont.awFont(ofSize: 42.0, type: .bold)])
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
}

private extension AlternativeCurrencyViewController {

    func addSubviews() {
        let allSubviews = [currentCurrencyTitleLabel, currentCurrencyActionLabel, downArrow, lineView, showInDashboardTitleLabel, typeOfInfoInDashboardSelectorControl, picker]
        view.addMultipleSubviews(with: allSubviews)
    }

    func setupView() {
        addSubviews()
        applyStyles()
        applyLayout()
        applyDefaultValues()
    }
}
