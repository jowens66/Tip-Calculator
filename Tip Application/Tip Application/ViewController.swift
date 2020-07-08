//
//  ViewController.swift
//  Tip Application
//
//  Created by CPT265 on 2/25/19.
//  Copyright (c) 2019 CPT265. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var txtFieldBillAmount: UITextField!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var lblTipAmount: UILabel!
    
    @IBOutlet weak var errorMsgNumofPeople: UILabel!
    
    func OpenAlert(){
        //Create Alert Controller
        let alert = UIAlertController(title: "Error", message: "You can't leave # of people empty.", preferredStyle: UIAlertControllerStyle.Alert)
        
        //Creat Cancel Action
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        alert.addAction(cancel)
        
        //Create OK action
        
    }
    
    //This function links the slider and tip amount box to show how much the customer is tipping
    @IBAction func valueChanged(sender: AnyObject) {
        
        if(txtViewSplitBill == ""){
            errorMsgNumofPeople.hidden = false
        }
        
        var currentValue = Int(slider.value)
        lblTipAmount.text = "\(currentValue)"
    }
    
    @IBOutlet weak var lblPayment: UILabel!
    
    @IBOutlet weak var lblNumofPeople: UITextField!
    
    @IBOutlet weak var splitBillSelector: UISwitch!
    
    @IBOutlet weak var txtViewSplitBill: UITextField!
    
    @IBOutlet weak var lblErrorNumOfPeople: UILabel!
    
    @IBOutlet weak var lblPartyAmount: UILabel!
    
    @IBOutlet weak var lblBillAmountError: UILabel!
    
    @IBOutlet weak var lblPaymentLabel: UILabel!
    
    @IBOutlet weak var lblTipPaymentLabel: UILabel!
    
    //This function is for the switch to enable and disable textbox where you enter how many people are splitting the bill
    @IBAction func splitBill(sender: AnyObject) {
        
        //currently has a bug where is will not disable the textbox after having been switched from the on position back to the off
        if(splitBillSelector.on == false){
            txtViewSplitBill.hidden = true
        }
        if(splitBillSelector.on == true){
            txtViewSplitBill.hidden = false
        }        
    }
    
    
    @IBOutlet weak var lblTotalOutput: UILabel!
    
    
    @IBAction func splitBillPartyAmountLink(sender: AnyObject) {
        
        //var numberOfPeople = txtViewSplitBill.text
        //lblPartyAmount.text = "\(numberOfPeople)"
    }
    
    //This function calculates the tip by multiplying the bill and the tip amount and then dividing by 100
    
    @IBAction func btnCalculate(sender: AnyObject) {
        var errorFlag = false
        var formatter = NSNumberFormatter()       
        
        var BillAmount : String = txtFieldBillAmount.text!
        var BillAmountConverted = formatter.numberFromString(BillAmount)?.doubleValue
        
        var lblNumOfPeople : String = txtViewSplitBill.text!
        var NumOfPeopleConverted = formatter.numberFromString(lblNumOfPeople)?.doubleValue
        
        var TipAmount : String = lblTipAmount.text!
        var TipAmountConverted = formatter.numberFromString(TipAmount)?.doubleValue
        
        var FinalOutput : String = lblTotalOutput.text!
        var FinalOutputConverted = formatter.numberFromString(FinalOutput)?.doubleValue
        
        var splitBill : String = txtViewSplitBill.text!
        var splitBillConverted = formatter.numberFromString(splitBill)?.doubleValue
        
        
        
        
        
        lblBillAmountError.text = ""
        lblErrorNumOfPeople.text = ""
        
        //Bill Amount Validation
        if (BillAmount == ""){
            lblBillAmountError.text = "Required!"
            txtFieldBillAmount.becomeFirstResponder()
            lblPayment.text = ""
            lblTotalOutput.text = ""
            lblPaymentLabel.hidden = true
            lblTipPaymentLabel.hidden = true
            errorFlag = true
        }
        if(BillAmount != "" && BillAmountConverted <= 0){
            txtFieldBillAmount.text = ""
            lblBillAmountError.text = "Must be greater than 0!"
            txtFieldBillAmount.becomeFirstResponder()
            lblPayment.text = ""
            lblTotalOutput.text = ""
            lblPaymentLabel.hidden = true
            lblTipPaymentLabel.hidden = true
            errorFlag = true
        }
        if(lblNumOfPeople == ""){
            lblErrorNumOfPeople.text = "Required!"
            txtViewSplitBill.text = "1"
            lblPayment.text = ""
            lblTotalOutput.text = ""
            lblPaymentLabel.hidden = true
            lblTipPaymentLabel.hidden = true
            errorFlag = true
        }
        if(lblNumOfPeople != "" && NumOfPeopleConverted <= 0){
            txtViewSplitBill.text = "1"
            lblErrorNumOfPeople.text = "Must be greater than 0!"
            lblPayment.text = ""
            lblTotalOutput.text = ""
            lblPaymentLabel.hidden = true
            lblTipPaymentLabel.hidden = true
            errorFlag = true
        }
        if(lblNumOfPeople != "" && (ceil(splitBillConverted!) != floor(splitBillConverted!))){
            lblErrorNumOfPeople.text = "Must be a whole number!"
            txtViewSplitBill.text = "1"
            errorFlag = true
        }
        if(errorFlag == false){ //Mathematical Equations
        formatter.numberStyle = .CurrencyStyle
        /* You should tip */
            if(NumOfPeopleConverted == 1){
                lblPaymentLabel.text = "You should pay: "
                lblTipPaymentLabel.text = "You should tip: "
            }
            else{
                lblPaymentLabel.text = "Each person should pay: "
                lblTipPaymentLabel.text = "Each person should tip: "
            }
            
            lblPaymentLabel.hidden = false
                lblTipPaymentLabel.hidden = false
            lblTotalOutput.text = formatter.stringFromNumber(((BillAmountConverted! * TipAmountConverted!) / NumOfPeopleConverted!) / 100.00)
            // Each person should pay
            lblPayment.text = formatter.stringFromNumber(BillAmountConverted! / NumOfPeopleConverted!)
            
            if(splitBillSelector.on == false)
            {
                //alerts the user of their bill and tip totals if they are not in a group
                let messagePaymentSolo = lblPayment.text
                let messageTipSolo = lblTotalOutput.text
                let finalMessage = "You should pay\n" + messagePaymentSolo! + "\n" + "You should tip\n" + messageTipSolo!
                
                var string : String = lblErrorNumOfPeople.text!
                var alertSolobill = UIAlertController(title:"Your bill is", message: finalMessage, preferredStyle:UIAlertControllerStyle.Alert)
            
                alertSolobill.addAction(UIAlertAction(title:"OK",style: UIAlertActionStyle.Default, handler:nil))
                
                self.presentViewController(alertSolobill, animated:true, completion:nil)
            }
            else
            {
                //alerts the user of each person in the group's bill and how much they should tip
                
                let messagePaymentGroup = lblPayment.text
                let messageTipGroup = lblTotalOutput.text
                
                let finalMessage = "You should pay\n" + messagePaymentGroup! + "\n" + "You should tip\n" + messageTipGroup!
                
                var alertGroupbill = UIAlertController(title:"Each person's bill is", message: finalMessage, preferredStyle:UIAlertControllerStyle.Alert)
                
                alertGroupbill.addAction(UIAlertAction(title:"OK",style: UIAlertActionStyle.Default, handler:nil))
                
                self.presentViewController(alertGroupbill, animated:true, completion:nil)
                
                    
                        
            }
        }
    }
    
    
    @IBOutlet weak var buttonCalculate: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Color and style the calculate button
        buttonCalculate.layer.cornerRadius = 5
        buttonCalculate.layer.borderWidth = 1
        buttonCalculate.layer.borderColor = UIColor(red: 27/255, green: 174/255, blue: 35/255, alpha: 1.0).CGColor
    }
    

}

