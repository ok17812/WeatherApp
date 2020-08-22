//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Evan Chang on 8/22/20.
//  Copyright © 2020 Evan Chang. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=eac53fefe5c9409fe90455d1d867849b&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let city = cityName.replacingOccurrences(of: " ", with: "+")
        let urlString = "\(weatherURL)&q=\(city)"
        performRequest(urlString: urlString)
    }
    
    func fetchWeaather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(urlString: urlString)
    }
    
    func performRequest(urlString: String) {
        //create a url
        if let url = URL(string: urlString) {
            
            //create a urlsession
            let session = URLSession(configuration: .default)
            
            //give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            //start the task
            task.resume()
        }
    }
    
    func parseJSON(weatherData: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do
        {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            //print(decodedData.name)
            let cityName = decodedData.name
            
            //print(decodedData.main.temp)
            let temp = decodedData.main.temp
            
            //print(decodedData.weather[0].description)
            
            //print(decodedData.weather[0].id)
            let id = decodedData.weather[0].id
            
            //print(decodedData.coord.lon)
            //print(decodedData.coord.lat)
            
            let weather = WeatherModel(conditionId: id, cityName: cityName, temperature: temp)
            return weather
            
        }
        catch
        {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
}




