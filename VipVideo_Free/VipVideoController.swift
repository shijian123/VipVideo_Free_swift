//
//  VipVideoController.swift
//  VipVideo_Free
//
//  Created by zcy on 2018/4/20.
//  Copyright © 2018年 CY. All rights reserved.
//

import UIKit
import WebKit

class VipVideoController: UIViewController {
    var urlItem: VipUrlItem! = nil
    var currentWebUrl: String?
    
    private lazy var progressView: UIProgressView = {
        let progressV = UIProgressView()
        progressV.frame = CGRect(x: 0, y: 80, width: self.view.bounds.width, height: 1)
        progressV.trackTintColor = .white
        progressV.progressTintColor = .purple
        progressV.progress = 0.0
        return progressV
    }()
    
    private lazy var myWebView: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.preferences.javaScriptEnabled = true
        let webView = WKWebView(frame: self.view.bounds, configuration: configuration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.tag = 100
        webView.backgroundColor = .white
        webView.load(URLRequest(url: URL(string: urlItem.url)!))
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = UIRectEdge.all
        title = urlItem.title
        
        view.addSubview(self.myWebView)
        view.addSubview(self.progressView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(VipVideoController.vipVideoCurrentApiDidChange(noti:)), name: NSNotification.Name(rawValue: CYVipVideoDidChangeCurrentApi), object: nil)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "VIP", style: .plain, target: self, action: #selector(selectVipAction))
    }

    //MARK: - custom Method
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            if let progressNum = change?[NSKeyValueChangeKey.newKey] {
                self.progressView.progress = Float((progressNum as! Double))
                if self.progressView.progress >= 1.0 {
                    self.progressView.isHidden = true
                    self.myWebView.frame = self.view.bounds
                }
            }
            
        }else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    /// vip类型选择后接受通知进行改变
    @objc func vipVideoCurrentApiDidChange(noti: Notification) -> Void {

        //获取当前的url并拼接上为免vip
        self.myWebView.evaluateJavaScript("document.location.href") { (url, error) in
            let urlStr = url as! String
            let originUrl =  urlStr.components(separatedBy: "url=").last
            if !urlStr.hasPrefix("http") {
                return
            }

            let finalUrl: String = VipURLManager.sharedInstance.currentVipApi + originUrl!

            print("finalUrl = %@",finalUrl)
            UIPasteboard.general.string = finalUrl
            let request = URLRequest(url: URL(string: finalUrl)!)
            self.myWebView.load(request)
        }
    }
    
    /// 跳入到vip类型选择页
    @objc func selectVipAction() -> Void {
        self.navigationController?.pushViewController(SelectVipStyleController(), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension VipVideoController: WKUIDelegate, WKNavigationDelegate {
    
        func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            let requestUrl: String = (navigationAction.request.url?.absoluteString)!
            
            //如果是跳转一个新页面
            if navigationAction.targetFrame == nil {
                webView.load(navigationAction.request)
            }
            //拦截广告
            if strlen(navigationAction.request.url?.absoluteString ?? "") > 0 {
                if  (requestUrl.contains("ynjczy.net")) ||
                    (requestUrl.contains("ylbdtg.com")) ||
                    (requestUrl.contains("662820.com")) ||
                    (requestUrl.contains("api.vparse.org")) ||
                    (requestUrl.contains("hyysvip.duapp.com")) ||
                    (requestUrl.contains("f.qcwzx.net.cn"))
                    {
                    decisionHandler(.cancel)
                    return
                }
                print("request.URL.absoluteString = ",requestUrl)

            }
    //        decisionHandler(.allow)
            //封印腾讯的Universal Links
            decisionHandler(WKNavigationActionPolicy(rawValue: 3)!)
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webView.evaluateJavaScript("document.location.href") { (urlStr, error) in
                let urlStr1 = urlStr as! String
            print("KKKKK=",urlStr1)
            }
        }
}
