import UIKit

class PerformanceMeasurementViewController: UIViewController {

    var layerTableView: LayerTableView!
    var collectionTableView: CollectionTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Run CALayer measurement first
        runCALayerMeasurement()
    }
    
    func runCALayerMeasurement() {
        // Remove any previous views
        removeCurrentView()
        
        // Create LayerTableView and add it
        layerTableView = LayerTableView(frame: self.view.bounds)
        self.view.addSubview(layerTableView)
        
        // Start measuring performance for CALayer
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            print("Starting CALayer table layout measurement...")
            self?.layerTableView.measureLayerLayoutPerformance() // This will print the layout time
            
            // After CALayer test, run the UICollectionView test
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self?.runCollectionViewMeasurement()
            }
        }
    }
    
    func runCollectionViewMeasurement() {
        // Remove LayerTableView
        removeCurrentView()
        
        // Create CollectionTableView and present it
        collectionTableView = CollectionTableViewController()
        addChild(collectionTableView)
        collectionTableView.view.frame = self.view.bounds
        self.view.addSubview(collectionTableView.view)
        collectionTableView.didMove(toParent: self)
        
        // Start measuring performance for UICollectionView
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            print("Starting UICollectionView table layout measurement...")
            self?.collectionTableView.setupCollectionView()
            
            // UICollectionView layout measurement happens during the collection view's layout process
            // This will print the layout time after the first and last cell's layout
        }
    }
    
    // Helper function to remove the current view (LayerTableView or CollectionTableView)
    func removeCurrentView() {
        self.view.subviews.forEach { $0.removeFromSuperview() }
    }
}
