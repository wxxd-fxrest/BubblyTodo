//
//  MainViewController.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/27/24.
//

import UIKit

class MainViewController: UIViewController {
    private var todoTopView = TodoTopView() // 타이핑 오류 수정: "TodoTobView" -> "TodoTabView"
    private var mainTabViewController: MainTabViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupMainTabViewController()
    }

    private func setupUI() {
        // TodoTabView 설정
        view.addSubview(todoTopView)
        todoTopView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            todoTopView.topAnchor.constraint(equalTo: view.topAnchor),
            todoTopView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            todoTopView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            todoTopView.heightAnchor.constraint(equalToConstant: 100) // 원하는 높이 설정
        ])
    }

    private func setupMainTabViewController() {
        mainTabViewController = MainTabViewController()
        
        // MainTabViewController를 자식으로 추가
        addChild(mainTabViewController)
        view.addSubview(mainTabViewController.view)
        mainTabViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainTabViewController.view.topAnchor.constraint(equalTo: todoTopView.bottomAnchor),
            mainTabViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mainTabViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mainTabViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        mainTabViewController.didMove(toParent: self)
    }
}
