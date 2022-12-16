//
//  ColorViewController.swift
//  Basic Led controller
//
//  Created by Degore, Zachary on 12/14/22.
//

import UIKit


class ColorViewController : UIViewController{
    //variable declaration and linking
    @IBOutlet weak var SliderBrightness: UISlider!
    @IBOutlet weak var SliderR: UISlider!
    @IBOutlet weak var SliderG: UISlider!
    @IBOutlet weak var SliderB: UISlider!
    @IBOutlet weak var Label1: UILabel!
    @IBOutlet weak var Label2: UILabel!
    @IBOutlet weak var Label3: UILabel!
    @IBOutlet weak var Label4: UILabel!
    
    //update the slider valuse and background as well as output values
    @IBAction func SliderAction(sender: AnyObject){
        self.view.backgroundColor = UIColor(red:CGFloat(SliderR.value)/255, green:CGFloat(SliderG.value)/255, blue:CGFloat(SliderB.value)/255, alpha: CGFloat(SliderBrightness.value)/255)
        
        //set values used for sending to bluetooth
        var red = SliderR.value
        var blue = SliderB.value
        var green = SliderG.value
        var bright = SliderBrightness.value
        
        //display the values
        Label1.text = String(red)
        Label2.text = String(blue)
        Label3.text = String(green)
        Label4.text = String(bright)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}
