enum SettingsTableViewControllerSegueIdentifier: String {
    case PrivacyPolicy = "ShowWebViewController"
    case Acknowledgements = "ShowTextViewController"
}

class SettingsTableViewController: UITableViewController {
    private let settingsController = TRSettingsController()
    
    // MARK: UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsController.unitSystemChanged.subscribeNext { unitSystem in
            if let system = TRUnitSystem(rawValue: unitSystem as! Int) {
                self.tableView.checkCellAtIndexPath(self.indexPathForUnitSystem(system))
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.checkCellAtIndexPath(indexPathForUnitSystem(settingsController.unitSystem))
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = SettingsTableViewControllerSegueIdentifier(rawValue: segue.identifier ?? "") {
            switch identifier {
            case .PrivacyPolicy:
                let webViewController = segue.destinationViewController as? WebViewController
                webViewController?.URL = NSURL(string: "http://www.troposweather.com/privacy/")!
            case .Acknowledgements:
                let textViewController = segue.destinationViewController as? TextViewController
                let fileURL = NSBundle.mainBundle().URLForResource("Acknowledgements", withExtension: "plist")
                let parser = fileURL.flatMap { AcknowledgementsParser(fileURL: $0) }
                textViewController?.text = parser?.displayString()
            }
        }
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            tableView.uncheckCellsInSection(indexPath.section)
            selectUnitSystemAtIndexPath(indexPath)
        default: break
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel.font = .defaultLightFontOfSize(15)
            headerView.textLabel.textColor = .lightTextColor()
        }
    }
    
    // MARK: Private
    
    private func selectUnitSystemAtIndexPath(indexPath: NSIndexPath) {
        if let system = TRUnitSystem(rawValue: indexPath.row) {
            settingsController.unitSystem = system
        }
    }
    
    private func indexPathForUnitSystem(unitSystem: TRUnitSystem) -> NSIndexPath {
        return NSIndexPath(forRow: unitSystem.rawValue, inSection: 0)
    }
}

extension UITableView {
    func checkCellAtIndexPath(indexPath: NSIndexPath) {
        cellForRowAtIndexPath(indexPath)?.accessoryType = .Checkmark
    }
    
    func uncheckCellsInSection(section: Int) {
        for index in 0 ..< numberOfRowsInSection(section) {
            let indexPath = NSIndexPath(forRow: index, inSection: section)
            cellForRowAtIndexPath(indexPath)?.accessoryType = .None
        }
    }
}