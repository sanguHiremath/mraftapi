//
//  ApiServiceCall.swift
//  ApiServices
//
//  Created by Sangamesh on 14/06/23.
//

import Foundation

public protocol ServiceRunnable {
    func getApiData<T:Decodable>(requestUrl: URL, resultType: T.Type, completionHandler:@escaping(_ result: T)-> Void)
    
    func postApiData<T:Decodable>(requestUrl: URL, requestBody: [String:AnyHashable], resultType: T.Type, completionHandler:@escaping(_ result: T)-> Void)
    

}

public class ApiServiceCall: ServiceRunnable {
    
    public init(){}
    
    public func getApiData<T:Decodable>(requestUrl: URL, resultType: T.Type, completionHandler:@escaping(_ result: T)-> Void)
      {
          URLSession.shared.dataTask(with: requestUrl) { (responseData, httpUrlResponse, error) in
              if(error == nil && responseData != nil && responseData?.count != 0)
              {
        
                  let decoder = JSONDecoder()
                  do {
                      let result = try decoder.decode(T.self, from: responseData!)
                      _=completionHandler(result)
                  }
                  catch let error{
                      debugPrint("error occured while decoding = \(error.localizedDescription)")
                  }
              }

          }.resume()
      }
    
    
    public func postApiData<T:Decodable>(requestUrl: URL, requestBody: [String:AnyHashable], resultType: T.Type, completionHandler:@escaping(_ result: T)-> Void)
    {
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "content-type")
        
        urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: requestBody, options: .fragmentsAllowed)

        URLSession.shared.dataTask(with: urlRequest) { (data, httpUrlResponse, error) in

            if(data != nil && data?.count != 0)
            {
                do {

                    let response = try JSONDecoder().decode(T.self, from: data!)
                    _=completionHandler(response)
                }
                catch let decodingError {
                    debugPrint(decodingError)
                }
            }
        }.resume()
    }
}



