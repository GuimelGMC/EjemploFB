//
//  ViewController.swift
//  Facebook
//
//  Created by Guimel on 01/03/16.
//  Copyright © 2016 GuimelGMC. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class ViewController: UIViewController,FBSDKLoginButtonDelegate{
    
    @IBOutlet weak var btnLoginFB: FBSDKLoginButton!
    @IBOutlet weak var nombre: UILabel!
    @IBOutlet weak var email: UILabel!

    private var _fbLoginManager: FBSDKLoginManager?
    private var _fbGraphRequest: FBSDKGraphRequest?
    let permisos = ["public_profile", "email"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnLoginFB.addTarget(self, action: "hacerLoginFB", forControlEvents: UIControlEvents.TouchUpInside)
        btnLoginFB.delegate = self
        btnLoginFB.readPermissions = permisos
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: FBSDKLoginButtonDelegate
    
    func hacerLoginFB(){
        
    
        _fbLoginManager?.logInWithReadPermissions(permisos, fromViewController: self, handler: { (result : FBSDKLoginManagerLoginResult!, error : NSError!) -> Void in
            
            if(error != nil){
                NSLog("Error al iniciar sesion: \(error.description)")
            }else if (result.isCancelled){
                NSLog("Cancelado")
            }else{
                
                NSLog("\(result)")
            }
        })
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        NSLog("\(result)")
        if (FBSDKAccessToken.currentAccessToken() != nil){
            self.obtenerInfoUsuario()
        }
    }
    func loginButtonWillLogin(loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        _fbLoginManager?.logOut()
        
    }

    func obtenerInfoUsuario(){
        _fbGraphRequest = FBSDKGraphRequest.init(graphPath: "me", parameters: ["fields" : "picture.type(large),mail,name"], HTTPMethod: "GET")
        
        _fbGraphRequest?.startWithCompletionHandler({ (conn : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
            if (error == nil){
                let dic = result as! Dictionary<String,AnyObject>
                self.nombre.text = dic["name"] as? String
//                self.nombre.text = result.objectForKey("name")
            }else{
                NSLog("\(error.localizedDescription) || \(error.localizedFailureReason)")
            }
        })
        
//        _fbGraphRequest?.init(graphPath: "me", parameters: ["fields" : "picture.type(large),mail,name"], HTTPMethod: "GET").startWithCompletionHandler({ (connection : FBSDKGraphRequestConnection!, resultado, error : NSError!) -> Void in
//            
//            if (error == nil){
//                let dic = resultado as! Dictionary<String,AnyObject>
//                self.nombre.text = dic["name"] as? String
//            }
//        })
    }
}

