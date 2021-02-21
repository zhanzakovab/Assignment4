//
//  ViewController.swift
//  lecture8
//
//  Created by admin on 08.02.2021.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temp: UILabel!
    @IBOutlet weak var feelsLikeTemp: UILabel!
    @IBOutlet weak var desc: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!

    
    var myData: Model?
    var city = "Almaty"
    
    private var decoder: JSONDecoder = JSONDecoder()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TableViewCell.nib, forCellReuseIdentifier: TableViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CollectionViewCell.nib, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        fetchData()
    }
    
    
    func updateUI(){
        cityName.text = city
        temp.text = "\(myData?.current?.temp ??  0) °C"
        feelsLikeTemp.text = "\(myData?.current?.feels_like ?? 0) °C"
        desc.text = myData?.current?.weather?.first?.description
        collectionView.reloadData()
        tableView.reloadData()
    }
    
    func fetchData(){
        let url = Constants.host + "?lat=\(Constants.lat)&lon=\(Constants.lon)&exclude=\(Constants.exclude)&appid=\(Constants.apiKey)&units=metric"
        AF.request(url).responseJSON { (response) in
            switch response.result{
            case .success(_):
                guard let data = response.data else { return }
                guard let answer = try? self.decoder.decode(Model.self, from: data) else{ return }
                self.myData = answer
                self.updateUI()
            case .failure(let err):
                print(err.errorDescription ?? "")
            }
        }
    }
    
    @IBAction func valueChanged(_ sender: Any) {
        switch segmentedControl.selectedSegmentIndex {
            case 0:
                Constants.lat = "51.1801"
                Constants.lon = "71.446"
                city = "Almaty"
            case 1:
                    Constants.lat = "54.87"
                    Constants.lon = "69.15"
                city = "New-York"
            case 2:
                Constants.lat = "33.44"
                Constants.lon = "-94.04"
                city = "London"
            default:
                break
        }
        fetchData()
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myData?.daily?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
            let item = myData?.daily?[indexPath.row]
        let date = Date(timeIntervalSince1970: TimeInterval(item!.dt))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.none
        dateFormatter.dateStyle = DateFormatter.Style.medium 
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        cell.date.text = localDate
            cell.temp.text = "\(item?.temp?.day ?? 0) °C"
            cell.feelsLike.text = "\(item?.feels_like?.day ?? 0) °C"
            cell.desc.text = item?.weather?[0].description
            return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}


extension ViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myData?.hourly?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        let item = myData?.hourly?[indexPath.item]
        cell.temp.text = "\(item?.temp ??  0) °C"
        cell.feelsLike.text = "\(item?.feels_like ??  0) °C"
        cell.desc.text = item?.weather?.first?.description
        return cell

    }
    
    
}

extension ViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
}


