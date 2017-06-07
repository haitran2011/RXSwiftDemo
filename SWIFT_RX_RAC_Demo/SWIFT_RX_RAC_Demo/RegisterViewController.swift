//
//  RegisterViewController.swift
//  SWIFT_RX_RAC_Demo
//    -----------------------分割线来袭-----------------------
//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                           O\  =  /O
//                        ____/`---'\____
//                      .'  \\|     |//  `.
//                     /  \\|||  :  |||//  \
//                    /  _||||| -:- |||||-  \
//                    |   | \\\  -  /// |   |
//                    | \_|  ''\---/''  |   |
//                    \  .-\__  `-`  ___/-. /
//                   ___`. .'  /--.--\  `. . __
//                ."" '<  `.___\_<|>_/___.'  >'"".
//              | | :  `- \`.;`\ _ /`;.`/ - ` : | |
//              \  \ `-.   \_ __\ /__ _/   .-` /  /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//         ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
//                  佛祖镇楼                  BUG辟易
//          佛曰:
//                  写字楼里写字间，写字间里程序员；
//                  程序人员写程序，又拿程序换酒钱。
//                  酒醒只在网上坐，酒醉还来网下眠；
//                  酒醉酒醒日复日，网上网下年复年。
//                  但愿老死电脑间，不愿鞠躬老板前；
//                  奔驰宝马贵者趣，公交自行程序员。
//                  别人笑我忒疯癫，我笑自己命太贱；
//                  不见满街漂亮妹，哪个归得程序员？
//    -----------------------分割线来袭-----------------------
//
//  Created by chenyihang on 2017/6/6.
//  Copyright © 2017年 chenyihang. All rights reserved.
//

import UIKit
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif



extension String{
    
    var trim: String {
        let whitespace = NSCharacterSet.whitespacesAndNewlines
        var tempArray = self.components(separatedBy: whitespace)
        tempArray = tempArray.filter{
            $0 != ""
        }
        return tempArray.joined()
    }

    
}

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var repeatPasswordLabel: UILabel!
    
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginButton: UIBarButtonItem!
    
    
    let disposeBag = DisposeBag()
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let viewModel = RegisterViewModel()
        //原来那个方法是给 TF设定绑定事件 
        
        //将TF的文本观察者绑定到VM的username上
        usernameTextField.rx.text.orEmpty
            .bind(to: viewModel.username)
            .addDisposableTo(disposeBag)
        
        usernameTextField.rx.text.orEmpty.subscribe { (text) in
            print(text.element!.trim.characters.count)
            print(text.element!.characters.count)
        }.addDisposableTo(disposeBag)
        
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.password)
            .addDisposableTo(disposeBag)
        
        repeatPasswordTextField.rx.text.orEmpty
            .bind(to: viewModel.repeartPassword)
            .addDisposableTo(disposeBag)
        
        registerButton.rx.tap
            .bind(to:viewModel.registerTaps)
            .addDisposableTo(disposeBag)
        
        
        viewModel.usernameUsable
            .bind(to: usernameLabel.rx.validationResult)
            .addDisposableTo(disposeBag)
        
        viewModel.usernameUsable
            .bind(to: passwordTextField.rx.inputEnabled)
            .addDisposableTo(disposeBag)
        
        viewModel.passwordUsable
            .bind(to: passwordLabel.rx.validationResult)
            .addDisposableTo(disposeBag)
        viewModel.passwordUsable
            .bind(to: repeatPasswordTextField.rx.inputEnabled)
            .addDisposableTo(disposeBag)
        
        viewModel.repeatPasswordUsable
            .bind(to: repeatPasswordLabel.rx.validationResult)
            .addDisposableTo(disposeBag)
        
        
        
        viewModel.registerButtonEnabled
            .subscribe(onNext:{[unowned self] valid in
                self.registerButton.isEnabled = valid
                self.registerButton.alpha = valid ? 1.0 : 0.5
            })
            .addDisposableTo(disposeBag)
                
        viewModel.registerResult
            .subscribe(onNext:{[unowned self] result in
                switch result{
                case let .ok(message):
                    self.showAlert(message: message)
                case .empty:
                    self.showAlert(message: "")
                case let .failed(message):
                    self.showAlert(message: message)
                    
                }
            })
            .addDisposableTo(disposeBag)
        
        
        viewModel.registerResult
            .bind(to: loginButton.rx.tapEnabled)
            .addDisposableTo(disposeBag)
        

        // Do any additional setup after loading the view.
    }

    
    open func showAlert(message: String) {
        let action = UIAlertAction(title: "确定", style: .default, handler: nil)
        let alertViewController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alertViewController.addAction(action)
        present(alertViewController, animated: true, completion: nil)
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