//
//  ViewController.swift
//  rainorshine
//
//  Created by Mike Taylor on 06/04/2017.
//  Copyright © 2017 Mike Taylor. All rights reserved.
//


import UIKit
import CoreLocation


fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}


class ViewController: UIViewController,
    WeatherGetterDelegate,
    CLLocationManagerDelegate,
    UITextFieldDelegate, UISearchBarDelegate
{
    
    // MARK: - Variables
    // -----------------------
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cloudCoverLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var rainLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var displayWeeatherImage: UIImageView!
    @IBOutlet weak var searchLocation: UISearchBar!
    
    @IBOutlet weak var temp_maxLabel: UILabel!
    @IBOutlet weak var temp_minLabel: UILabel!
    var searchActive : Bool = false
    var checkWeather : Bool = false
    var locationManager = CLLocationManager()
    var weather: WeatherGetter!
    
    
    
    var weatherImage: [UIImage] = [
        UIImage(named: "chanceofrain.png")!,
        UIImage(named: "clearnight.png")!,
        UIImage(named: "cloudy.png")!,
        UIImage(named: "cloudynight.png")!,
        UIImage(named: "foggy.png")!,
        UIImage(named: "heavyrain.png")!,
        UIImage(named: "heavystroms.png")!,
        UIImage(named: "lightrain.png")!,
        UIImage(named: "overcast.png")!,
        UIImage(named: "sun.png")!,
        UIImage(named: "windy.png")!
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weather = WeatherGetter(delegate: self)
        searchLocation.delegate = self
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        
        
        // Initialize UI
        cityLabel.text = "Waterford Ireland"
        weatherLabel.text = "Clear Skies"
        temperatureLabel.text = "10°"
        temp_maxLabel.text = "10°"
        temp_minLabel.text = "10°"
        cloudCoverLabel.text = "partly"
        windLabel.text = "20"
        rainLabel.text = "None"
        humidityLabel.text = "44"
        pressureLabel.text = "10"
        searchLocation.text = ""
        searchLocation.placeholder = "Search for City"
        searchLocation.enablesReturnKeyAutomatically = true
        
        getLocation()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - Search Bar
    // --------------------------------
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchLocation.text, !text.trimmed.isEmpty else {
            return
        }
        weather.getWeatherByCity(searchLocation.text!.urlEncoded)
        searchActive = false;
        self.searchLocation.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    
    // MARK: - WeatherGetterDelegate methods
    // -----------------------------------
    
    func didGetWeather(_ weather: Weather) {
        // that updates all the labels in a dispatch_async() call.
        DispatchQueue.main.async {
            self.cityLabel.text = weather.city
            self.weatherLabel.text = weather.weatherDescription
            self.pressureLabel.text = "\(weather.pressure)%"
            self.temperatureLabel.text = "\(Int(round(weather.tempCelsius)))°"
            self.temp_maxLabel.text = "\(Int(round(weather.minTempCelsius)))°"
            self.temp_minLabel.text = "\(Int(round(weather.maxTempCelsius)))°"
            self.cloudCoverLabel.text = "\(weather.cloudCover)%"
            self.windLabel.text = "\(Int(round(weather.windSpeed))) m/s"
            
            if let rain = weather.rainfallInLast3Hours {
                self.rainLabel.text = "\(rain) mm"
            }
            else {
                self.rainLabel.text = "None"
            }
            
            self.humidityLabel.text = "\(weather.humidity)%"
            
            let currentWeatherDesc = weather.mainWeather
            
            if  (currentWeatherDesc == "Rain")  {
                self.displayWeeatherImage.image = self.weatherImage[0]
            }
            else if (currentWeatherDesc == "Mist") {
                self.displayWeeatherImage.image = self.weatherImage[8]
            }
            else if (currentWeatherDesc == "Haze") {
                self.displayWeeatherImage.image = self.weatherImage[4]
            }
            else if (currentWeatherDesc == "Drizzle") {
                self.displayWeeatherImage.image = self.weatherImage[3]
            }
            else if (currentWeatherDesc == "Clouds") {
                self.displayWeeatherImage.image = self.weatherImage[2]
            }
            else if (currentWeatherDesc == "Clear") {
                if now >= eight_today && now <= four_thirty_today
                {
                    self.displayWeeatherImage.image = self.weatherImage[9]
                }
                else {
                    self.displayWeeatherImage.image = self.weatherImage[1]
                }
            }
            else {
                self.displayWeeatherImage.image = self.weatherImage[10]
            }
            
            print(weather.weatherIconID)
            print(weather.mainWeather)
            
        }
    }
    
    func didNotGetWeather(_ error: Error) {
        // to showSimpleAlert(title:message:) in a dispatch_async() call.
        DispatchQueue.main.async {
            self.showSimpleAlert(title: "Can't get the weather",
                                 message: "The weather service isn't responding.")
            
        }
        print("didNotGetWeather error: \(error)")
    }
    
    
    // MARK: - CLLocationManagerDelegate and related methods
    
    func getLocation() {
        guard CLLocationManager.locationServicesEnabled() else {
            showSimpleAlert(
                title: "Please turn on location services",
                message: "rainorshine needs location services in order to report the weather " +
                    "for your current location.\n" +
                "Go to Settings → Privacy → Location Services and turn location services on."
            )
            return
        }
        
        let authStatus = CLLocationManager.authorizationStatus()
        guard authStatus == .authorizedWhenInUse else {
            switch authStatus {
            case .denied, .restricted:
                let alert = UIAlertController(
                    title: "Location services for this app are disabled",
                    message: "In order to get your current location, please open Settings for this rainorshine, choose \"Location\"  and set \"Allow location access\" to \"While Using the App\".",
                    preferredStyle: .alert
                )
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let openSettingsAction = UIAlertAction(title: "Open Settings", style: .default) {
                    action in
                    if let url = URL(string: UIApplicationOpenSettingsURLString) {
                        UIApplication.shared.open(URL(string: "\(url)")!)
                    }
                }
                alert.addAction(cancelAction)
                alert.addAction(openSettingsAction)
                present(alert, animated: true, completion: nil)
                return
                
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
                
            default:
                print("Oops! Shouldn't have come this far.")
            }
            
            return
        }
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last!
        weather.getWeatherByCoordinates(latitude: newLocation.coordinate.latitude,
                                        longitude: newLocation.coordinate.longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // This method is called asynchronously, which means it won't execute in the main queue.
        // All UI code needs to execute in the main queue, which is why we're wrapping the call
        // to showSimpleAlert(title:message:) in a dispatch_async() call.
        DispatchQueue.main.async {
            self.showSimpleAlert(title: "Woops! Can't determine your current location",
                                 message: "The GPS and other location services aren't responding.")
        }
        print("locationManager didFailWithError: \(error)")
    }
    
    
    // Tapping on the view should dismiss the keyboard.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    // MARK: - Utility methods
    // -----------------------
    
    func showSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: "OK",
            style:  .default,
            handler: nil
        )
        alert.addAction(okAction)
        present(
            alert,
            animated: true,
            completion: nil
        )
    }
    
}

// MARK: - Extensions
// -----------------------

extension String {
    
    // A handy method for %-encoding strings containing spaces and other
    // characters that need to be converted for use in URLs.
    var urlEncoded: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlUserAllowed)!
    }
    
    // Trim excess whitespace from the start and end of the string.
    var trimmed: String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
}

extension Date
{
    
    func dateAt(hours: Int, minutes: Int) -> Date
    {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        
        //get the month/day/year componentsfor today's date.
        
        
        var date_components = calendar.components(
            [NSCalendar.Unit.year,
             NSCalendar.Unit.month,
             NSCalendar.Unit.day],
            from: self)
        
        //Create an NSDate for the specified time today.
        date_components.hour = hours
        date_components.minute = minutes
        date_components.second = 0
        
        let newDate = calendar.date(from: date_components)!
        return newDate
    }
}


let now = Date()
let eight_today = now.dateAt(hours: 8, minutes: 0)
let four_thirty_today = now.dateAt(hours: 16, minutes: 30)
