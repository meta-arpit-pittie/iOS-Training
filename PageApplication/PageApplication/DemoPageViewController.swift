//
//  ViewController.swift
//  PageApplication
//
//  Created by Arpit Pittie on 2/21/17.
//  Copyright © 2017 Arpit Pittie. All rights reserved.
//

import UIKit

class DemoPageViewController: UIPageViewController {
    
    var pageTitles: [String]!
    var pageImages: [String]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pageTitles = ["Over 200 Tips and Tricks", "Discover Hidden Features", "Bookmark Favorite Tip"]
        pageImages = ["page1.png", "page2.png", "page3.png"]
        
        self.dataSource = self
        
        let startingViewController = viewControllerAt(index: 0)
        var viewControllers = [UIViewController]()
        viewControllers.append(startingViewController!)
        
        self.setViewControllers(viewControllers, direction: .forward, animated: true)
    }

    @IBAction func startWalkthrough(_ sender: UIButton) {
        let startingViewController = viewControllerAt(index: 0)
        var viewControllers = [UIViewController]()
        viewControllers.append(startingViewController!)
        
        self.setViewControllers(viewControllers, direction: .forward, animated: true)
    }

}

// MARK: UIPageViewControllerDataSource

extension DemoPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let pageContentViewController = viewController as? PageContentViewController {
            var index = pageContentViewController.pageIndex
            
            if index == NSNotFound {
                return nil
            }
            
            index = index! + 1
            if index == pageTitles.count {
                return nil
            }
            return viewControllerAt(index: index!)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let pageContentViewController = viewController as? PageContentViewController {
            var index = pageContentViewController.pageIndex
            
            if index == 0 || index == NSNotFound {
                return nil
            }
            
            index = index! - 1
            return viewControllerAt(index: index!)
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageTitles.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func viewControllerAt(index: Int) -> PageContentViewController? {
        let pageContentViewController = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PageContentViewController") as! PageContentViewController
        
        pageContentViewController.titleText = pageTitles[index]
        pageContentViewController.imageFile = pageImages[index]
        pageContentViewController.pageIndex = index
        
        return pageContentViewController
    }
}

