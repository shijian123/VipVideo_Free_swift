//
//  VipVideoController.swift
//  VipVideo_Free
//
//  Created by zcy on 2018/4/20.
//  Copyright © 2018年 CY. All rights reserved.
//

import UIKit
import WebKit

class VipVideoController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    var urlItem: VipUrlItem! = nil
    var currentWebUrl: String = ""
    private var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = urlItem.title
        let configuration = WKWebViewConfiguration()
        configuration.preferences.javaScriptEnabled = true
        webView = WKWebView(frame: self.view.frame, configuration: configuration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.tag = 100
        webView.backgroundColor = UIColor.purple
        self.view.addSubview(webView)
        webView.load(URLRequest(url: URL(string: urlItem.url)!))
        
        NotificationCenter.default.addObserver(self, selector: #selector(VipVideoController.vipVideoCurrentApiDidChange(noti:)), name: NSNotification.Name(rawValue: CYVipVideoDidChangeCurrentApi), object: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "VIP", style: .plain, target: self, action: #selector(selectVipAction))
    }

    //MARK: - custom Method
    
    /// vip类型选择后接受通知进行改变
    @objc func vipVideoCurrentApiDidChange(noti: Notification) -> Void {

        //获取当前的url并拼接上为免vip
        webView.evaluateJavaScript("document.location.href") { (url, error) in
            let urlStr = url as! String
            let originUrl =  urlStr.components(separatedBy: "url=").last
            if !urlStr.hasPrefix("http") {
                return
            }

            let finalUrl: String = VipURLManager.sharedInstance.currentVipApi + originUrl!

            print("finalUrl = %@",finalUrl)
            UIPasteboard.general.string = finalUrl
            let request = URLRequest(url: URL(string: finalUrl)!)
            self.webView.load(request)
        }
        
    }
    
    /// 跳入到vip类型选择页
    @objc func selectVipAction() -> Void {
        
        self.navigationController?.pushViewController(SelectVipStyleController(), animated: true)

    }
    
    //MARK: - delegate
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let requestUrl: String = (navigationAction.request.url?.absoluteString)!
        
        //如果是跳转一个新页面
        if navigationAction.targetFrame == nil {
            webView.load(navigationAction.request)
        }
        //拦截广告
        if strlen(navigationAction.request.url?.absoluteString) > 0 {
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
