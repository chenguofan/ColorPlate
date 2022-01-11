//
//  ViewController.swift
//  ColorPlate
//
//  Created by suhengxian on 2022/1/11.
//

import UIKit

let kScreenWidth = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height

class ViewController: UIViewController, ColorPlateDelegate {
    func colorPlate(colorPlate: ColorPlate, choiceColor: UIColor, colorPoint: CGPoint) {
        
        print("choiceColor:\(choiceColor)")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        self.view.backgroundColor = UIColor.white
        
        let leftSpace = 30.0
        let colorPlate:ColorPlate = ColorPlate.init(frame: CGRect.init(x:30, y:40, width: kScreenWidth - leftSpace * 2, height: kScreenWidth - leftSpace * 2))
        colorPlate.colorDelegate = self
        colorPlate.center = self.view.center
        self.view.addSubview(colorPlate)
        
    }
}

