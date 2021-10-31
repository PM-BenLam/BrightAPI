
import SwiftUI

let get = GetData()

extension Double {
    func removeZerosFromEnd() -> String {
        let formatter = NumberFormatter()
        let number = NSNumber(value: self)
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 16 //maximum digits in Double after dot (maximum precision)
        return String(formatter.string(from: number) ?? "")
    }
}

extension Collection where Indices.Iterator.Element == Index
{
   public subscript(safe index: Index) -> Iterator.Element?
    {
     return (startIndex <= index && index < endIndex) ? self[index] : nil
   }
}

class AppManager: ObservableObject
{
    static let sharedInstance = AppManager()
    
    @Published var currentPage: Page = .LoginPage
    @Published var authToken: String? = nil
    @Published var resourceId: String? = nil
    
    private init() { }
}

enum Page
{
    case MainPage
    case ChartPage
    case LoginPage
}

struct ContentView: View
{
    
    @ObservedObject var appManager = AppManager.sharedInstance
    
    var body: some View
    {
        switch(appManager.currentPage)
        {
        
        case .LoginPage:
            LoginPage()
            
        case .MainPage:
            MainPage()
            
        case .ChartPage:
            ChartPage()
        }
       
    }
}
