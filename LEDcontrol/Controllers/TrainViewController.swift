//
//  ModeViewController.swift
//  Basic Chat MVC
//
//  Created by Degore, Zachary on 12/15/22.
//

import UIKit
@available(iOS 15.0, *)
class TrainViewController: UIViewController {

    
    // variable declatation and link
    @IBOutlet weak var SliderBrightness: UISlider!
    @IBOutlet weak var SliderSpeed: UISlider!
    @IBOutlet weak var Label1: UILabel!
    @IBOutlet weak var Label2: UILabel!
    @IBOutlet weak var FadeType: UIButton!
    @IBOutlet weak var Pattern: UIButton!
    
    
    //get the valuse from the sliders and display the results
    @IBAction func SliderAction(sender: AnyObject){

        
        var speed = SliderSpeed.value
        var brightness = SliderBrightness.value

        Label2.text = String(speed)
        Label1.text = String(brightness)
        
        
        
    }
    
    //get the values obtained from the menu selections
    @IBAction func ButtonToggle(sender: AnyObject){

        
        var fade = FadeType
        var pattern = Pattern
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPopupButton()
        setPopupButton2()
    }
    
    //set up the first menu button
    func setPopupButton(){
        let optionClosure = {(action: UIAction) in
            print(action.title)}
        
        FadeType.menu = UIMenu(children: [
            UIAction(title: "Faded", state: .on, handler: optionClosure),
            UIAction(title: "Pixelated", handler: optionClosure)])
        
        FadeType.showsMenuAsPrimaryAction = true
        FadeType.changesSelectionAsPrimaryAction = true
        
        
        
    }
    //setup the second menu button
    func setPopupButton2(){
        let optionClosure = {(action: UIAction) in
            print(action.title)}
        
        Pattern.menu = UIMenu(children: [
            UIAction(title: "Rainbow", state: .on, handler: optionClosure),
            UIAction(title: "Clouds", handler: optionClosure),
            UIAction(title: "Lava", handler: optionClosure),
            UIAction(title: "Red White and Blue", handler: optionClosure)
        ])
        
        Pattern.showsMenuAsPrimaryAction = true
        Pattern.changesSelectionAsPrimaryAction = true
        
        
        
    }
}
