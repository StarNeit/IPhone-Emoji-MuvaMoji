//
//  MainViewController.swift
//  MuvaMojiKeyboard
//
//  Created by Borys on 2/23/16.
//  Copyright © 2016 MuvaMoji. All rights reserved.
//

import UIKit
import AssetsLibrary
class MainViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    let LBLDONTTAG:Int = 1001
    let VIEWSIZETAG:Int = 1002
    let CAROUSELTAG:Int = 1003
    let TONESVIEWTAG:Int = 1004
    let SLIDERTAG:Int = 1005
    let SMALLCIRCLETAG:Int = 1006
    let LARGECIRCLETAG:Int = 1007
    let BTNINSTAGRAMSHARE:Int = 1008
    // the collection view for the categories
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    @IBOutlet weak var pageCollectionView:UICollectionView!
    
    var memeArray = Array<Array<String>>()
    var currentIndex = 1
    var nCarouselIndex = 0
    var sizeRatio:CGFloat = 5.5
    var arrSizeSetter:NSMutableArray!
    var categoryArray = Array<String>()
    var library:ALAssetsLibrary!
    var docController = UIDocumentInteractionController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initMemes()
    }
    
    // jb1-15-2016
    func initMemes() {
        
        for var i = 1; i <= 14; i++ {
            categoryArray.append("\(i).png")
        }
        let arrAB:Array<String> = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
        var nAB = -1
        
        outside:repeat{
            nAB++
            let catePath = NSBundle.mainBundle().pathForResource("\(arrAB[nAB])1", ofType:"png")
            if catePath == nil
            {
                break outside
            }
            var i = 0
            var aArray = Array<String>()
        inside:repeat{
            i++
            let tonePath = NSBundle.mainBundle().pathForResource("\(arrAB[nAB])\(i)", ofType:"png")
            
            if tonePath == nil
            {
                break inside
            }
            aArray.append("\(arrAB[nAB])\(i).png")
        }while(1 == 1)
            memeArray.append(aArray)
        }while (1 == 1)
        
        //GIF Animations
        var gaArray = Array<String>()
        for var i = 1; i <= 14; i++
        {
            gaArray.append("ga\(i).gif")
        }
        memeArray.append(gaArray)
    }
    
    // collection view method -> number of items in section
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section:Int)->Int {
        if collectionView.isEqual(categoriesCollectionView) {
            return memeArray.count + 1
        }
        else if collectionView.isEqual(pageCollectionView)
        {
            return memeArray.count + 1
        }
        else {
            let idx = collectionView.tag - 30000
            if idx == 0
            {
                var arrEmoji:NSMutableArray = NSMutableArray()
                if NSUserDefaults.init(suiteName: "group.appmoji.muvamoji")!.valueForKey("RECENTMUVAMOJI") != nil
                {
                    arrEmoji = NSMutableArray(array: NSUserDefaults.init(suiteName: "group.appmoji.muvamoji")!.valueForKey("RECENTMUVAMOJI") as! NSArray)
                }
                return arrEmoji.count
            }
            else
            {
                return memeArray[idx - 1].count
            }
        }
    }
    
    // collection view method -> cell for row at index path
    internal func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        if collectionView.isEqual(categoriesCollectionView) {
             let cell:CategoryCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell1", forIndexPath: indexPath) as! CategoryCell
            
            var filePath:String!
            
            if indexPath.row == 0
            {
                filePath = NSBundle.mainBundle().pathForResource("Recent", ofType: "png")
               cell.imgView.image = UIImage(contentsOfFile: filePath)
                
            }
            else
            {
                if categoryArray[indexPath.row - 1].componentsSeparatedByString(".").last == "png"
                {
                    filePath = NSBundle.mainBundle().pathForResource(categoryArray[indexPath.row - 1].componentsSeparatedByString(".").first, ofType: "png")
                    cell.imgView.image = UIImage(contentsOfFile: filePath)
                }
                else
                {
                    cell.imgView.image = nil
                    filePath = NSBundle.mainBundle().pathForResource(String(format:"%@t", categoryArray[indexPath.row - 1].componentsSeparatedByString(".").first!), ofType: "gif")
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
                        let img:UIImage! = UIImage.gifWithURL(NSURL(fileURLWithPath: filePath).absoluteString)
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            cell.imgView.image = img
                        })
                    })
//                    YLGIFImage.setPrefetchNum(5)
//                    cell.imgView.image = YLGIFImage(contentsOfFile: NSURL(fileURLWithPath: filePath).absoluteString)
                }
            }
           
            cell.tag = indexPath.row + 20000
            
            if currentIndex == indexPath.row {
//                cell.backgroundColor = UIColor.whiteColor()
                cell.backView.image = UIImage(named: "TopTabArrow.png")
                if indexPath.row != 0 && categoryArray[indexPath.row - 1].componentsSeparatedByString(".").last == "png"
                {
                    filePath = NSBundle.mainBundle().pathForResource(String(format: "%@x", categoryArray[indexPath.row - 1].componentsSeparatedByString(".").first!), ofType: "png")
                    cell.imgView.image = UIImage(contentsOfFile: filePath)
                }
                if indexPath.row == 0
                {
                    let filePath = NSBundle.mainBundle().pathForResource("Recent", ofType: "png")
                   cell.imgView.image = UIImage(contentsOfFile: filePath!)
                }
                pageCollectionView.selectItemAtIndexPath(NSIndexPath(forRow: currentIndex, inSection: 0), animated: false, scrollPosition: UICollectionViewScrollPosition.Left)
            }
            else {
                cell.backView.image = UIImage(named: "NormalTab.png")
                
//                cell.backgroundColor = UIColor(red: 240 / 255, green: 240 / 255, blue: 240 / 255, alpha: 1)
            }
            return cell
        }
        else if collectionView.isEqual(pageCollectionView)
        {
            let cell:PageCell! = collectionView.dequeueReusableCellWithReuseIdentifier("PageCell", forIndexPath: indexPath) as! PageCell
            cell.innerCollectionView.tag = indexPath.row + 30000
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
//                cell.innerCollectionView.reloadData()
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                cell.innerCollectionView.reloadData()
                })
            })
            
            return cell
            
        }
        else {
            let idx = collectionView.tag - 30000
            let cell:MemeCell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell2", forIndexPath: indexPath) as! MemeCell
            if idx == 0
            {
                var arrEmoji:NSMutableArray = NSMutableArray()
                if NSUserDefaults.init(suiteName: "group.appmoji.muvamoji")!.valueForKey("RECENTMUVAMOJI") != nil
                {
                    arrEmoji = NSMutableArray(array: NSUserDefaults.init(suiteName: "group.appmoji.muvamoji")!.valueForKey("RECENTMUVAMOJI") as! NSArray)
                }
                var filePath:String!
                if arrEmoji[indexPath.row].componentsSeparatedByString(".").last == "png"
                {
//                    cell.imgView.image = nil
//                    let img:UIImage! = UIImage(named: arrEmoji[indexPath.row] as! String)
//                    cell.imgView.image = img
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
                        let img:UIImage! = UIImage(named: arrEmoji[indexPath.row] as! String)
                        let resimg:UIImage! = self.resizeWithAspect_doResize(img, size: CGSizeMake(100, 100))
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            cell.imgView.image = resimg
                        })
                    })

                }
                else
                {
                    cell.imgView.image = nil
                    filePath = NSBundle.mainBundle().pathForResource(String(format: "%@t",arrEmoji[indexPath.row].componentsSeparatedByString(".").first!), ofType: "gif")
//                    YLGIFImage.setPrefetchNum(5)
//                    cell.imgView.image = YLGIFImage(contentsOfFile: NSURL(fileURLWithPath: filePath).absoluteString)
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
                        let img:UIImage! = UIImage.gifWithURL(NSURL(fileURLWithPath: filePath).absoluteString)
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            cell.imgView.image = img
                        })
                    })
                }
                
                
            }
            else
            {
                var filePath:String!
                if memeArray[idx - 1][indexPath.row].componentsSeparatedByString(".").last == "png"
                {
                    //                    cell.imgView.image = nil
                    //                    filePath = NSBundle.mainBundle().pathForResource(memeArray[currentIndex - 1][indexPath.row].componentsSeparatedByString(".").first, ofType: "png")
                    //                    cell.imgView.image = UIImage(named: memeArray[currentIndex - 1][indexPath.row])//UIImage(contentsOfFile: filePath)

//                    let img:UIImage! = UIImage(named: self.memeArray[idx - 1][indexPath.row])
//                    cell.imgView.image = img
                   
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
                        let img:UIImage! = UIImage(named: self.memeArray[idx - 1][indexPath.row])
                        let resimg:UIImage! = self.resizeWithAspect_doResize(img, size: CGSizeMake(100, 100))
                        
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            cell.imgView.image = resimg
                        })
                    })
                }
                else
                {
                    filePath = NSBundle.mainBundle().pathForResource(String(format: "%@t", memeArray[idx - 1][indexPath.row].componentsSeparatedByString(".").first!), ofType: "gif")
                    cell.imgView.image = nil
                    //                    cell.imgView.image = UIImage.gifWithURL(NSURL(fileURLWithPath: filePath).absoluteString)
//                    YLGIFImage.setPrefetchNum(5)
                    
//                    cell.imgView.image = UIImage.gifWithURL(NSURL(fileURLWithPath: filePath).absoluteString)// YLGIFImage(contentsOfFile: NSURL(fileURLWithPath: filePath).absoluteString)
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), { () -> Void in
                       let img:UIImage! = UIImage.gifWithURL(NSURL(fileURLWithPath: filePath).absoluteString)
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            cell.imgView.image = img
                        })
                    })
                }
            }
            
            return cell
        }
    }
    
    // collection view method -> size for item at index path
    internal func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        if collectionView.isEqual(categoriesCollectionView) {
            let cellSize = CGSize(width: categoriesCollectionView.bounds.width / 7, height: categoriesCollectionView.bounds.height)
            return cellSize
        }
        else if collectionView.isEqual(pageCollectionView){
            let cellSize = CGSize(width: pageCollectionView.bounds.width , height: pageCollectionView.bounds.height)
            
            return cellSize
        }
        else {
            let cellSize = CGSize(width: pageCollectionView.bounds.width * 0.9 / 5, height: pageCollectionView.bounds.width * 0.9 / 5)
            return cellSize
        }
    }
    
    // collection view method -> did select item at index path
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView.isEqual(categoriesCollectionView) {
            
            let cell:CategoryCell = collectionView.cellForItemAtIndexPath(indexPath) as! CategoryCell
            
            if currentIndex == cell.tag - 20000
            {
                return
            }
            
            cell.backView.image = UIImage(named: "TopTabArrow.png")

            if indexPath.row != 0 && categoryArray[indexPath.row - 1].componentsSeparatedByString(".").last == "png"
            {
                let filePath = NSBundle.mainBundle().pathForResource(String(format: "%@x", categoryArray[indexPath.row - 1].componentsSeparatedByString(".").first!), ofType: "png")
                cell.imgView.image = UIImage(contentsOfFile: filePath!)
            }
            if indexPath.row == 0
            {
                let filePath = NSBundle.mainBundle().pathForResource("RecentX", ofType: "png")
                cell.imgView.image = UIImage(contentsOfFile: filePath!)
            }
//            UIView.animateWithDuration(0.05, delay: 0.0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.CurveEaseInOut,
//                animations: ({
//                    cell!.transform = CGAffineTransformMakeScale(0.9, 0.9)
//                }), completion: { finished in
//                    UIView.animateWithDuration(0.1, delay: 0.0, usingSpringWithDamping: 0.1, initialSpringVelocity: 0.1, options: UIViewAnimationOptions.CurveEaseInOut,
//                        animations: ({
//                            cell!.transform = CGAffineTransformMakeScale(0.8, 0.8)
//                        }), completion: { finished in
//                            cell!.transform = CGAffineTransformMakeScale(1, 1)
//                            
//                    })
//            })
            if currentIndex == 1
            {
                 self.collectionView(categoriesCollectionView, didDeselectItemAtIndexPath: NSIndexPath(forRow: 1, inSection: 0))
            }
            currentIndex = cell.tag - 20000
            pageCollectionView.selectItemAtIndexPath(NSIndexPath(forRow: currentIndex, inSection: 0), animated: false, scrollPosition: UICollectionViewScrollPosition.Left)
            
//            memesCollectionView.reloadData()
//            if currentIndex != 0
//            {
//                memesCollectionView.selectItemAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), animated: false, scrollPosition: UICollectionViewScrollPosition.Top)
//            }
            
        }
        else if collectionView.isEqual(pageCollectionView)
        {
            
        }
        else
        {
            nCarouselIndex = indexPath.row
            showSizeSetter()
        }
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        if collectionView.isEqual(categoriesCollectionView) {
            let cell = collectionView.cellForItemAtIndexPath(indexPath)
            if cell != nil
            {
                (cell as! CategoryCell).backView.image = UIImage(named: "NormalTab.png")                
                if indexPath.row != 0 && categoryArray[indexPath.row - 1].componentsSeparatedByString(".").last == "png"
                {
                    let filePath = NSBundle.mainBundle().pathForResource(categoryArray[indexPath.row - 1].componentsSeparatedByString(".").first!, ofType: "png")
                    (cell as! CategoryCell).imgView.image = UIImage(contentsOfFile: filePath!)
                }
                if indexPath.row == 0
                {
                    let filePath = NSBundle.mainBundle().pathForResource("Recent", ofType: "png")
                    (cell as! CategoryCell).imgView.image = UIImage(contentsOfFile: filePath!)
                }
    //            cell?.backgroundColor = UIColor(red: 240 / 255, green: 240 / 255, blue: 240 / 255, alpha: 1)
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        (cell!.viewWithTag(1) as! UIImageView).alpha = 0.7
        return true
    }
    func collectionView(collectionView: UICollectionView, didHighlightItemAtIndexPath indexPath: NSIndexPath) {
        //Highlight selected cell
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        (cell!.viewWithTag(1) as! UIImageView).alpha = 0.7
    }
    
    func collectionView(collectionView: UICollectionView, didUnhighlightItemAtIndexPath indexPath: NSIndexPath) {
        //Unhighlight cell
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        (cell!.viewWithTag(1) as! UIImageView).alpha = 1
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView.isEqual(pageCollectionView)
        {
        let currentPage = self.pageCollectionView.contentOffset.x / self.pageCollectionView.frame.size.width
        
            
        self.collectionView(categoriesCollectionView, didDeselectItemAtIndexPath: NSIndexPath(forRow: currentIndex, inSection: 0))
        currentIndex = Int(currentPage)
        
        categoriesCollectionView.selectItemAtIndexPath(NSIndexPath(forRow: currentIndex, inSection: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.CenteredHorizontally)
        let cell = categoriesCollectionView.cellForItemAtIndexPath(NSIndexPath(forRow: currentIndex, inSection: 0)) 
//            cell.backgroundColor = UIColor.whiteColor()
            if cell != nil
            {
            (cell as! CategoryCell).backView.image = UIImage(named: "TopTabArrow.png")
             (cell as! CategoryCell).backView.contentMode = .ScaleToFill
            if currentIndex != 0 && categoryArray[currentIndex - 1].componentsSeparatedByString(".").last == "png"
            {
                let filePath = NSBundle.mainBundle().pathForResource(String(format: "%@x", categoryArray[currentIndex - 1].componentsSeparatedByString(".").first!), ofType: "png")
                 (cell as! CategoryCell).imgView.image = UIImage(contentsOfFile: filePath!)
            }
            }

        }
        
    }
    
    func sendGif(gifname:String!)
    {
        if currentIndex != 0
        {
            var recentEmojies:NSMutableArray = NSMutableArray()
            if NSUserDefaults.init(suiteName: "group.appmoji.muvamoji")!.valueForKey("RECENTMUVAMOJI") != nil
            {
                recentEmojies = NSMutableArray(array: NSUserDefaults.init(suiteName: "group.appmoji.muvamoji")!.valueForKey("RECENTMUVAMOJI") as! NSArray)
            }
            
            for var i = 0; i < recentEmojies.count; i++
            {
                if (recentEmojies[i] as! String) == gifname
                {
                    recentEmojies.removeObjectAtIndex(i)
                    break
                }
            }
            
            recentEmojies.insertObject(gifname, atIndex: 0)
            NSUserDefaults.init(suiteName: "group.appmoji.muvamoji")!.setValue(recentEmojies, forKey: "RECENTMUVAMOJI")
            NSUserDefaults.init(suiteName: "group.appmoji.muvamoji")!.synchronize()
        }
        
        let filePath = NSBundle.mainBundle().pathForResource(gifname.componentsSeparatedByString(".").first, ofType: "gif")
        let gifData = NSData(contentsOfFile: filePath!)
        
        
        
        let vc = UIActivityViewController(activityItems: [gifData!], applicationActivities: [])
        vc.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
        presentViewController(vc, animated: true, completion: nil)
    }
    
    
    //Resize function
    func resizeWithAspect_doResize(image: UIImage,size: CGSize)->UIImage{
        var nw = Int(size.width)
        if nw % 2 == 1
        {
            nw++
        }
        var nh = Int(size.height)
        if nh % 2 == 1
        {
            nh++
        }
        let nsize = CGSizeMake(CGFloat(nw), CGFloat(nh))
        if UIScreen.mainScreen().respondsToSelector("scale"){
            UIGraphicsBeginImageContextWithOptions(nsize,false, UIScreen.mainScreen().scale)
        }
        else
        {
            UIGraphicsBeginImageContext(nsize)
        }
        
        //Making imgSizeFactor smaller will make the image smaller.
        let imgSizeFactor:CGFloat = 1
        
        let imgWidth = nsize.width * imgSizeFactor
        let imgHeight = nsize.height * imgSizeFactor
        image.drawInRect(CGRectMake(0, 0, imgWidth, imgHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    func addImage(imageName:String, nRatio:CGFloat) {
        
        var filePath = NSBundle.mainBundle().pathForResource(imageName.componentsSeparatedByString(".").first, ofType:"png")
        if filePath == nil
        {
            filePath = NSBundle.mainBundle().pathForResource(imageName.componentsSeparatedByString(".").first, ofType:"gif")
        }
        // get the image from the path
        let image:UIImage = UIImage(contentsOfFile: filePath!)!
        
        
        let attachment = NSTextAttachment()
        attachment.image = resizeWithAspect_doResize(image,size:CGSize(width: 200 * CGFloat(nRatio / CGFloat(4)) / UIScreen.mainScreen().scale , height: 200 * CGFloat(nRatio / CGFloat(4)) / UIScreen.mainScreen().scale ));
        attachment.bounds = CGRectMake(0, -attachment.image!.size.height / 3, attachment.image!.size.width, attachment.image!.size.height)
        
        let attString = NSAttributedString(attachment: attachment)
        
        let txtOneVoteMoji:UITextView! = UITextView()
        txtOneVoteMoji.textStorage.insertAttributedString(attString, atIndex: txtOneVoteMoji.selectedRange.location)
        txtOneVoteMoji.sizeToFit()
        var imageS: UIImage! = nil
        
        txtOneVoteMoji.backgroundColor = UIColor.clearColor()
        var hOffset:CGFloat = 0.0
        let newWidth = txtOneVoteMoji.contentSize.width
        var newHeight = txtOneVoteMoji.contentSize.height
        if(txtOneVoteMoji.contentSize.height <= 200)
        {
            newHeight = 200
            hOffset = newHeight / 2 - txtOneVoteMoji.contentSize.height / 2
        }
       // UIGraphicsBeginImageContextWithOptions(CGSize.init(width: 240, height: newHeight)  , false, 0.0)
       // CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 120 - newWidth / 2 , hOffset)
        if nRatio > 8.5
        {
            UIGraphicsBeginImageContextWithOptions(CGSize.init(width: 240, height: newHeight)  , false, 0.0)
            CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 120 - newWidth / 2 , hOffset)
        }
        else
        {
            UIGraphicsBeginImageContextWithOptions(CGSize.init(width: 480, height: newHeight)  , false, 0.0)
            CGContextTranslateCTM(UIGraphicsGetCurrentContext(), 240 - newWidth / 2 , hOffset)
        }
        
        UIColor.clearColor().setFill()
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        txtOneVoteMoji.contentOffset = CGPointZero
        txtOneVoteMoji.frame = CGRectMake(0, 0, newWidth, newHeight)
        txtOneVoteMoji.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        
        imageS = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
//        UIPasteboard.generalPasteboard().image = imageS
        
        
        if currentIndex != 0
        {
            var recentEmojies:NSMutableArray = NSMutableArray()
            if NSUserDefaults.init(suiteName: "group.appmoji.muvamoji")!.valueForKey("RECENTMUVAMOJI") != nil
            {
                recentEmojies = NSMutableArray(array: NSUserDefaults.init(suiteName: "group.appmoji.muvamoji")!.valueForKey("RECENTMUVAMOJI") as! NSArray)
            }
            
            for var i = 0; i < recentEmojies.count; i++
            {
                if (recentEmojies[i] as! String) == imageName
                {
                    recentEmojies.removeObjectAtIndex(i)
                    break
                }
            }
            
            recentEmojies.insertObject(imageName, atIndex: 0)
            NSUserDefaults.init(suiteName: "group.appmoji.muvamoji")!.setValue(recentEmojies, forKey: "RECENTMUVAMOJI")
            NSUserDefaults.init(suiteName: "group.appmoji.muvamoji")!.synchronize()
        }

        let vc = UIActivityViewController(activityItems: [imageS], applicationActivities: [])
        vc.excludedActivityTypes = [UIActivityTypeAirDrop, UIActivityTypeAddToReadingList]
        presentViewController(vc, animated: true, completion: nil)
        
    }    
}
