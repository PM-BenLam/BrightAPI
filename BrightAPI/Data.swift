import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

struct ParseData
{
    func parse (rawJSON: String) -> JSON
    {
        
        guard let rawData = rawJSON.data(using: .utf8) else {return "error"}
        
        guard let output = try? JSON(data: rawData) else {return "error"}
        
        return output
    }
}


struct GetData
{
    let appManager = AppManager.sharedInstance
    
    func generateAuthToken (username: String, password: String) 
    {
        var output: String = " "
        let semaphore = DispatchSemaphore (value: 0)

        let parameters = "{   \n    \"username\": \"\(username)\",\n    \"password\":\"\(password)\" \n    \n}"
        let postData = parameters.data(using: .utf8)

        var request = URLRequest(url: URL(string: "https://api.glowmarkt.com/api/v0-1/auth")!,timeoutInterval: Double.infinity)
        request.addValue("b0f1b774-a586-4f72-9edd-27ead8aa7a8d", forHTTPHeaderField: "applicationId")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
            }
            output = String(data: data, encoding: .utf8)!
            semaphore.signal()
        }

        task.resume()
        semaphore.wait()
        
        if ParseData().parse(rawJSON: output)["valid"].boolValue == true
        {
            appManager.authToken = ParseData().parse(rawJSON: output)["token"].stringValue
        
        }
        
    }
    
    func generateResourceId (token: String)
    {
        var output = ""
        let semaphore = DispatchSemaphore (value: 0)

        var request = URLRequest(url: URL(string: "https://api.glowmarkt.com/api/v0-1/virtualentity")!,timeoutInterval: Double.infinity)
        request.addValue("b0f1b774-a586-4f72-9edd-27ead8aa7a8d", forHTTPHeaderField: "applicationId")
        request.addValue("\(token)", forHTTPHeaderField: "token")

        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
          output = String(data: data, encoding: .utf8)!
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()

        if let JSON = ParseData().parse(rawJSON: output).array
        {
            appManager.resourceId = JSON[0]["resources"].arrayValue[0]["resourceId"].stringValue
        }
    }
    
    func current () -> JSON
    {
        var output: String = ""
        let semaphore = DispatchSemaphore (value: 0)

        var request = URLRequest(url: URL(string: "https://api.glowmarkt.com/api/v0-1/resource/\(appManager.resourceId!)/current")!,timeoutInterval: Double.infinity)
        request.addValue("b0f1b774-a586-4f72-9edd-27ead8aa7a8d", forHTTPHeaderField: "applicationId")
        request.addValue("\(appManager.authToken!)", forHTTPHeaderField: "token")

        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
            }
            output = String(data: data, encoding: .utf8)!
            semaphore.signal()
        }

        task.resume()
        semaphore.wait()
        
        return ParseData().parse(rawJSON: output)
    }
    
    func specificDays (startDate: String, endDate: String) -> JSON
    {
        let semaphore = DispatchSemaphore (value: 0)

        var output:String = ""
        var request = URLRequest(url: URL(string: "https://api.glowmarkt.com/api/v0-1/resource/\(appManager.resourceId!)/readings?from=\(startDate)T00:00:00&to=\(endDate)T00:00:00&function=sum&period=P1D")!,timeoutInterval: Double.infinity)
        request.addValue("b0f1b774-a586-4f72-9edd-27ead8aa7a8d", forHTTPHeaderField: "applicationId")
        request.addValue("\(appManager.authToken!)", forHTTPHeaderField: "token")

        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
          output = String(data: data, encoding: .utf8)!
          semaphore.signal()
        }

        task.resume()
        semaphore.wait()
        
        return ParseData().parse(rawJSON: output)
    }

}

