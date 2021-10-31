
import Foundation
import SwiftUI

struct MainPage: View
{
    let appManager = AppManager.sharedInstance
    
    func getLast30dayUsage () -> Int
    {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
            
        let endDate = dateFormatter.string(from: currentDate)
            
        let day30 = DateComponents(day: -30)
            
        guard let thirtyDayAgo: Date = Calendar(identifier: .gregorian).date(byAdding: day30, to: currentDate) else { return 0 }
        
        
        let startDate = dateFormatter.string(from: thirtyDayAgo)
        
        print(startDate)
        
        let JSON:[JSON] = get.specificDays(startDate: startDate, endDate: endDate)["data"].arrayValue
        
        var sum: Float = 0
        
        for data in JSON
        {
            
            if data.arrayValue[1].float != nil
            {
                sum += data.arrayValue[1].floatValue
            }
            
        }
        
        return Int(roundf(sum))
    }
    
    
    @State var energyData = String(get.current()["data"].arrayValue[0].arrayValue[1].intValue)
    
    let rate = 1.6
    var body: some View
    {
        Button(action: {
            energyData = String(get.current()["data"].arrayValue[0].arrayValue[1].intValue)
        }, label: {
            Text("\(energyData) W")
                .font(.system(size: 35, design: .monospaced))
                .frame(minWidth: 255, maxWidth: 255, minHeight: 250, maxHeight: 250)
                .contentShape(Circle())
        })
            .background(Color.secondary)
            .foregroundColor(.white).cornerRadius(1000)
            .padding(EdgeInsets(top: 50, leading: 10, bottom: 20, trailing: 10))
        
        Text("Press the circle to update")
            .multilineTextAlignment(.center)
            .padding()
            .foregroundColor(.secondary)
            .font(.system(size: 15, design: .monospaced))

       
        List
        {
            Text("Electricity overview:")
            
            Text("Last 30 day usage: \(String(getLast30dayUsage())) kWh")
            
            Text("View Chart")
                .onTapGesture { appManager.currentPage = .ChartPage }

        }.font(.system(size: 15, design: .monospaced))
        .padding()
        
        Spacer()
    
    }
}
