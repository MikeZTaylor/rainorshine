//
//  WeatherGetter.swift
//  rainorshine
//
//  Created by Mike Taylor on 23/05/2017.
//  Copyright © 2017 Mike Taylor. All rights reserved.
//

import Foundation

protocol WeatherGetterDelegate {
    func didGetWeather(weather: Weather)
    func didNotGetWeather(error: NSError)
}


class WeatherGetter {
    
    private let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather"
    private let openWeatherMapAPIKey = "2f768cbd5608d3c5d334b1c37120af1d"
    private var delegate: WeatherGetterDelegate
    
    var coords = [String: Any]()
    var weatherInfo = [String: Any]()
    var windInfo = [String: Any]()
    var sun = [String: Any]()
    var clouds = [String: Any]()
    
    func getWeather(city: String) {
        
        // This is a pretty simple networking task, so the shared session will do.
        let session = URLSession.shared
        
        let weatherRequestURL = URL(string: "\(openWeatherMapBaseURL)?APPID=\(openWeatherMapAPIKey)&q=\(city)")!
        
        // The data task retrieves the data.
        
        let dataTask = session.dataTask(with: weatherRequestURL, completionHandler: {
            (data, response, error) in
            if let error = error {
                // Case 1: Error
                // We got some kind of error while trying to get data from the server.
                print("Error:\n\(error)")
            }
            else {
                // Case 2: Success
                // We got a response from the server!
                do {
                    // Try to convert that data into a Swift dictionary
                    let weather = try JSONSerialization.jsonObject(
                        with: data!,
                        options: .mutableContainers)  as! [String:Any] //Dictionary <AnyHashable, Any>
                    
                    // If we made it to this point, weíve successfully converted the
                    // JSON-formatted weather data into a Swift dictionary.
                    // Letís print its contents to the debug console.
                    print("Date and time: \(weather["dt"]!)")
                    print("City: \(weather["name"]!)")
                    
                    self.coords = weather["coord"] as! [String : Any]
                    print(self.coords["lon"]!)
                    print(self.coords["lat"]!)
                    
                    self.weatherInfo = weather["main"] as! [String : Any]
                    print(self.weatherInfo["temp"]!)
                    print(self.weatherInfo["humidity"]!)
                    print(self.weatherInfo["pressure"]!)
                    
                    self.windInfo = weather["wind"] as! [String : Any]
                    print(self.windInfo["deg"]!)
                    print(self.windInfo["speed"]!)
                    
                    self.sun = weather["sys"] as! [String : Any]
                    print(self.sun["country"]!)
                    print(self.sun["sunrise"]!)
                    print(self.sun["sunset"]!)
                    
                    //if self.clouds != nil {
                    //    print(self.clouds["all"]!)
                    //} else {
                    //    print("No Clouds today")
                   // }

                    
                    /*print("Latitude: \(weather["coord"]!["lat"]!!)")
                    print("Weather ID: \((weather["weather"]![0]! as! [String:AnyObject])["id"]!)")
                    print("Weather main: \((weather["weather"]![0]! as! [String:AnyObject])["main"]!)")
                    print("Weather description: \((weather["weather"]![0]! as! [String:AnyObject])["description"]!)")
                    print("Weather icon ID: \((weather["weather"]![0]! as! [String:AnyObject])["icon"]!)")
                    
                    print("Temperature: \(weather["main"]!["temp"]!!)")
                    print("Humidity: \(weather["main"]!["humidity"]!!)")
                    print("Pressure: \(weather["main"]!["pressure"]!!)")
                    
                    print("Cloud cover: \(weather["clouds"]!["all"]!!)")
                    
                    print("Wind direction: \(weather["wind"]!["deg"]!!) degrees")
                    print("Wind speed: \(weather["wind"]!["speed"]!!)")
                    
                    print("Country: \(weather["sys"]!["country"]!!)")
                    print("Sunrise: \(weather["sys"]!["sunrise"]!!)")
                    print("Sunset: \(weather["sys"]!["sunset"]!!)") */
                }
                catch let jsonError as NSError {
                    // An error occurred while trying to convert the data into a Swift dictionary.
                    print("JSON error description: \(jsonError.description)")
                }
            }
        })
        // The data task is set upÖlaunch it!
        dataTask.resume()
    }
    
}

