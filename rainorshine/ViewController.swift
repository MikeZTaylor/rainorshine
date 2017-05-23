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
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var temp: UILabel!
    
    var weatherLabelValues: [String] = ["Regular", "Soy", "Almond", "Milk"]
    var currentWeather = [String: Any]()
        //var currentWeather: [String] = ["apparentTemperature", "cloudCover", "dewPoint", "humidity", "icon". "nearestStormBearing", "nearestStormDistance", "ozone", "precipIntensity", "precipProbability", "pressure", "summary", "temperature",]
    
    private let dataManager = DataManager(baseURL: API.AuthenticatedBaseURL)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.barTintColor = UIColor(red:0.18, green:0.69, blue:0.82, alpha:1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        // Fetch Weather Data
        //dataManager.weatherDataForLocation(latitude: Defaults.Latitude, longitude: Defaults.Longitude) { (response, error) in
            
           // self.currentWeather = (response!["currently"] as? [String: Any])!
            //print(test?["apparentTemperature"] as Any)
            //print(response!["currently"])
            
            //self.temperature.text = (self.currentWeather["summary"] as! String)
            //self.temp.text = "\(self.currentWeather["summary"] ?? 0)"
            //self.temp.text = "\(String(describing: self.currentWeather["apparentTemperature"]))"
            //print("color: \(color ?? "")")
            //var stringOfDBL = "\(myDouble)
            
        //}
        
        let weather = WeatherGetter()
        weather.getWeather(city: "Tampa")
        
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
