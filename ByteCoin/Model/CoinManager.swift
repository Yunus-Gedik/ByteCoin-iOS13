import Foundation

protocol CoinManagerDelegate{
    func didSuccess(coin: CoinData)
    func didFail(error: Error)
}

struct CoinManager {

    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "5ABCB1FE-AD3E-482C-B1CE-56F8AFC834CD"
    let currencyArray = ["TRY","AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    var delegate: CoinManagerDelegate?
    
    func fetchData(currencyRow row: Int){
        if let url = URL(string: "\(baseURL)/\(currencyArray[row])?apikey=\(apiKey)") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate!.didFail(error: error!)
                    return
                }
                if let safeData = data {
                    if let coin = self.parseJSON(safeData) {
                        self.delegate!.didSuccess(coin: coin)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data)-> CoinData?{
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            return decodedData
            
        } catch {
            delegate!.didFail(error: error)
            return nil
        }
        
    }
    
    
}
