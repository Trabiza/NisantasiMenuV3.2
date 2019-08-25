//
//  Extensions+View.swift
//  NisantasiMenu
//
//  Created by owner on 6/10/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit


@IBDesignable
class CustomGradient: UIView {
    
    @IBInspectable var FirstColor : UIColor = UIColor.clear {
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var SecondColor : UIColor = UIColor.clear {
        didSet{
            updateView()
        }
    }
    
    override class var layerClass : AnyClass {
        get{
            return CAGradientLayer.self
        }
    }
    
    func updateView() {
        let Layer = self.layer as! CAGradientLayer
        //Layer.startPoint = CGPoint(x: 0.5, y: 1.0)
        //Layer.endPoint = CGPoint(x: 0.5, y: 0.0)
        //Layer.locations = [0.5, 1.0]
        Layer.locations = [0.0, 0.7, 1.0]
        Layer.colors = [FirstColor.cgColor , UIColor.clear.cgColor ,SecondColor.cgColor]
    }
    
}


@IBDesignable
class CustomButton: UIView {
    
    @IBInspectable var FirstColor : UIColor = UIColor.clear {
        didSet{
            updateView()
        }
    }
    
    @IBInspectable var SecondColor : UIColor = UIColor.clear {
        didSet{
            updateView()
        }
    }
    
    override class var layerClass : AnyClass {
        get{
            return CAGradientLayer.self
        }
    }
    
    func updateView() {
        let Layer = self.layer as! CAGradientLayer
        Layer.colors = [FirstColor.cgColor , SecondColor.cgColor]
    }
    
}

extension UIView{
    
    @IBInspectable var CornerRaduis : CGFloat {
        get{ return self.layer.cornerRadius}
        set{ self.layer.cornerRadius = newValue}
    }
    
    @IBInspectable var shadowOffsetWidth : CGFloat {
        get{ return self.layer.shadowOffset.width}
        set{ self.layer.shadowOffset.width = newValue}
    }
    
    @IBInspectable var shadowOffsetHeight : CGFloat {
        get{ return self.layer.shadowOffset.height}
        set{ self.layer.shadowOffset.height = newValue}
    }
    
    @IBInspectable var shadowOpacity : CGFloat {
        get{ return CGFloat(self.layer.shadowOpacity)}
        set{ self.layer.shadowOpacity = Float(newValue)}
    }
    
    @IBInspectable var shadowColor : UIColor {
        get{ return UIColor( cgColor : self.layer.shadowColor!)}
        set{ self.layer.shadowColor = newValue.cgColor}
    }
    
    @IBInspectable var BorderWidth : CGFloat {
        get{ return self.layer.borderWidth}
        set{ self.layer.borderWidth = newValue}
    }
    
    @IBInspectable var BorderColor : UIColor {
        get{ return UIColor( cgColor : self.layer.borderColor!)}
        set{ self.layer.borderColor = newValue.withAlphaComponent(0.3).cgColor}
    }
    
}

extension UITextField {
    @IBInspectable var PlaceholderColor : UIColor {
        get{ return self.PlaceholderColor}
        set{ self.attributedPlaceholder = NSAttributedString(string: self.placeholder != nil ? self.placeholder! : "", attributes: [NSAttributedStringKey.foregroundColor : newValue])}
    }
}

extension UIColor{
    
    func getCustomBlueColor() -> UIColor{
        
        return UIColor(red:0.043, green:0.576 ,blue:0.588 , alpha:1.00)
        
    }
}



extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat, personalInfoView: UIView) {
        
        let border = CALayer()
        
        switch edge {
        case .top:
            border.frame = CGRect(x: 0, y: 0, width: frame.width, height: thickness)
        case .bottom:
            //            border.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
            border.frame = CGRect(x: 0, y: frame.height - thickness, width: personalInfoView.frame.width, height: thickness)
        case .left:
            border.frame = CGRect(x: 0, y: 0, width: thickness, height: frame.height)
        case .right:
            border.frame = CGRect(x: frame.width - thickness, y: 0, width: thickness, height: frame.height)
        default:
            break
        }
        
        border.backgroundColor = color.cgColor;
        
        addSublayer(border)
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


extension UIViewController {
    
    func showToast(message: String, controller: UIViewController) {
        
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 20;
        toastContainer.clipsToBounds  =  true
        
        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font.withSize(10.0)
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0
        
        toastContainer.addSubview(toastLabel)
        controller.view.addSubview(toastContainer)
        
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let a1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 15)
        let a2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -15)
        let a3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -15)
        let a4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 15)
        toastContainer.addConstraints([a1, a2, a3, a4])
        
        let c1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: controller.view, attribute: .leading, multiplier: 1, constant: 65)
        let c2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: controller.view, attribute: .trailing, multiplier: 1, constant: -65)
        let c3 = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: controller.view, attribute: .bottom, multiplier: 1, constant: -75)
        controller.view.addConstraints([c1, c2, c3])
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
    
}
