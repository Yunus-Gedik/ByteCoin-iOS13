import UIKit

class ViewController: UIViewController {
    @IBOutlet var amount: UILabel!
    @IBOutlet var currencyLabel: UILabel!
    @IBOutlet var picker: UIPickerView!
    
    var coinManager = CoinManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coinManager.delegate = self
        picker.delegate = self
        picker.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        picker.delegate?.pickerView!(picker, didSelectRow: 0, inComponent: 0)
    }

}


extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        coinManager.fetchData(currencyRow: row)
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return coinManager.currencyArray[row]
    }
    
}

extension ViewController: CoinManagerDelegate{
    func didSuccess(coin: CoinData) {
        DispatchQueue.main.async {
            self.amount.text = String(format: "%.1f", coin.rate)
            self.currencyLabel.text = coin.asset_id_quote
        }
    }
    
    func didFail(error: Error) {
        print(error)
    }
}
