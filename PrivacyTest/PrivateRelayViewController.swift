//
//  ViewController.swift
//  PrivacyTest
//
//  Created by zhgchgli on 2021/8/12.
//

import WebKit
import UIKit

struct RequestHeader: Codable {
    private enum CodingKeys: String, CodingKey {
        case userAgent = "user-agent"
        case ip = "x-appengine-user-ip"
    }
    let userAgent: String
    let ip: String
}

class PrivateRelayViewController: UIViewController {

    @IBOutlet weak var loadHttpRequestButton: UIButton!
    @IBOutlet weak var loadHttpsRequestButton: UIButton!
    @IBOutlet weak var loadInWkWebViewButton: UIButton!
    @IBOutlet weak var resultTextView: UITextView!
    @IBOutlet weak var wkWebView: WKWebView!
    @IBOutlet weak var metricsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadHttpRequestButton.addTarget(self, action: #selector(loadHttpRequest), for: .touchUpInside)
        loadHttpsRequestButton.addTarget(self, action: #selector(loadHttpsRequest), for: .touchUpInside)
        loadInWkWebViewButton.addTarget(self, action: #selector(loadInWkWebView), for: .touchUpInside)
        
    }

    @objc private func loadHttpRequest(_ sender: Any) {
        let request = URLRequest(url: URL(string: "http://us-central1-pinkoi-android.cloudfunctions.net/IPDetector")!)
        self.resultTextView.text = "Loading http..."
        self.metricsTextView.text = "Loading http..."
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.resultTextView.text = "Error: \(error)"
                    return
                }
                
                if let data = data,
                   let requestHeader = try? JSONDecoder().decode(RequestHeader.self, from: data) {
                    self.resultTextView.text = "Result: \(requestHeader))"
                } else {
                    self.resultTextView.text = "DecodeError!"
                }
                
            }
        }
        dataTask.delegate = self
        dataTask.resume()
        
        self.wkWebView.isHidden = true
        self.resultTextView.isHidden = false
        self.metricsTextView.isHidden = false
    }
    
    @objc private func loadHttpsRequest(_ sender: Any) {
        let request = URLRequest(url: URL(string: "https://us-central1-pinkoi-android.cloudfunctions.net/IPDetector")!)
        self.resultTextView.text = "Loading https..."
        self.metricsTextView.text = "Loading https..."
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    self.resultTextView.text = "Error: \(error)"
                    return
                }
                
                if let data = data,
                   let requestHeader = try? JSONDecoder().decode(RequestHeader.self, from: data) {
                    self.resultTextView.text = "Result: \(requestHeader))"
                } else {
                    self.resultTextView.text = "DecodeError!"
                }
                
            }
        }
        dataTask.delegate = self
        dataTask.resume()
        
        self.wkWebView.isHidden = true
        self.resultTextView.isHidden = false
        self.metricsTextView.isHidden = false
    }
    
    @objc private func loadInWkWebView(_ sender: Any) {
        let request = URLRequest(url: URL(string: "http://us-central1-pinkoi-android.cloudfunctions.net/IPDetector")!)
        self.wkWebView.load(request)
        self.wkWebView.isHidden = false
        self.resultTextView.isHidden = true
        self.metricsTextView.isHidden = true
    }
}

extension PrivateRelayViewController: URLSessionTaskDelegate {
    func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        DispatchQueue.main.async {
            self.metricsTextView.text += metrics.description
        }
        print(metrics)
    }
}
