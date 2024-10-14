//
//  TableImplementation.swift
//  PerfComparison
//
//  Created by Fan Yang on 10/13/24.
//

import UIKit

class LayerTableView: UIView {

    var displayLink: CADisplayLink!
    var frameCount = 0
    var startTime: CFTimeInterval = 0

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTableWithCALayer()
        measureLayerLayoutPerformance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupTableWithCALayer() {
        let numberOfRows = 1000
        let rowHeight: CGFloat = 40
        let tableWidth = self.bounds.width
        
        for i in 0..<numberOfRows {
            let rowLayer = CALayer()
            rowLayer.frame = CGRect(x: 0, y: CGFloat(i) * rowHeight, width: tableWidth, height: rowHeight)
            rowLayer.backgroundColor = UIColor.lightGray.cgColor
            self.layer.addSublayer(rowLayer)
            
            let textLayer = CATextLayer()
            textLayer.frame = CGRect(x: 10, y: 10, width: 200, height: 20)
            textLayer.string = "Row \(i + 1)"
            textLayer.foregroundColor = UIColor.black.cgColor
            textLayer.fontSize = 16
            rowLayer.addSublayer(textLayer)
        }
    }
    
    func measureLayerLayoutPerformance() {
        startTime = CFAbsoluteTimeGetCurrent() // Start timing
        
        let numberOfRows = 1000
        let rowHeight: CGFloat = 40
        let tableWidth = self.bounds.width
        
        for i in 0..<numberOfRows {
            let rowLayer = CALayer()
            rowLayer.frame = CGRect(x: 0, y: CGFloat(i) * rowHeight, width: tableWidth, height: rowHeight)
            rowLayer.backgroundColor = UIColor.lightGray.cgColor
            self.layer.addSublayer(rowLayer)
            
            let textLayer = CATextLayer()
            textLayer.frame = CGRect(x: 10, y: 10, width: 200, height: 20)
            textLayer.string = "Row \(i + 1)"
            textLayer.foregroundColor = UIColor.black.cgColor
            textLayer.fontSize = 16
            rowLayer.addSublayer(textLayer)
        }
        
        let endTime = CFAbsoluteTimeGetCurrent() // End timing
        print("CALayer layout took \(endTime - startTime) seconds.")
    }
    
    deinit {
        displayLink.invalidate()
    }
}

import UIKit

class CollectionTableViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var collectionView: UICollectionView!
    var displayLink: CADisplayLink!
    var frameCount = 0
    var startTime: CFTimeInterval = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.bounds.width, height: 40)
        
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        
        self.view.addSubview(collectionView)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1000 // Handling large number of rows to test performance
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        cell.backgroundColor = .lightGray
        
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: 200, height: 20))
        label.text = "Row \(indexPath.item + 1)"
        label.textColor = .black
        cell.contentView.addSubview(label)
        
        return cell
    }
    
    // UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            startTime = CFAbsoluteTimeGetCurrent() // Start timing at the first cell layout
        }
        
        if indexPath.item == 999 { // Assuming last item
            let endTime = CFAbsoluteTimeGetCurrent() // End timing after last item
            print("UICollectionView layout took \(endTime - startTime) seconds.")
        }
        
        return CGSize(width: self.view.bounds.width, height: 40)
    }
    
    deinit {
        displayLink.invalidate()
    }
}
