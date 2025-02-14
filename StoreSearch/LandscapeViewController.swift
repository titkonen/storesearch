//
//  LandscapeViewController.swift
//  StoreSearch
//
//  Created by Toni Itkonen on 24/06/2019.
//  Copyright © 2019 Toni Itkonen. All rights reserved.
//

import UIKit

class LandscapeViewController: UIViewController {
    var searchResults = [SearchResult]()
    
    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!

    // MARK: - Properties
    private var firstTime = true
    private var downloads = [URLSessionDownloadTask]()
    
    // MARK: - Actions
    @IBAction func pageChanged(_ sender: UIPageControl) {
        UIView.animate(withDuration: 0.3, delay: 0,
                       options: [.curveEaseInOut], animations: {
                        self.scrollView.contentOffset = CGPoint(
                            x: self.scrollView.bounds.size.width * CGFloat(sender.currentPage), y: 0)
        },
                       completion: nil)
    }
    
    // MARK: - Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(patternImage: UIImage(named: "LandscapeBackground")!)
        // Remove constraints from the main view
        view.removeConstraints(view.constraints)
        view.translatesAutoresizingMaskIntoConstraints = true
        // Remove constraints for page control
        pageControl.removeConstraints(pageControl.constraints)
        pageControl.translatesAutoresizingMaskIntoConstraints = true
        pageControl.numberOfPages = 0
        // Remove constraints for scroll view
        scrollView.removeConstraints(scrollView.constraints)
        scrollView.translatesAutoresizingMaskIntoConstraints = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let safeFrame = view.safeAreaLayoutGuide.layoutFrame
        scrollView.frame = safeFrame
        pageControl.frame = CGRect(x: safeFrame.origin.x, y: safeFrame.size.height - pageControl.frame.size.height,
            width: safeFrame.size.width,
            height: pageControl.frame.size.height)
        
        if firstTime {
            firstTime = false
            tileButtons(searchResults)
        }
    }
    
    deinit {
        print("deinit \(self)")
        for task in downloads {
            task.cancel()
        }
    }
    
    // MARK: - Private methods
    private func tileButtons(_ searchResults: [SearchResult]) {
        var columnsPerPage = 6
        var rowsPerPage = 3
        var itemWidth: CGFloat = 94
        var itemHeight: CGFloat = 88
        var marginX: CGFloat = 2
        var marginY: CGFloat = 20
        
        let viewWidth = scrollView.bounds.size.width
        
        switch viewWidth {
        case 568:
            // 4 inch device
            break
        case 667:
            // 4.7 inch device
            columnsPerPage = 7
            itemWidth = 95
            itemHeight = 98
            marginX = 1
            marginY = 29
            
        case 736:
            // 5.5 inch device
            columnsPerPage = 8
            rowsPerPage = 4
            itemWidth = 92
            marginX = 0
            
        case 724:
            // iPhone X
            columnsPerPage = 8
            rowsPerPage = 3
            itemWidth = 90
            itemHeight = 98
            marginX = 2
            marginY = 29
            
        default:
            break
        }
        // Button size
        let buttonWidth: CGFloat = 82
        let buttonHeight: CGFloat = 82
        let paddingHorz = (itemWidth - buttonWidth)/2
        let paddingVert = (itemHeight - buttonHeight)/2
        
        // Add the buttons
        var row = 0
        var column = 0
        var x = marginX
        for (_, result) in searchResults.enumerated() { // index
            // 1
            let button = UIButton(type: .custom)
            
            button.setBackgroundImage(UIImage(named: "LandscapeButton"), for: .normal)
            downloadImage(for: result, andPlaceOn: button)
            
            // 2
            button.frame = CGRect(x: x + paddingHorz,
                                  y: marginY + CGFloat(row)*itemHeight + paddingVert,
                                  width: buttonWidth, height: buttonHeight)
            // 3
            scrollView.addSubview(button)
            // 4
            row += 1
            if row == rowsPerPage {
                row = 0; x += itemWidth; column += 1
                
                if column == columnsPerPage {
                    column = 0; x += marginX * 2
                }
            }
        }
        
        // Set scroll view content size
        let buttonsPerPage = columnsPerPage * rowsPerPage
        let numPages = 1 + (searchResults.count - 1) / buttonsPerPage
        scrollView.contentSize = CGSize(
            width: CGFloat(numPages) * viewWidth, height: scrollView.bounds.size.height)
        
        print("Number of pages: \(numPages)")
        
        pageControl.numberOfPages = numPages
        pageControl.currentPage = 0
        
    }
    
    private func downloadImage(for searchResult: SearchResult, andPlaceOn button: UIButton) {
        if let url = URL(string: searchResult.imageSmall) {
            let task = URLSession.shared.downloadTask(with: url) {
                [weak button] url, response, error in
                
                if error == nil, let url = url,
                    let data = try? Data(contentsOf: url),
                    let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        if let button = button {
                            button.setImage(image, for: .normal)
                        }
                    }
                }
            }
                task.resume()
                downloads.append(task)
        }
    }
   
} // End of class

extension LandscapeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let width = scrollView.bounds.size.width
        let page = Int((scrollView.contentOffset.x + width / 2) / width)
        
        pageControl.currentPage = page
    }
}
