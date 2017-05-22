//
//  ViewController.swift
//  rainorshine
//
//  Created by Mike Taylor on 06/04/2017.
//  Copyright © 2017 Mike Taylor. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var weatherLabel: UILabel!
    
    var weatherLabelValues: [String] = ["Regular", "Soy", "Almond", "Milk"]
    
    
    var frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    
    private let dataManager = DataManager(baseURL: API.AuthenticatedBaseURL)
    
    
    public struct WeatherData {
        
        public let lat: Double
        public let long: Double
        
        public let hourData: [WeatherHourData]
        
        public init(lat: Double, long: Double, hourData: [WeatherHourData]) {
            self.lat = lat
            self.long = long
            self.hourData = hourData
        }
    }
    
    public struct WeatherHourData {
        
        public let time: Date
        public let windSpeed: Int
        public let temperature: Double
        public let precipitation: Double
        
        public init(time: Date, windSpeed: Int, temperature: Double, precipitation: Double) {
            self.time = time
            self.windSpeed = windSpeed
            self.temperature = temperature
            self.precipitation = precipitation
        }
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor(red:0.18, green:0.69, blue:0.82, alpha:1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        // Fetch Weather Data
        dataManager.weatherDataForLocation(latitude: Defaults.Latitude, longitude: Defaults.Longitude) { (response, error) in
            
            let test = response!["currently"] as? [String: Any]
            print(test?["apparentTemperature"] as Any)
            //print(response!["currently"])
            
        }
        
        
        //DispatchQueue.main.async(execute: {
            
         //   self.weatherLabel.text = self.weatherLabelValues[index]
         //   self.view.setNeedsDisplay()
        //    self.weatherLabel.setNeedsDisplay()
            
       // })
        
            //let MainWeatherController = storyboard?.instantiateViewController(withIdentifier: "MainWeatherController") as! MainWeatherController
           // MainWeatherController.selectedViewController = MainWeatherController.viewControllers?[0]
           // present(MainWeatherController, animated: true, completion: nil)
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }

}
