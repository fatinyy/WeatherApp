//
//  WeatherViewController.swift
//  Weather
//
//  Created by aifara on 07/03/2024.
//


import UIKit
import CoreLocation
import Foundation


class WeatherViewController: UIViewController{
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var temperatureDescriptionLabel: UILabel!
    @IBOutlet weak var fiveDayCollectionView: UICollectionView!
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    var fiveDayData : [WeatherModel] = []
    var weatherData: [ForecastData] = []
    
    @IBOutlet weak var searchTextField: UITextField!
    override func viewDidLoad(){
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

        
        weatherManager.delegate = self
        searchTextField.delegate = self
        
        fiveDayCollectionView.delegate = self
        fiveDayCollectionView.dataSource = self
        
        
//        fetchWeatherData()
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true)
    }
    
    
    @IBAction func currentLocationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    @IBAction func mapButtonPressed(_ sender: UIButton) {
        
             let storyboard = UIStoryboard(name: "Main", bundle: nil)
             let mapView = storyboard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController

             mapView.modalPresentationStyle = .popover
             self.present(mapView, animated: true, completion: nil)
    }
    
    
}



//MARK: - WeatherViewController
extension WeatherViewController:WeatherManagerDelegate{
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: [WeatherModel]) {
        

        
        DispatchQueue.main.async{
            
            self.fiveDayData = weather
            
            self.fiveDayCollectionView.reloadData()
            
            
            for model in weather {
                print("Condition ID: \(model.conditionId)")
                print("City Name: \(model.cityName)")
                print("Temperature: \(model.temperature)°C")
                
            }
            
        
        }
    }
    
    
    func didUpdateWeather(_ weatherManagerManager: WeatherManager, weather: WeatherModel){

        DispatchQueue.main.async{
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}


//MARK: - CLLocationManagerDelegate

extension WeatherViewController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
        
            
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
            weatherManager.fetchWeatherForecast(latitude: lat, longitude: lon)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


extension WeatherViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fiveDayData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as! WeatherCollectionViewCell

               let weatherInfo = fiveDayData[indexPath.item]
            let formatTemp = String(format: "%.0f", weatherInfo.temperature)
        print("#############>>>>>\(weatherInfo.temperature)°C")

        cell.temperatureLabel.text = "\(formatTemp)°C"
               return cell
    }
    
    
    
    
}

extension WeatherViewController:UITextFieldDelegate{

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        searchTextField.endEditing(true)
        print(searchTextField.text!)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchTextField.text = ""
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != ""{
            return true
        }else{
            textField.placeholder = "Type something here"
            return false
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        if let city = searchTextField.text{
            weatherManager.fetchWeather(cityName: city)
            weatherManager.fetchWeatherForecast(cityName: city)
        }
        searchTextField.text = ""
    }
    
    
}


