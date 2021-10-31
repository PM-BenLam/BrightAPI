import SwiftUI

struct ChartData: Hashable
{
     var label: String
     var value: Double
}

struct ChartPage: View
{
   
    func getChartData (monthsAgo: Int) -> ChartData
    {
        
        var output: ChartData
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
            
        guard let nextMonth = Calendar(identifier: .gregorian).date(bySetting: Calendar.Component.day, value: 1, of: currentDate) else { return ChartData(label: "", value: 0)}
        
        func reduceMonth(by: Int, toDate: Date) -> Date
        {
            let reduction = DateComponents(month: -by)
            
            return Calendar(identifier: .gregorian).date(byAdding: reduction, to: toDate) ?? toDate
        }
        
        let endDate = reduceMonth(by: monthsAgo, toDate: nextMonth)
        let startDate = reduceMonth(by: monthsAgo + 1, toDate: nextMonth)
        
        let endDateString = dateFormatter.string(from: endDate)
        let startDateString = dateFormatter.string(from: startDate)
        
        
        let JSON: [JSON] = get.specificDays(startDate: startDateString, endDate: endDateString)["data"].arrayValue
         
        
        var sum: Float = 0
         
        for data in JSON
        {
             
            if data.arrayValue[1].float != nil
            {
                sum += data.arrayValue[1].floatValue
            }
             
        }
        print(sum)
        
        func getMonth(fromDate: Date) -> String
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "LLLL"
            let fullMonthName = dateFormatter.string(from: fromDate)
            
            let shortenedMonthName = String(fullMonthName.prefix(3))
            
            return shortenedMonthName
        }
        
        func getYear(fromDate: Date) -> String
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy"
            return dateFormatter.string(from: fromDate)
        }
        
        output = ChartData(label: "\(getMonth(fromDate: startDate))\n\(getYear(fromDate: startDate))", value: Double(sum))
         
        return output
    }
    
    let appManager = AppManager.sharedInstance
    
    var body: some View
    {
        Text("Energy Consumption Chart")
            .font(.largeTitle)
            .fontWeight(.bold)
            .padding()
        
        chart
        
        Text("Return to main page")
            .onTapGesture { appManager.currentPage = .MainPage
                
            }
            .padding()
            .background(Color.gray)
            .foregroundColor(Color.white)
            .cornerRadius(10)
            .padding()
    }
    
    var chart: some View
    {
        
        HStack
        {
            
            Text("kWh")
           
            ForEach(1...6, id: \.self)
            {i in
                
                let chartData: ChartData = getChartData(monthsAgo: 6 - i)
                
                VStack
                {
                    Spacer()
                    
                    
                    Text(String(Double(roundf(Float(chartData.value))).removeZerosFromEnd()))
                    
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.blue)
                        .frame(maxHeight: chartData.value * 0.3)
                        .padding(3)
                    Text(chartData.label)
                        .multilineTextAlignment(.center)
                }
                    
            }
            
            
        }.padding()
            .background(Color.init(red: 0.95, green: 0.95, blue: 0.95))
        
    }
    
    
}


