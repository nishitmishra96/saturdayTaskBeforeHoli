import UIKit
import Photos
class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
   @IBOutlet weak var post: UICollectionView!
    @IBOutlet weak var category: UICollectionView!
    @IBOutlet weak var image: UIImageView!
    
    var imageArray=[UIImage]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
    
           let cell = category.dequeueReusableCell(withReuseIdentifier: "cellforlabel", for: indexPath) as! classforcellCollectionViewCell
        
            cell.image?.image = imageArray[indexPath.item]

        
         return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        category.register(UINib(nibName: "classforcellCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cellforlabel")
        category.delegate = self
        category.dataSource = self
        post.register(UINib(nibName: "ClassForAllignmentDataInFolder", bundle: nil), forCellWithReuseIdentifier: "cellforimage")
        post.delegate = self
        post.dataSource = self
        grabPhotos()

    }
    
    func grabPhotos(){
        imageArray = []
        
        DispatchQueue.global(qos: .background).async {
            print("This is run on the background queue")
            let imgManager=PHImageManager.default()
            
            let requestOptions=PHImageRequestOptions()
            requestOptions.isSynchronous=true
            requestOptions.deliveryMode = .highQualityFormat
            
            let fetchOptions=PHFetchOptions()
            fetchOptions.sortDescriptors=[NSSortDescriptor(key:"creationDate", ascending: false)]
            
            let fetchResult: PHFetchResult = PHAsset.fetchAssets(with: .image, options: fetchOptions)
            print(fetchResult.count)
            if fetchResult.count > 0 {
                for i in 0..<fetchResult.count{
                    imgManager.requestImage(for: fetchResult.object(at: i) as PHAsset, targetSize: CGSize(width:500, height: 500),contentMode: .aspectFill, options: requestOptions, resultHandler: { (image, error) in
                        self.imageArray.append(image!)
                    })
                }
            } else {
                print("You got no photos.")
            }
            print("imageArray count: \(self.imageArray.count)")
            
            DispatchQueue.main.async {
                print("This is run on the main queue, after the previous code in outer block")
                print(self.imageArray.count)
                self.category.reloadData()
            }
        }
    }

}
