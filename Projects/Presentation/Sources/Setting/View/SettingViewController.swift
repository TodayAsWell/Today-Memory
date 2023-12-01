import UIKit
import SnapKit

// ViewController (View)
class SettingViewController: UIViewController, SettingViewInterface {
    var presenter: SettingPresenterInterface!
    
    private var tableView = UITableView()
    private let sectionHeader = ["일반", "기타"]
    private let cellDataSource = [["어쩌고저쩌고", "어쩌고저쩌고", "어쩌고저쩌고"], ["정보", "어쩌고저쩌고"]]

    override func viewDidLoad() {
        super.viewDidLoad()
//        presenter.viewDidLoad()
        setupNavigationItem()
        setupTableView()
    }

    func setupNavigationItem() {
        title = "보안 기능 설명"
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = .white
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        } else {
            navigationController?.navigationBar.barTintColor = .white
        }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SettingCell")
        view.addSubview(tableView)
        
        setupConstraints()
        
        tableView.backgroundColor = .F6F6F8
        
        tableView.rowHeight = 60.0
    }

    func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeader.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()

        let label = UILabel()
        label.text = sectionHeader[section]
        label.font = UIFont.systemFont(ofSize: 20, weight: .thin)
        label.textColor = .black

        headerView.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellDataSource[section].count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)

        if indexPath.section == 0 {
            let switchView = UISwitch()
            switchView.onTintColor = .BAA7E7
            cell.accessoryView = switchView
        } else if indexPath.section == 1 {
            cell.accessoryType = .disclosureIndicator
        }

        cell.textLabel?.text = cellDataSource[indexPath.section][indexPath.row]

        return cell
    }
}
