//
//  OpenweatherAPIClient.swift
//  WeatherTask
//
//  Created by Amr Mohamed on 16/03/2023.
//

import Foundation
import MapKit

class OpenweatherAPIClient {
    typealias CurrentWeatherCompletionHandler = (CurrentWeather?, Error?) -> Void
    typealias ForecastWeatherCompletionHandler = (ForecastWeatherResponse?, Error?) -> Void

    private let apiKey = "10609a35b88d5a6b241b79ca6f3233bb"
    private let decoder = JSONDecoder()
    private let session: URLSession
    var url: URL?
    var locManager = CLLocationManager()
    var currentLocation: CLLocation!

    private enum SuffixURL: String {
        case forecastWeather = "forecast"
        case currentWeather = "weather"
    }
        
    private func baseUrl(_ suffixURL: SuffixURL, param: String?) -> URL {
        return URL(string: "https://api.openweathermap.org/data/2.5/\(suffixURL.rawValue)?appid=\(self.apiKey)&units=metric\(param ?? "")")!
    }
        
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
        
    private func getBaseRequest<T: Codable>(at cityId: String,
                                            suffixURL: SuffixURL,
                                            completionHandler completion:  @escaping (_ object: T?,_ error: Error?) -> ()) {
        
     
        IntentHelper.sharedInstance.getCurrentCoordinates()
        let lat = IntentHelper.sharedInstance.locManager.location?.coordinate.latitude
        let long = IntentHelper.sharedInstance.locManager.location?.coordinate.longitude

        
        url = baseUrl(suffixURL, param: "&lat=\(lat ?? 0.0)&lon=\(long ?? 0.0)")

        
        let request = URLRequest(url: url!)
        
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    guard let httpResponse = response as? HTTPURLResponse else {
                        completion(nil, ResponseError.requestFailed)
                        return
                    }
                    
                    if httpResponse.statusCode == 200 {
                        do {
                            let weather = try self.decoder.decode(T.self, from: data)
                            completion(weather, nil)
                        } catch let error {
                            completion(nil, error)
                        }
                    } else {
                        completion(nil, ResponseError.invalidData)
                    }
                } else if let error = error {
                    completion(nil, error)
                }
            }
        }
        
        task.resume()
    }
    
    
    func getForecastWeather(at cityId: Int, completionHandler completion: @escaping ForecastWeatherCompletionHandler) {
        getBaseRequest(at: "\(cityId)", suffixURL: .forecastWeather) { (weather: ForecastWeatherResponse?, error) in
            completion(weather, error)
        }
    }
    
    func getCurrentWeather(at cityId: Int, completionHandler completion: @escaping CurrentWeatherCompletionHandler) {
        getBaseRequest(at: "\(cityId)", suffixURL: .currentWeather) { (weather: CurrentWeather?, error) in
            completion(weather, error)
        }
    }
    
}



