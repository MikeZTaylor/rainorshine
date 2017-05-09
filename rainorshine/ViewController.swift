//
//  ViewController.swift
//  rainorshine
//
//  Created by Mike Taylor on 06/04/2017.
//  Copyright © 2017 Mike Taylor. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {
    
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var weatherLabel: UILabel!
    
    var colors :[UIColor] = [UIColor.white,UIColor.green,UIColor.white,UIColor.white]
    
    var weatherLabelValues: [String] = ["Regular", "Soy", "Almond", "Milk"]
    
    
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor(red:0.18, green:0.69, blue:0.82, alpha:1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        pageControl.numberOfPages = colors.count
        
        for index in 0..<colors.count
        {
            frame.origin.x = scrollView.frame.size.width * CGFloat(index)
            frame.size = scrollView.frame.size
            
            let view = UIView(frame: frame)
            view.backgroundColor = colors[index]
            self.weatherLabel.text = weatherLabelValues[index]
            self.scrollView.addSubview(view)
        }
    
        
        scrollView.contentSize = CGSize(width: (scrollView.frame.size.width * CGFloat(colors.count)), height: scrollView.frame.size.height)
        
        scrollView.delegate = self
        //
        
        view.bringSubview(toFront: pageControl)
        
        
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.size.width
        pageControl.currentPage = Int(pageNumber)
        pageControl.currentPageIndicatorTintColor = UIColor.black
        
    }
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction func pageChange(_ sender: UIPageControl) {
        
        let x = CGFloat(sender.currentPage) * scrollView.frame.size.width
        scrollView.contentOffset = CGPoint(x: x, y: 0)
        pageControl.currentPageIndicatorTintColor = UIColor.black
    }
    
}
