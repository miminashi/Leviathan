//
//  TimelineViewController.swift
//  Leviathan
//
//  Created by Thomas Bonk on 17.04.17.
//
//

import UIKit
import RxCocoa
import RxSwift
import Toucan

// MARK: - Key Paths
fileprivate extension String {
    static let activeAccount = "activeAccount"
}

class TimelineViewController: UITableViewController {
    
    // MARK: - Private Properties
    @IBOutlet weak var accountButton: UIButton?
    private let settings = Globals.injectionContainer.resolve(Settings.self)
    private let disposeBag = DisposeBag()

    // MARK: - Public Properties
    @IBInspectable var timelineId = Timeline.Home
    
    
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
    @IBAction fileprivate func showAccountMenu(sender: UIButton) {
        
        let width = self.view.frame.width * 0.8
        let accountMenu = AccountMenu(width: width)
        
        guard let button = self.accountButton else {
            return
        }
        
        accountMenu.show(fromView: button)
    }

    fileprivate func setAvatarImage(for account: Account?) {
        
        guard let account = account else {
            self.accountButton?.setImage(Asset.icAccount.image, for: .normal)
            return
        }

        guard let avatarData = account.avatarData else {
            return
        }
        
        guard let image =  UIImage(data: avatarData) else {
            return
        }
        
        accountButton?.setImage(
            Toucan(image: image)
                .maskWithEllipse()
                .resize(CGSize(width: 36, height: 36))
                .image,
            for: .normal
        )
    }
}
