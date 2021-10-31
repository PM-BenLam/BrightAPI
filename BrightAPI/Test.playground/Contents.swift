import Foundation

var output = ""
var semaphore = DispatchSemaphore (value: 0)

var request = URLRequest(url: URL(string: "https://api.glowmarkt.com/api/v0-1/virtualentity")!,timeoutInterval: Double.infinity)
request.addValue("b0f1b774-a586-4f72-9edd-27ead8aa7a8d", forHTTPHeaderField: "applicationId")
request.addValue("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0b2tlbkhhc2giOiI2MjkzYWM0MGFmYTZlNzUzMDg3ZTIzN2JhOGEwMTgzYWQ2MmM5OTY2ZDRmYzk3NDQwNTRjNTVjM2Y5YjAzZWQ0MGI1OGM4MjFiOWZkNDg1YmU1ZGZiNTRiYjBhODVkM2QiLCJ2ZXJzaW9uIjoiMS4xIiwiaWF0IjoxNjM0OTg3ODM4LCJleHAiOjE2MzU1OTI2Mzh9.3yGf6C4NfxXOSqxWLjPdtoKhueUiOzCLT5hB_wxzC5Q", forHTTPHeaderField: "token")

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
    print(JSON[0]["resources"].arrayValue[0]["resourceId"].stringValue)
}


