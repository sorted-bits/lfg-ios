//
//  ActivityViewController.swift
//  lfg
//
//  Created by Wim Haanstra on 09/02/2017.
//  Copyright © 2017 Wim Haanstra. All rights reserved.
//

import UIKit
import ActionCableClient
import RealmSwift
import JKNotificationPanel
import PureLayout

class ActivityViewController: UIViewController {

    var activity: Activity!
    var cableChannel: Channel?

	let panel = JKNotificationPanel()

	let tableView = UITableView()

    init(activity: Activity) {
        super.init(nibName: nil, bundle: nil)
        self.activity = activity
		self.panel.timeUntilDismiss = 5
		self.title = activity.name

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

		self.view.addSubview(self.tableView)
		self.tableView.autoPinEdgesToSuperviewEdges()

		setupRealtimeConnection()

        let api = API()
        api.configuration(activity: self.activity) { (success) in
            if success {
                self.refreshFilters()
            }
        }

		let settingsButton = UIBarButtonItem(title: "E", style: .plain, target: self, action: #selector(self.showSettings(sender:)))

		let attributes = [NSFontAttributeName: UIFont.fontAwesome(ofSize: 20)] as [String: Any]
		settingsButton.setTitleTextAttributes(attributes, for: .normal)

		settingsButton.title = String.fontAwesomeIcon(name: .search)

		self.navigationItem.rightBarButtonItem = settingsButton
    }

	override func viewWillAppear(_ animated: Bool) {
		setupRealtimeConnection()
	}

    override func viewWillDisappear(_ animated: Bool) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func refreshFilters() {

    }

	private func setupRealtimeConnection() {
		if activity.subscribe {
			SocketConnection.sharedInstance.openChannel(channelName: self.activity.permalink, subscribed: { (channel) in
				channel.onReceive = { (JSON: Any?, error: Error?) in
					log.debug("\(JSON)")
				}
			})
		} else {
			SocketConnection.sharedInstance.closeChannel()
		}
	}

	@objc private func showSettings(sender: Any) {
		let nav = UINavigationController(rootViewController: ActivityViewSettingsController(activity: self.activity))
		self.present(nav, animated: true) {
		}
	}

	deinit {
		log.verbose("dinit")
		SocketConnection.sharedInstance.closeChannel()
	}

}