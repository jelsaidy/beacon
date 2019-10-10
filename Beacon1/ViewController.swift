//
//  ViewController.swift
//  Beacon1
//
//  Created by Jacob El-Saidy on 8/8/19.
//  Copyright © 2019 Jacob El-Saidy. All rights reserved.
//


import CoreLocation
import UIKit
import UserNotifications
import WebKit
import SideMenu

class ViewController: UIViewController, CLLocationManagerDelegate, WKNavigationDelegate, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var firstName: UITextView!


    var locationManager: CLLocationManager!
    
    let notificationCenter = UNUserNotificationCenter.current()
    
    var notif = 0
    //save somewhere (user defaults)
    
    
    /*Loading the webview and setting it as the main view
    override func loadView() {
        
        webView = UIWebView()
        webView.navigationDelegate = self
        view = webView
    
    }
 */
    struct Response: Decodable {
        let billing_company_name: String
        let company_name: String
        let job_title: String
        let postal_country: String
        let comments: String
        let mobile: String
        let postal_state: String
        let state: String
        let last_name: String
        let postal_city: String
        let email: String
        let order_message: String
        let city: String
        let member_number: String
        let fax: String
        let diet: String
        let postal_postcode: String
        let address: String
        let gender: String
        let country: String
        let education: String
        let interests: String
        let first_name: String
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
    

        //Initialising the location services, requesting authorisation
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()


        
        //Printing out whether the user has allowed notifications of the application
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {
            (granted, error) in
            if granted {
                print("yes")
 
            } else {
                print("No")
            }
            
        }
        
        //Accessing the users location
        self.locationManager.requestAlwaysAuthorization()

        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        //URL Code to load the website and add a toolbar (Toolbar still not appearing)
        //setToolBar()
        let url = URL(string: "https://www.villages.sydney")!
        webView.load(URLRequest(url: url))
        
          
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        toolbarItems = [refresh]
        navigationController?.isToolbarHidden = false
        
        
            /* if let url = URL(string: "https://www.villages.sydney/account?json=1") {
           URLSession.shared.dataTask(with: url) { data, response, error in
              if let data = data {
                 if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
                 }
               }
           }.resume()
        }
 */
        
            if let url = URL(string: "https://www.villages.sydney/account?json=1") {
               URLSession.shared.dataTask(with: url) { data, response, error in
                  if let data = data {
                      do {
                         let res = try JSONDecoder().decode(Response.self, from: data)
                        self.firstName.text = res.first_name + res.last_name
                         print(res.first_name)
                      } catch let error {
                         print(error)
                      }
                   }
               }.resume()
            }
        

        
    
        
    }
    
    private lazy var userRequest: Void = {

        self.notifTiming()
        
        let alert = UIAlertController(title: "Did you want notifications for today?", message: "Were you looking to explore the area you are in and find some hot spots?", preferredStyle: .actionSheet)
        

    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in          self.notif = 1; }))
    alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { action in
        
        self.notif = 0;
        Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false, block: { timer in
            self.sendNotification(closeness: "Are you sure you don't want notifications?")
            if (self.notif == 0) {
                self.present(alert, animated: true)
            }
    })
        
    }))

    self.present(alert, animated: true)

            
            
    }()
    
    

    
    

    //Accessing the Core Location Framework to intitate scanning
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways {
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    startScanning()
                }
            }
        }
    }

    //Function to initiate scanning for a specific beacon, this can be grouped by UUID/Major/Minor
    func startScanning() {
        
        let uuid = UUID(uuidString: "f7826da6-4fa2-4e98-8024-bc5b71e0893e")!
       let beaconRegion = CLBeaconRegion(proximityUUID: uuid, identifier: "Kontakt")

        locationManager.startMonitoring(for: beaconRegion)
        locationManager.startRangingBeacons(in: beaconRegion)
        
        
    
    }

    
    //Function for each case based on the beacon distance
    func update(distance: CLProximity, minor: NSNumber) {
        
        if (notif == 1) {

        if (minor == 10001) {
            let url = URL(string: "https://www.villages.sydney/oxford-street")!
            webView.load(URLRequest(url: url))
            self.sendNotification(closeness: "you are near oxford st")
        }
        else if (minor == 10009) {
            let url = URL(string: "https://www.villages.sydney/newtown")!
            webView.load(URLRequest(url: url))
            self.sendNotification(closeness: "you are near newtown")
        }
        else if (minor == 10001){
            let url = URL(string: "https://www.villages.sydney/pyrmont-ultimo")!
            webView.load(URLRequest(url: url))
            self.sendNotification(closeness: "you are near pyrmont/ultimo")
        }
        
        }
        switch distance {
            
            case .unknown:
                break;

            case .far: do {
                //let body = "Far"
                print("1: " + minor.stringValue)
                //self.sendNotification(closeness: body)

            
                }

            case .near: do {
                //let body = "Near"
                print("2: " + minor.stringValue)
                //self.sendNotification(closeness: body)
                
                
                if (self.notif == 0) {
                    _ = userRequest
                    print (self.notif)
                } else { break; }

                }

            case .immediate: do {
               // let body = "Very Close"
                print("3: " + minor.stringValue)
               // self.sendNotification(closeness: body)

            
            }
            
            
    
        
        }
        }


    //Proximity Beacon Function, determining how far the beacon is.
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        if beacons.count > 0 {
            let beacon = beacons[0]
            update(distance: beacon.proximity, minor: beacon.minor)
        }
    }
    
    func locationManager(manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], inRegion region: CLBeaconRegion) {
        let knownBeacons = beacons.filter{ $0.proximity != CLProximity.unknown }
    if (knownBeacons.count > 0) {
        let closestBeacon = knownBeacons[0] as CLBeacon
    }
    
    //Notification Function, currently set at time interval of 1.
        
        

    
    //User Location Function
    
    /*
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("location = \(locValue.latitude) \(locValue.longitude)")
    }
 */
    
        
        /*
    func getAddressFromLatLon(pdblLatitude: String, withLongitude pdblLongitude: String) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = Double("\(pdblLatitude)")!
        //21.228124
        let lon: Double = Double("\(pdblLongitude)")!
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon

        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)


        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]

                if pm.count > 0 {
                    let pm = placemarks![0]
                    print(pm.country ?? <#default value#>)
                    print(pm.locality ?? <#default value#>)
                    print(pm.subLocality ?? <#default value#>)
                    print(pm.thoroughfare ?? <#default value#>)
                    print(pm.postalCode ?? <#default value#>)
                    print(pm.subThoroughfare ?? <#default value#>)
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }


                    print(addressString)
              }
        })
 }
 */

 
    }
    
    //Function to add a title when loading the webpage (Not 100% working as of yet)
    func webView(_ webView: WKWebView, navigation: WKNavigation!, navigationType: UIWebView.NavigationType) {
    title = webView.title
    }
    
func sendNotification(closeness: String) {
        
    let content = UNMutableNotificationContent()
    let categoryIdentifier5 = "Sydney Villages"
        
    content.title = "iBeacon";
    content.subtitle = "Location Notification";
    content.body = closeness;
    content.badge = 1;
    content.categoryIdentifier = categoryIdentifier5

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.001, repeats: false)
    let request = UNNotificationRequest(identifier: "notification.id.01", content: content, trigger: trigger)

    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "DeleteAction", title: "Delete", options: [.destructive])
    let category = UNNotificationCategory(identifier: categoryIdentifier5,
                                                 actions: [snoozeAction, deleteAction],
                                                 intentIdentifiers: [],
                                                 options: [])
           
           notificationCenter.setNotificationCategories([category])
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)

    }
          func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
               completionHandler([.alert, .badge, .sound])
           }
    

      fileprivate func setToolBar() {
        let screenWidth = self.view.bounds.width
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBack))
        let forwardButton = UIBarButtonItem(title: "Forward", style: .plain, target: self, action: #selector(goForward))
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 44))
        toolBar.isTranslucent = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        toolBar.items = [backButton, forwardButton]
        webView.addSubview(toolBar)
    // Constraints
        toolBar.bottomAnchor.constraint(equalTo: webView.bottomAnchor, constant: 0).isActive = true
        toolBar.leadingAnchor.constraint(equalTo: webView.leadingAnchor, constant: 0).isActive = true
        toolBar.trailingAnchor.constraint(equalTo: webView.trailingAnchor, constant: 0).isActive = true
      }
      @objc private func goBack() {
        if webView.canGoBack {
          webView.goBack()
        } else {
          self.dismiss(animated: true, completion: nil)
        }
      }
    
    @objc private func goForward() {
        if webView.canGoForward {
        webView.goForward()
      } else {
        self.dismiss(animated: true, completion: nil)
      }
    }

    
    func notifTiming() {
         let now = Date()
         let formatter = DateFormatter()
         formatter.dateFormat = "yyyyMMdd"
         let nowString = formatter.string(from: now)


         if let lastTime = UserDefaults.standard.string(forKey: "savedDate"), lastTime == nowString {

             print("same date")
             return
         }
         let content = UNMutableNotificationContent()
         content.title = "Sydney Villages"
         content.subtitle = "Someone is in the area"
         content.body = "Did you want notifications?"
         content.sound = UNNotificationSound.default
         content.badge = 1

         let identifier = "sydney"
         let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: nil)

         UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
             if error != nil {
               print("Error showing notification: \(error!.localizedDescription)")
             } else {
               print("Notification shown")
             }
         })

         UserDefaults.standard.set(nowString, forKey: "savedDate")
     }
    
    func resetTime() {
        Timer.scheduledTimer(withTimeInterval: 86400, repeats: false, block: {timer in do {self.notif = 0}}
        );}
}
    



