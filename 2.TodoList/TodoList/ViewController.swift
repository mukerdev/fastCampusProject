//
//  ViewController.swift
//  TodoList
//
//  Created by Muker on 2022/06/28.
//

import UIKit

struct Task {
    var title: String
    var done: Bool
}

class ViewController: UIViewController {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var editButton: UIBarButtonItem!
    
    
    var doneButton: UIBarButtonItem?
    
    var tasks = [Task]() {
        didSet {
            self.saveTasks()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTap))
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.loadTasks()
    }
    
    @objc func doneButtonTap() {
        self.navigationItem.leftBarButtonItem = self.editButton
        self.tableView.setEditing(false, animated: true)
    }
    
    
    
    @IBAction func tapEditButton(_ sender: UIBarButtonItem) {
        guard !self.tasks.isEmpty else { return }
        self.navigationItem.leftBarButtonItem = self.doneButton
        self.tableView.setEditing(true, animated: true)
    }
    
    @IBAction func tapPlusButton(_ sender: UIBarButtonItem) {
        
        // 알람
        let alert = UIAlertController(title: "할 일 등록", message: nil, preferredStyle: .alert)
        
        // 등록 버튼
        
        let registerButton = UIAlertAction(title: "등록", style: .default) { [weak self] _ in
            // weak self는 클로저의 선언부에서 캡쳐목록을 정의해서 강한순환참조로 인해 메모리누수가 나는걸 해결해준다.
            guard let title = alert.textFields?[0].text else { return }
            // textFields를 옵셔널로 반환하기 때문에 guard let 을 사용해서 옵셔널 바인딩을 해준다.
            let task = Task(title: title, done: false)
            self?.tasks.append(task)
            self?.tableView.reloadData()
            
        }
        
        // 취소 버튼
        let cancelButton = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        
        // 알람에 액션버튼 등록
        alert.addAction(cancelButton)
        alert.addAction(registerButton)
        alert.addTextField(configurationHandler: { UITextField in
            UITextField.placeholder = "할 일을 입력해주세요."
        })
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func saveTasks() {
        let data = self.tasks.map {
            [
                "title": $0.title,
                "done": $0.done
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "tasks")
    }
    
    func loadTasks() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "tasks") as? [[String: Any]] else {return}
        self.tasks = data.compactMap {
            guard let title = $0["title"] as? String else {return nil}
            guard let done = $0["done"] as? Bool else {return nil}
            return Task(title: title, done: done)
        }
    }
    
}

extension ViewController: UITableViewDataSource {
    // 필수의 두가지 메소드 구현
    // numberOfRowsInSection, cellForRowAt
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let task = self.tasks[indexPath.row]
        cell.textLabel?.text = task.title
        if task.done {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    // 편집모드에서 삭제버튼을 눌렀을때 선택된 셀이 어떤 셀인지 알려주는 메소드
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        if self.tasks.isEmpty {
            self.doneButtonTap()
        }
    }
    
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var task = self.tasks[indexPath.row]
        task.done = !task.done
        self.tasks[indexPath.row] = task
        self.tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
