//
//  AuthProvider.swift
//  Chat App For HCI
//
//  Created by Sudeep Raj on 6/24/18.
//  Copyright © 2018 Sudeep Raj. All rights reserved.
//

import Foundation
import FirebaseAuth

typealias LoginHandler = (_ msg: String?) -> Void;

struct LoginErrorCode {
    static let WRONG_PASSWORD = "WRONG_PASSWORD";
    static let INVALID_EMAIL = "INVALID_EMAIL";
    static let USER_NOT_FOUND = "USER_NOT_FOUND";
    static let EMAIL_ALREADY_IN_USE = "EMAIL_ALREADY_IN_USE";
    static let WEAK_PASSWORD = "WEAK_PASSWORD";
    static let PROBLEM_CONNECTING = "PROBLEM_CONNECTING";
}

class AuthProvider {
    private static let _instance = AuthProvider();
    
    static var Instance: AuthProvider {
        return _instance;
    }
    var userName = "";
    
    func login(withUsername: String, password: String, loginHandler: LoginHandler?) {
        Auth.auth().signIn(withEmail: withUsername, password: password, completion: {(user, error) in
            if error != nil {
                self.handleErrors(err: error as! NSError, loginHandler: loginHandler);
            } else {
                loginHandler?(nil);
            }
            
        });
    } //login func
    
    func signUp(withUsername: String, password: String, loginHandler: LoginHandler?){
        
        Auth.auth().createUser(withEmail: withUsername, password: password, completion: { (user, error) in
            if error != nil {
                self.handleErrors(err: error as! NSError, loginHandler: loginHandler);
            } else {
                if user?.user.uid != nil {
                    // store the user to database
                    DBProvider.Instance.saveUser(withID: user!.user.uid, email: withUsername, password: password);
                    // login the user
                    self.login(withUsername: withUsername, password: password, loginHandler: loginHandler);
                }
            }
        })
        
    } //signup func
    
    func isLoggedIn() -> Bool {
        if Auth.auth().currentUser != nil {
            return true;
        }
        return false;
    }
    
    func logOut() -> Bool {
        if Auth.auth().currentUser != nil {
            do{
                try Auth.auth().signOut();
                return true;
            } catch{
                return false;
            }
        }
        return true;
    }
    
    func userID() -> String {
        return Auth.auth().currentUser!.uid;
    }
    
    private func handleErrors(err: NSError, loginHandler: LoginHandler?) {
        
        if let errCode = AuthErrorCode(rawValue: err.code) {
            
            switch errCode {
            
            case .wrongPassword:
                loginHandler?(LoginErrorCode.WRONG_PASSWORD);
                break;
            case .invalidEmail:
                loginHandler?(LoginErrorCode.INVALID_EMAIL);
                break;
            case .userNotFound:
                loginHandler?(LoginErrorCode.USER_NOT_FOUND);
                break;
            case .emailAlreadyInUse:
                loginHandler?(LoginErrorCode.EMAIL_ALREADY_IN_USE);
                break;
            case .weakPassword:
                loginHandler?(LoginErrorCode.WEAK_PASSWORD);
                break;
//            default:
//                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
//                break;
                
            //OTHER CASES:
                

            case .invalidCustomToken:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                print("1 HELLOOOOOOO " )
                break;
            case .customTokenMismatch:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                print("2 HELLOOOOOOO " )
                break;
            case .invalidCredential:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                print("3 HELLOOOOOOO " )
                break;
            case .userDisabled:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                print("4 HELLOOOOOOO " )
                break;
            case .operationNotAllowed:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                print("5 HELLOOOOOOO " )
                break;
            case .tooManyRequests:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                print("6 HELLOOOOOOO " )
                break;
            case .accountExistsWithDifferentCredential:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                print("7 HELLOOOOOOO " )
                break;
            case .requiresRecentLogin:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                print("8 HELLOOOOOOO " )
                break;
            case .providerAlreadyLinked:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                print("9 HELLOOOOOOO " )
                break;
            case .noSuchProvider:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                print("10 HELLOOOOOOO " )
                break;
            case .invalidUserToken:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                print("11 HELLOOOOOOO " )
                break;
            case .networkError:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                print("12 HELLOOOOOOO " )
                break;
            case .userTokenExpired:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                print("13 HELLOOOOOOO " )
                break;
            case .invalidAPIKey:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                print("14 HELLOOOOOOO " )
                break;
            case .userMismatch:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                print("15 HELLOOOOOOO " )
                break;
            case .credentialAlreadyInUse:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                print("16 HELLOOOOOOO " )
                break;
            case .appNotAuthorized:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                print("17 HELLOOOOOOO " )
                break;
            case .expiredActionCode:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                print("18 HELLOOOOOOO " )
                break;
            case .invalidActionCode:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                print("19 HELLOOOOOOO " )
                break;
            case .invalidMessagePayload:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                print("20 HELLOOOOOOO " )
                break;
            case .invalidSender:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                print("21 HELLOOOOOOO " )
                break;
            case .invalidRecipientEmail:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                print("22 HELLOOOOOOO " )
                break;
            case .missingEmail:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                print("23 HELLOOOOOOO " )
                break;
            case .missingIosBundleID:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                print("24 HELLOOOOOOO " )
                break;
            case .missingAndroidPackageName:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                print("25 HELLOOOOOOO " )
                break;
            case .unauthorizedDomain:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                print("26 HELLOOOOOOO " )
                break;
            case .invalidContinueURI:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                break;
            case .missingContinueURI:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                break;
            case .missingPhoneNumber:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                break;
            case .invalidPhoneNumber:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                break;
            case .missingVerificationCode:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                break;
            case .invalidVerificationCode:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                break;
            case .missingVerificationID:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                break;
            case .invalidVerificationID:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                break;
            case .missingAppCredential:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                break;
            case .invalidAppCredential:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                break;
            case .sessionExpired:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                break;
            case .quotaExceeded:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                break;
            case .missingAppToken:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                break;
            case .notificationNotForwarded:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                break;
            case .appNotVerified:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                break;
            case .captchaCheckFailed:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                break;
            case .webContextAlreadyPresented:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                break;
            case .webContextCancelled:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                break;
            case .appVerificationUserInteractionFailure:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                break;
            case .invalidClientID:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                break;
            case .webNetworkRequestFailed:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                break;
            case .webInternalError:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                break;
            case .nullUser:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                break;
            case .keychainError:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                break;
            case .internalError:
                loginHandler?(LoginErrorCode.PROBLEM_CONNECTING);
                break;
            }
        }
        
    }
    
} // class
