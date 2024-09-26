//
//  MainViewController.swift
//  BubblyToDo
//
//  Created by 밀가루 on 9/26/24.
//

import UIKit
import SnapKit

class MainTabViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    private var pageViewController: UIPageViewController!
    private var viewControllersList: [UIViewController] = []
    private var mainTabView = MainTabView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = MySpecialColors.WhiteColor
        setupViewControllers()
        setupNavigationUI()
        setupMainTabView()
        setupPageViewController()
        
        // NotificationCenter 구독
        NotificationCenter.default.addObserver(self, selector: #selector(tabTapped(_:)), name: NSNotification.Name("TabTapped"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupNavigationUI() {
        self.navigationItem.title = "Bubbly ToDo" // 원하는 타이틀 설정
        
        // 안전하게 옵셔널 바인딩
        if let navigationBar = self.navigationController?.navigationBar {
            navigationBar.titleTextAttributes = [
                NSAttributedString.Key.foregroundColor: MySpecialColors.MainColor
            ]
        }
        
        self.navigationItem.leftBarButtonItem = nil // 왼쪽 버튼(뒤로가기 버튼) 제거
    }
    
    private func setupViewControllers() {
        let firstVC = DiaryViewController()
        let secondVC = TodoViewController()
        let thirdVC = ProfileViewController()
        
        viewControllersList = [firstVC, secondVC, thirdVC]
    }
    
    private func setupPageViewController() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        // 두 번째 페이지로 초기화
        if let todoVC = viewControllersList[1] as? TodoViewController {
            pageViewController.setViewControllers([todoVC], direction: .forward, animated: false, completion: nil)
        }
        
        addChild(pageViewController)
        
        view.addSubview(pageViewController.view)
        
        pageViewController.view.snp.makeConstraints {
            $0.top.equalTo(mainTabView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview() // 하단에 맞추기
        }
        pageViewController.didMove(toParent: self)
    }
    
    private func setupMainTabView() {
        mainTabView = MainTabView()
        view.addSubview(mainTabView)
        
        let navigationBarHeight = navigationController?.navigationBar.frame.height ?? 44
        let statusBarHeight = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        let totalHeight = navigationBarHeight + statusBarHeight
        
        mainTabView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(totalHeight) // 네비게이션 바 아래에 위치
            $0.leading.trailing.equalToSuperview().inset(0)
            $0.height.equalTo(44) // 원하는 높이 설정
        }
    }
    
    @objc private func tabTapped(_ notification: Notification) {
        guard let tab = notification.object as? UIView,
              let index = mainTabView.subviews.firstIndex(of: tab) else { return }
        let direction: UIPageViewController.NavigationDirection = index > (pageViewController.viewControllers?.firstIndex(of: pageViewController.viewControllers!.first!) ?? 0) ? .forward : .reverse
        pageViewController.setViewControllers([viewControllersList[index]], direction: direction, animated: true, completion: nil)
        updateTabTextColors(selectedIndex: index)
    }
    
    private func updateTabTextColors(selectedIndex: Int) {
        // 모든 탭의 텍스트 색상을 초기화
        mainTabView.resetTabTextColors()

        // 선택된 탭의 텍스트 색상과 폰트를 변경
        updateTabTextColor(for: selectedIndex, isSelected: true)
    }

    private func updateTabTextColor(for index: Int, isSelected: Bool) {
        let textColor = isSelected ? MySpecialColors.MainColor : MySpecialColors.MainColor.withAlphaComponent(0.7)
        let font = isSelected ? UIFont.pretendard(style: .bold, size: 14, isScaled: true) : UIFont.pretendard(style: .semiBold, size: 14, isScaled: true)

        switch index {
        case 0:
            mainTabView.firstText.textColor = textColor
            mainTabView.firstText.font = font
        case 1:
            mainTabView.secondText.textColor = textColor
            mainTabView.secondText.font = font
        case 2:
            mainTabView.thirdText.textColor = textColor
            mainTabView.thirdText.font = font
        default:
            break
        }
    }
    
    // UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllersList.firstIndex(of: viewController), index > 0 else {
            return nil
        }
        return viewControllersList[index - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = viewControllersList.firstIndex(of: viewController), index < viewControllersList.count - 1 else {
            return nil
        }
        return viewControllersList[index + 1]
    }
    
    // UIPageViewControllerDelegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentVC = pageViewController.viewControllers?.first,
           let index = viewControllersList.firstIndex(of: currentVC) {
            updateTabTextColors(selectedIndex: index)
        }
    }
}
