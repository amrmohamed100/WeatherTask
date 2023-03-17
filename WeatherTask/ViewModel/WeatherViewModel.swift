//
//  WeatherViewModel.swift
//  WeatherTask
//
//  Created by Amr Mohamed on 16/03/2023.
//

import Foundation

import SwiftUI
import Combine

class WeatherViewModel: ObservableObject {
    let client = OpenweatherAPIClient()
    
    var stateView: StateView = StateView.loading {
        willSet {
            objectWillChange.send()
        }
    }
    
    var currentWeather = CurrentWeather.emptyInit() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var todayWeather = ForecastWeather.emptyInit() {
        willSet {
            objectWillChange.send()
        }
    }
    
    var hourlyWeathers: [ForecastWeather] = [] {
        willSet {
            objectWillChange.send()
        }
    }
    
    var dailyWeathers: [ForecastWeather] = [] {
        willSet {
            objectWillChange.send()
        }
    }
    
    var currentDescription = "" {
        willSet {
            objectWillChange.send()
        }
    }
    
    private var stateCurrentWeather = StateView.loading
    private var stateForecastWeather = StateView.loading
    var cityId: Int?
    
    init() {
        getData()
    }
    
    func retry() {
        stateView = .loading
        stateCurrentWeather = .loading
        stateForecastWeather = .loading
        
        getData()
    }
    
    private func getData() {
        
        client.getForecastWeather(at: cityId ?? 0) { [weak self] forecastWeatherResponse, error in
            guard let ws = self else { return }
            if let forecastWeatherResponse = forecastWeatherResponse {
                ws.hourlyWeathers = forecastWeatherResponse.list
                ws.dailyWeathers = forecastWeatherResponse.dailyList
                self?.cityId = forecastWeatherResponse.city.id
                
                ws.stateForecastWeather = .success
                self?.client.getCurrentWeather(at: self?.cityId ?? 0) { [weak self] currentWeather, error in
                    guard let ws = self else { return }
                    if let currentWeather = currentWeather {
                        ws.currentWeather = currentWeather
                        ws.todayWeather = currentWeather.getForecastWeather()
                        ws.currentDescription = currentWeather.description()
                        self?.cityId = currentWeather.id
                        ws.stateCurrentWeather = .success
                        
                    } else {
                        ws.stateCurrentWeather = .failed
                    }
                    ws.updateStateView()
                }
            } else {
                ws.stateForecastWeather = .failed
            }
            ws.updateStateView()
        }
    }
    
    private func updateStateView() {
        if stateCurrentWeather == .success, stateForecastWeather == .success {
            stateView = .success
        }
        
        if stateCurrentWeather == .failed, stateForecastWeather == .failed {
            stateView = .failed
        }
    }
}
