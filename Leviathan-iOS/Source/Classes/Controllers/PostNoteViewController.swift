//
//  PostNoteViewController.swift
//  Leviathan
//
//  Created by Bonk, Thomas on 26.04.17.
//
//

import UIKit
import SwiftForms
import RxSwiftForms
import RxCocoa
import RxSwift
import Toucan

class PostNoteViewController: FormViewController {

    // MARK: - Private Properties
    
    @IBOutlet private var accountIndicatorButton: UIButton!
    private let settings = Globals.injectionContainer.resolve(Settings.self)
    private let disposeBag = DisposeBag()
    
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let settings = settings else {
            preconditionFailure()
        }
        
        setAvatarImage(for: settings.activeAccount)
        settings.accountSubject.subscribe { event in
            switch event {
            case .next(let account):
                self.setAvatarImage(for: account)
            default:
                break
            }
        }.addDisposableTo(disposeBag)
    }
    
    
    // MARK: - Action Handlers
    
    @IBAction fileprivate func cancel(sender: UIBarButtonItem) {
        
        self.dismiss(animated: true)
    }
    
    fileprivate func setAvatarImage(for account: Account?) {
        
        guard let account = account else {
            self.accountIndicatorButton?.setImage(Asset.icAccount.image, for: .normal)
            return
        }
        
        guard let avatarData = account.avatarData else {
            return
        }
        
        guard let image =  UIImage(data: avatarData) else {
            return
        }
        
        accountIndicatorButton?.setImage(
            Toucan(image: image)
                .maskWithEllipse()
                .resize(CGSize(width: 24, height: 24))
                .image,
            for: .normal
        )
    }
}
