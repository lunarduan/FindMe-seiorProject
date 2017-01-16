//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

print(str)

let maxscore = 100
var score = 20

let Maxscore:Int = 100
var Subject:String = "Computer"

var num1 = 10
var num2 = 5
var sum = num1 + num2
var mod = num1 % num2

var str1 = "hello"
var str2 = "duan"
var concat = str1 + " " + str2

//เราสามารถเข้าถึงค่าภายใน Tuple ได้ 2 วิธี
//วิธีที่ 1 ผ่าน index (ตำแหน่ง)
let appDetail = (12, "Share.OlanLab.Com")
print("Applicant age is \(appDetail.0)")
print("Applicant name is \(appDetail.1)")

//วิธีที่ 2 ผ่าน Name (ชื่อ)
let applicantDetails = (applicantAge:12, applicantName:"Henry")
print("Applicant age is \(applicantDetails.applicantAge)")
print("Applicant name is \(applicantDetails.applicantName)")

//นำค่าภายใน Tuple ส่งไปเก็บภายในตัวแปรแต่ละตัวได้
let appDetails = (12, "Henry")
let (applicantAge, applicantName) = appDetails
print("Applicant age is \(applicantAge)")
print("Applicant name is \(applicantName)")

//function 
func test_method(){
    print ("Lunar")
}

func return_method()->String{
    return "duan"
}

test_method()
return_method() //ถ้่าบางครั้งมี warning ให้แก้เป็น _ = return_method เพราะว่ามีการรีเทิร์นค่าแต่เราไมไ่ด้ต้องการใช้ค่า

let result = return_method()
print (result)

//funtion that have argument
func single_arg(args:String){
    print("input = \(args)")
}
single_arg(args: "haloooo") //calling function

func multiple_args(arg1:String, arg2:Int, arg3:Bool){
    print("arg1 = \(arg1)")
    print("arg2 = \(arg2)")
    print("arg3 = \(arg3)")
}
multiple_args(arg1: "yeah", arg2: 10, arg3: true)

//dev function that has external paramiter(can use outside function cannot use in function but its value will pass to arg1 with the same type)
func external_param_method(arg: String, exparam arg1:Int){
    print(arg1)
}

external_param_method(arg: "this is arg", exparam: 111)

//ตัวแปรแบบ optional คือมีค่าหรือไม่มีค่าก็ได้ ถ้าไม่ถูกกำหนดค่าจะเป็น nil
var optiondouble : Double? = 10.25
var doubles : Double = 10.35

var scores : Int? = 10
if (scores != nil) {
    print("Your score is \(scores)")
}

if (scores != nil) {
    print("Your score is \(scores!)") // unwrapping optional
}
else if (true){
    print ("yes")
}

var Score : Int? = 12
if let unwrappedScore = Score { // optional binding
    print("Your score is \(unwrappedScore)")
}
//ถ้า Optional มีค่าเสมอ เราสามารถกำหนดเป็น Implicit Unwrapped Optional
var Scores : Int! = 20
print("Your score is \(Scores)")

//switch case 
let numberOfMarbles = 4;
switch numberOfMarbles {
case 1:
    print("You have just one marble.")
case 2,3,4,5:
    print("You have a few marbles.")
default:
    print("You have way too many marbles!")
}

//for loop
for i in 0..<5 {
    print("Loading \(i * 10)%")
}

for index in 1...5 {
    print("\(index) times 5 is \(index * 5)")
}

let base = 2
let power = 5
var answer = 1
for _ in 1...power {
    answer *= base
}
print("\(base) to the power of \(power) is \(answer)")


//repeat-while loop same as do-while
var number = 1
repeat {
    print("The value of number is \(number)")
    number = number + 1
} while number < 5

//continue
var num = 1
while num < 15{
    if (num % 13 == 0){ // หาร 13 ลงตัว
        num += 1
        continue // ข้ามไปทำงานรอบต่อไป
    }
    print("\(num) is not divisible by 13.")
    num += 1;
}

//fallthrough เพื่อให้ทำงาน switch-case ต่อเนื่อง
let integerToDescribe = 5
var description = "The number \(integerToDescribe) is"
switch integerToDescribe {
    
case 2,3,5,7,11,13,17,19:
    description += " a prime number, and also"
    print(integerToDescribe)
    fallthrough
case 1:
    description += " not number"
    fallthrough
default:
    description += " an integer."
}
print(description)


//บันไดงู
let finalSquare = 25
var board = [Int](repeating: 0, count: finalSquare + 1) // สร้างช่องในบอร์ดเกมส์
board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02 // บันได
board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08 // งู
var square = 0
var diceRoll = 0

gameLoop: while square != finalSquare {
    diceRoll += 1
    if diceRoll == 7 { diceRoll = 1 }
    switch square + diceRoll {
    case finalSquare:
        // เมื่อมาถึง finalSquare เกมส์จบ
        break gameLoop
    case let newSquare where newSquare > finalSquare:
        // ถ้าถอยเต๋าเกินกว่าช่องสุดท้ายก็ถอยใหม่
        continue gameLoop
    default:
        // เมื่อถอยเต๋าเสร็จ ก็เดินบนบอร์ดเกมส์
        square += diceRoll
        square += board[square]
    }
}
print("Game over!")



//control tranfer statement
func greet(person: [String: String]) {
    guard let name = person["name"] else {
        return
    }
    
    print("Hello \(name)!")
    
    guard let location = person["location"] else {
        print("I hope the weather is nice near you.")
        return
    }
    
    print("I hope the weather is nice in \(location).")
}

greet(person: ["name": "John"])
greet(person: ["name": "Jane", "location": "Cupertino"])



print("...............................................................")

import UIKit
import CoreLocation

print("test1")

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager: CLLocationManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
    }
    
    func startScanning() {
        let uuid = UUID(uuidString: "5A4BCFCE-174E-4BAC-A814-092E77F6B7E5")!
        let beaconRegion = CLBeaconRegion(proximityUUID: uuid, major: 123, minor: 456, identifier: "MyBeacon")
        
        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
    }
    
    func updateDistance(_ distance: CLProximity) {
        UIView.animate(withDuration: 0.8) {
            print("test2")
            switch distance {
            case .unknown:
                self.view.backgroundColor = UIColor.gray
                
            case .far:
                self.view.backgroundColor = UIColor.blue
                
            case .near:
                self.view.backgroundColor = UIColor.orange
                
            case .immediate:
                self.view.backgroundColor = UIColor.red
            default:
                self.view.backgroundColor = UIColor.black
                
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            updateDistance(beacons[0].proximity)
        } else {
            print("else")
            updateDistance(.unknown)
        }
    }
    
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
