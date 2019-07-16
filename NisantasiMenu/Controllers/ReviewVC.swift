//
//  ReviewVC.swift
//  NisantasiMenu
//
//  Created by owner on 6/24/19.
//  Copyright © 2019 Y2M. All rights reserved.
//

import UIKit

class ReviewVC: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var breakfastImage: UIImageView!
    @IBOutlet weak var lunchImage: UIImageView!
    @IBOutlet weak var dinnerImage: UIImageView!
    
    @IBOutlet weak var friendsImage: UIImageView!
    @IBOutlet weak var adsImages: UIImageView!
    @IBOutlet weak var socialImages: UIImageView!
    @IBOutlet weak var otherImages: UIImageView!
    @IBOutlet weak var otherField: UITextField!
    
    @IBOutlet weak var commentField: UITextField!
    
    @IBOutlet weak var timeField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var mobilefield: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var foodHappyImage: UIButton!
    @IBOutlet weak var foodMediumImage: UIButton!
    @IBOutlet weak var foodSadImage: UIButton!

    @IBOutlet weak var beverageHappyImage: UIButton!
    @IBOutlet weak var beverageMediumImage: UIButton!
    @IBOutlet weak var beverageSadImage: UIButton!
    
    @IBOutlet weak var hospHappyImage: UIButton!
    @IBOutlet weak var hospMediumImage: UIButton!
    @IBOutlet weak var hospSadImage: UIButton!
    
    @IBOutlet weak var overallHappy: UIButton!
    @IBOutlet weak var overallMediumImage: UIButton!
    @IBOutlet weak var overallSadImage: UIButton!
    
    
    
    var meal: String = ""
    var hear: String = ""
    var timeVisit: String = ""
    var foodQuality: String = ""
    var beverageQuality: String = ""
    var hosipility: String = ""
    var overall: String = ""
    var comment: String = ""
    var guestName: String = ""
    var guestMobile: String = ""
    var guestAddress: String = ""
    var guestEmail: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        HelperManager.RTLBtn(backBtn)
        hideKeyboardWhenTappedAround()
        
        otherField.addTarget(self, action: #selector(searchWorkersAsPerText(_ :)), for: .editingChanged)
        
        timeVisit = getCurrentDay()
        timeField.text = getCurrentDay()
    }
    
    @IBAction func dismissAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func getCurrentDay() -> String{
        var mMonth: String = ""
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        let seconds = calendar.component(.second, from: date)
        
        mMonth = "\(month)"
        if month < 10 {
            mMonth = "0\(month)"
        }
        
        return "\(year)-\(mMonth)-\(day) \(hour):\(minutes):\(seconds)"
    }

    @IBAction func mealActions(_ sender: UIButton) {
        switch sender.tag {
        case 0: //Breakfast
            meal = "B"
            breakfastImage.image = #imageLiteral(resourceName: "radio-button-fill")
            lunchImage.image = #imageLiteral(resourceName: "radio-button")
            dinnerImage.image = #imageLiteral(resourceName: "radio-button")
        case 1: //Lunch
            meal = "L"
            lunchImage.image = #imageLiteral(resourceName: "radio-button-fill")
            breakfastImage.image = #imageLiteral(resourceName: "radio-button")
            dinnerImage.image = #imageLiteral(resourceName: "radio-button")
        case 2: //Dinner
            meal = "D"
            dinnerImage.image = #imageLiteral(resourceName: "radio-button-fill")
            breakfastImage.image = #imageLiteral(resourceName: "radio-button")
            lunchImage.image = #imageLiteral(resourceName: "radio-button")
        default:
            break
        }
    }
    
    @IBAction func hearActions(_ sender: UIButton) {
        switch sender.tag {
        case 3: //Friends
            hear = "Friends"
            friendsImage.image = #imageLiteral(resourceName: "radio-button-fill")
            adsImages.image = #imageLiteral(resourceName: "radio-button")
            socialImages.image = #imageLiteral(resourceName: "radio-button")
            otherImages.image = #imageLiteral(resourceName: "radio-button")
            otherField.isHidden = true
        case 4: //Ads
            hear = "Advertising"
            adsImages.image = #imageLiteral(resourceName: "radio-button-fill")
            friendsImage.image = #imageLiteral(resourceName: "radio-button")
            socialImages.image = #imageLiteral(resourceName: "radio-button")
            otherImages.image = #imageLiteral(resourceName: "radio-button")
            otherField.isHidden = true
        case 5: //Social
            hear = "Social-Media"
            socialImages.image = #imageLiteral(resourceName: "radio-button-fill")
            friendsImage.image = #imageLiteral(resourceName: "radio-button")
            adsImages.image = #imageLiteral(resourceName: "radio-button")
            otherImages.image = #imageLiteral(resourceName: "radio-button")
            otherField.isHidden = true
        case 6: //Other
            otherImages.image = #imageLiteral(resourceName: "radio-button-fill")
            friendsImage.image = #imageLiteral(resourceName: "radio-button")
            adsImages.image = #imageLiteral(resourceName: "radio-button")
            socialImages.image = #imageLiteral(resourceName: "radio-button")
            otherField.isHidden = false
        default:
            break
        }
    }
    
    
    @objc func searchWorkersAsPerText(_ textfield:UITextField) {
        guard let text = otherField.text else {
            return
        }
        hear = text
    }
    
    
    
    @IBAction func foodQualityAction(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            foodHappyImage.tintColor = UIColor(named: "MainColor")
            foodMediumImage.tintColor = UIColor.darkGray
            foodSadImage.tintColor = UIColor.darkGray
            foodQuality = "1"
        case 1:
            foodHappyImage.tintColor = UIColor.darkGray
            foodMediumImage.tintColor = UIColor(named: "MainColor")
            foodSadImage.tintColor = UIColor.darkGray
            foodQuality = "2"
        case 2:
            foodHappyImage.tintColor = UIColor.darkGray
            foodMediumImage.tintColor = UIColor.darkGray
            foodSadImage.tintColor = UIColor(named: "MainColor")
            foodQuality = "3"
        default:
            break
        }
    }
    
    @IBAction func beverageQualityAction(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            beverageHappyImage.tintColor = UIColor(named: "MainColor")
            beverageMediumImage.tintColor = UIColor.darkGray
            beverageSadImage.tintColor = UIColor.darkGray
            beverageQuality = "1"
        case 1:
            beverageHappyImage.tintColor = UIColor.darkGray
            beverageMediumImage.tintColor = UIColor(named: "MainColor")
            beverageSadImage.tintColor = UIColor.darkGray
            beverageQuality = "2"
        case 2:
            beverageHappyImage.tintColor = UIColor.darkGray
            beverageMediumImage.tintColor = UIColor.darkGray
            beverageSadImage.tintColor = UIColor(named: "MainColor")
            beverageQuality = "3"
        default:
            break
        }
    }
    
    @IBAction func hospilityAction(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            hospHappyImage.tintColor = UIColor(named: "MainColor")
            hospMediumImage.tintColor = UIColor.darkGray
            hospSadImage.tintColor = UIColor.darkGray
            hosipility = "1"
        case 1:
            hospHappyImage.tintColor = UIColor.darkGray
            hospMediumImage.tintColor = UIColor(named: "MainColor")
            hospSadImage.tintColor = UIColor.darkGray
            hosipility = "2"
        case 2:
            hospHappyImage.tintColor = UIColor.darkGray
            hospMediumImage.tintColor = UIColor.darkGray
            hospSadImage.tintColor = UIColor(named: "MainColor")
            hosipility = "3"
        default:
            break
        }
    }
    
    @IBAction func overallAction(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            overallHappy.tintColor = UIColor(named: "MainColor")
            overallMediumImage.tintColor = UIColor.darkGray
            overallSadImage.tintColor = UIColor.darkGray
            overall = "1"
        case 1:
            overallHappy.tintColor = UIColor.darkGray
            overallMediumImage.tintColor = UIColor(named: "MainColor")
            overallSadImage.tintColor = UIColor.darkGray
            overall = "2"
        case 2:
            overallHappy.tintColor = UIColor.darkGray
            overallMediumImage.tintColor = UIColor.darkGray
            overallSadImage.tintColor = UIColor(named: "MainColor")
            overall = "3"
        default:
            break
        }
    }
    
    @IBAction func submitAction(_ sender: Any) {
        
        if let comment = commentField.text {
            self.comment = comment
        }
        
        if let name = nameField.text {
            guestName = name
        }
        
        if let email = emailField.text {
            guestEmail = email
        }
        
        if let address = addressField.text {
            guestAddress = address
        }
        
        if let mobile = mobilefield.text {
            guestMobile = mobile
        }
        
        APIManager.reviewsAPI(meal: meal, food_quality: foodQuality, beverages_quality: beverageQuality, hospitality: hosipility, overall_experience: overall, hear_about_us: hear, visit_date: timeVisit, guest_name: guestName, guest_mobile: guestMobile, guest_address: guestAddress, guest_email: guestEmail, comment: comment, view: self.view) { (error, success) in
            
            if error != nil || !success{
                return
            }
            
            self.showToast(message: NSLocalizedString("review_thanks", comment: ""), controller: self)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                self.dismiss(animated: true, completion: nil)
            })
        }
    }
}
