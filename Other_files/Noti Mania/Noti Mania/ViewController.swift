
import UIKit
import UserNotifications

class ViewController: UIViewController {

   // var usertagid = String()

    var tagidKeyConstant = ""
    var tagnameKeyConstant = ""
    var tagdescriptionKeyConstant = ""
    var tagnotidistanceKeyConstant = ""
    var notiswitchKeyConstant = ""
    var notiswitchstate : Bool = false
    var notidistance : String = ""
    var name : String = ""
    
    var immediate = 0.2
    var near = 2.0
    var far = 30.0
    var tagdistance = 0.0
    
    @IBAction func action(_ sender: Any)
    {
        let content = UNMutableNotificationContent()
        content.title = "Findme notification Reminder"
        content.body = "your device is over on your phone's range"
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
        
        tagidKeyConstant = "-KcSbKJCNaRB27aGovvQ"
        tagnameKeyConstant = "\(tagidKeyConstant)"+"tagnameKey"
        tagdescriptionKeyConstant = "\(tagidKeyConstant)"+"tagdescriptionKey"
        tagnotidistanceKeyConstant = "\(tagidKeyConstant)"+"tagnotidistanceKey"
        notiswitchKeyConstant = "\(tagidKeyConstant)"+"notiswitchKey"
        
        readData()

        if notiswitchstate == true {
            
            if notidistance == "Immediate(0 - 20 cm.)"
            {
                if tagdistance >= 0.19
                {
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                }
                
            }
            
            if notidistance == "Near(20 cm. - 2 m.)"
            {
                if tagdistance >= 1.99
                {
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                }
        
            }
            if notidistance == "Far(2 - 30 m.)"
            {
                if tagdistance >= 29.90
                {
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                }
                
            }
            
        }
        
}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Asked for permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func readData(){
        
        let defaults = UserDefaults.standard
        self.name = defaults.string(forKey:  tagnameKeyConstant)!
        self.notidistance = defaults.string(forKey:  tagnotidistanceKeyConstant)!
        self.notiswitchstate = defaults.bool(forKey:  notiswitchKeyConstant)
        
        
    
}

}
