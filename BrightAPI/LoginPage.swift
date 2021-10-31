import Foundation
import SwiftUI

struct LoginPage: View
{
    let appManager = AppManager.sharedInstance
    @State var username: String = ""
    @State var password: String = ""
    @State var errorMessage: String = ""
    
    var body: some View
    {
       
        TextField("username", text: $username)
        TextField("password", text: $password)
        
        Text("Login")
        .onTapGesture
        {
        
            if username != "" && password != ""
            {
                GetData().generateAuthToken(username: username, password: password)
                
                if appManager.authToken != nil
                {
                    GetData().generateResourceId(token: appManager.authToken!)
                    
                    if appManager.resourceId != nil
                    {
                        appManager.currentPage = .MainPage
                        
                        
                    } else { errorMessage = "resource failure" }
                    
                } else { errorMessage = "authorization failure" }
                
            } else { errorMessage = "no password/username entered" }
            
            
           
        }
        
        Text(errorMessage)
        
    }
}
