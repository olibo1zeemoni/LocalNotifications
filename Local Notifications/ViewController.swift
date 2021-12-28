//
//  ViewController.swift
//  Local Notifications
//
//  Created by Olibo moni on 28/12/2021.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    
    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var messageTF: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { permissionGranted, error in
            if (!permissionGranted) {
                print("Permission Denied")
            }
        }
    }
    
    
    @IBAction func scheduleAction(_ sender: UIButton) {
        notificationCenter.getNotificationSettings { [self] (settings) in
           
            DispatchQueue.main.async {
                let title = self.titleTF.text!
                let message = self.messageTF.text!
                let date = self.datePicker.date
                
                if(settings.authorizationStatus == .authorized){
                    let content = UNMutableNotificationContent()
                    content.title = title
                    content.body = message
                    content.sound = UNNotificationSound.default                    
                    content.badge = 1
                    
                    let dateComp = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: false)
                    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                    
                    self.notificationCenter.add(request) { (error) in
                        if(error != nil) {
                            print("Error" + error.debugDescription)
                            return
                        }
                        
                    }
                    let alertDialog  = UIAlertController(title: "Notification Scheduled", message: " @ " + formattedDate(date: date), preferredStyle: .alert)
                    alertDialog.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in }))
                    self.present(alertDialog, animated: true)
                    
                } else {
                    
                    let alertDialog  = UIAlertController(title: "Enable Notifications? ", message: "To use this feature you must enable notifications in settings", preferredStyle: .alert)
                    let goToSettings = UIAlertAction(title: "Settings", style: .default) { (_) in
                        guard let settingsURL = URL(string: UIApplication.openSettingsURLString)
                        else{ return}
                        
                        if(UIApplication.shared.canOpenURL(settingsURL)){
                            UIApplication.shared.open(settingsURL, options: [:]) { _ in
                                
                            }
                        }
                        
                    }
                    
                    alertDialog.addAction(goToSettings)
                    alertDialog.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in }))
                    self.present(alertDialog, animated: true)
                    
                }
            }
            
            
        }
    }
    
    func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM Y HH:mm"
        return formatter.string(from: date)
    }
    
    @IBAction func editingEnded(_ sender: UITextField){
        sender.resignFirstResponder()
    }
    
    
    

}

//Modifications to the layout engine must not be performed from a background thread after it has been accessed from the main thread.'
