//
//  UIView+Extensions.swift
//  AFNutils
//
//  Created by vladislav timoftica on 4/22/19.
//

import Foundation
import MBProgressHUD

extension UIView {
    @IBInspectable var cornerRadius : CGFloat
        {
        get{ return layer.cornerRadius }
        set{ layer.cornerRadius = newValue }
    }

    @IBInspectable var borderColor : UIColor?
        {
        get{return layer.borderColor.flatMap{UIColor(cgColor:$0)} }
        set{layer.borderColor = newValue.flatMap{$0.cgColor}}
    }

    @IBInspectable var borderWidth : CGFloat
        {
        get{return layer.borderWidth}
        set{layer.borderWidth = newValue}
    }

    @IBInspectable var shadowColor : UIColor?
        {
        get{return layer.shadowColor.flatMap{UIColor(cgColor: $0)} }
        set{layer.shadowColor = newValue.flatMap{$0.cgColor}}
    }

    @IBInspectable var shadowOpacity : Float
        {
        get{return layer.shadowOpacity}
        set{layer.shadowOpacity = newValue}
    }

    @IBInspectable var shadowOffset : CGSize
        {
        get{return layer.shadowOffset}
        set{layer.shadowOffset = newValue}
    }

    @IBInspectable var shadowRadius : CGFloat
        {
        get{return layer.shadowRadius}
        set{layer.shadowRadius = newValue / 2.0}
    }

    @IBInspectable var shadowPath : CGPath?
        {
        get{return layer.shadowPath}
        set{layer.shadowPath = newValue}
    }

    @IBInspectable var round : Bool {
        get { return bounds.width == bounds.height && cornerRadius == bounds.width/2 }
        set { cornerRadius = newValue ? bounds.height/2 : layer.cornerRadius }
    }
}

extension UIView {

    enum GradientDirection {
        case fromLeftToRight
        case fromRightToLeft
        case fromTopToBottom
        case fromBottomToTop
    }

    func gradientWithColor(_ primary: UIColor, secondColor: UIColor, direction: GradientDirection) {
        let gradient = CAGradientLayer()
        var gradientSet = [[CGColor]]()

        let p = primary.cgColor
        let s = secondColor.cgColor

        gradientSet.append([p, s])
        gradientSet.append([s, p])

        gradient.cornerRadius = self.cornerRadius
        gradient.colors = gradientSet[0]

        switch direction {
        case .fromLeftToRight:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        case .fromRightToLeft:
            gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        case .fromTopToBottom:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        case .fromBottomToTop:
            gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
            gradient.endPoint = CGPoint(x: 0.0, y: 0.0)
        }

        gradient.drawsAsynchronously = true
        self.layer.addSublayer(gradient)
        gradient.zPosition = -100
    }

    func adjustGradientLayers() {
        self.layer.sublayers?.forEach ({
            if $0 is CAGradientLayer {
                $0.frame = self.bounds
            }
        })
    }

    func removeGradientLayers() {
        self.layer.sublayers?.forEach ({
            if $0 is CAGradientLayer {
                $0.removeFromSuperlayer()
            }
        })
    }
}

extension UITextField {
    @IBInspectable var leftSpacer: CGFloat {
        get {
            if let l = leftView {
                return l.frame.size.width
            } else {
                return 0
            }
        } set {
            leftViewMode = .always
            leftView = UIView(frame: CGRect(x: 0, y: 0, width: newValue, height: frame.size.height))
        }
    }

    @IBInspectable var rightImage: UIImage? {
        get { return UIImage(named: "Group/ask") }
        set {
            if let image = rightImage {
                rightViewMode = UITextField.ViewMode.always
                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 64, height: 16))
                imageView.contentMode = .scaleAspectFit
                imageView.image = image
                //                imageView.tintColor = color
                rightView = imageView
            }
        }
    }
}


extension UIView {
    func contentSize() -> CGSize {
        self.setNeedsLayout()
        self.layoutIfNeeded()

        let height = self.subviews.map({$0.frame.size.height}).reduce(0, +)
        let width = self.subviews.map({$0.frame.size.width}).reduce(0, +)

        return CGSize(width: width, height: height)
    }
}


extension UIView {
    func constraintById(_ id: String) -> NSLayoutConstraint? {
        for subview in self.subviews {
            for constraint in subview.constraints {
                if constraint.identifier == id {
                    return constraint
                }
            }
        }
        return nil
    }
}

extension UIView {
    func subviewsRecursive() -> [UIView] {
        return subviews + subviews.flatMap { $0.subviewsRecursive() }
    }
}


extension UIView {

    func subViews<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        for view in self.subviews {
            if let aView = view as? T{
                all.append(aView)
            }
        }
        return all
    }


    func allSubViewsOf<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T{
                all.append(aView)
            }
            guard view.subviews.count > 0 else { return }
            view.subviews.forEach{ getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
}

extension UIView{

    private struct hudStruct {
        static var hud = MBProgressHUD()
        static var hudProgress: Float = 0
    }

    var hud: MBProgressHUD {
        get{
            return hudStruct.hud
        }
        set {
            hudStruct.hud = newValue
        }
    }

    var hudProgress: Float {
        get {
            return hudStruct.hudProgress
        }
        set {
            hudStruct.hudProgress = newValue
            hud.progress = newValue
        }
    }

    func showHud() {
        if !hud.isDescendant(of: self) {
            hud = MBProgressHUD.showAdded(to: self, animated: true)
            hud.mode = .indeterminate
            hud.label.text = nil
        }
    }

    func showHud(withProgess: Float, hudText:String? = nil) {
        if !hud.isDescendant(of: self) {
            hud = MBProgressHUD.showAdded(to: self, animated: true)
            if let _hudText = hudText {
                hud.label.text = _hudText
            }
            hud.mode = .annularDeterminate
        }
    }
    func hideHud() {
        DispatchQueue.main.async {
            if self.hud.isDescendant(of: self) {
                MBProgressHUD.hide(for: self, animated: true)
                self.hudProgress = 0
            }
        }
    }
}
