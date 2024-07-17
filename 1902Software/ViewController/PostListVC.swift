//
//  PostListVC.swift
//  1902Software
//
//  Created by Aldrei Glenn Nuqui on 7/4/24.
//

import UIKit

protocol PostListVCDelegate: AnyObject {
    func refreshPostList()
    func closeMenu()
}

class PostListVC: UIViewController, PostListVCDelegate {

    let userService = UserService()
    
    var posts: [PostModel] = []
    var username = String()

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        getPostLists()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        getPostLists()
//    }
    
    func refreshPostList() {
        getPostLists()
    }
    
    func getPostLists() {
        
        DispatchQueue.main.async {
            self.showLoadingView()
        }
        
        userService.listAllPosts { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.dismissLoadingView()
            }
            
            switch result {
            case .success(let posts):
                
                if posts.isEmpty {
                    print("Empty")
                } else {
                    self.posts = posts
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.view.bringSubviewToFront(self.tableView)
                    }
                }
                
            case .failure(let error):
                print("Failed to fetch posts: \(error)")
            }
        }
    }
    
    func backButton() {
        
    }
    
    private func getStatusBarHeight() -> CGFloat {
        let statusBarHeight: CGFloat
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            statusBarHeight = windowScene.statusBarManager?.statusBarFrame.height ?? 0
        } else {
            statusBarHeight = 0
        }
        return statusBarHeight
    }
    
    func setUI() {
//        let backButton = UIBarButtonItem(image: UIImage(named: "ic-list-options"), style: .plain, target: self, action: #selector(openMenu))
//        backButton.tintColor = .black
//        navigationItem.leftBarButtonItem = backButton
//        
//        let addButton = UIBarButtonItem(image: UIImage(named: "ic-add"), style: .plain, target: self, action: #selector(addPost))
//        addButton.tintColor = .black
//        navigationItem.rightBarButtonItem = addButton
        self.navigationController?.isNavigationBarHidden = true
        
        let navigationBarHeight = navigationController?.navigationBar.frame.height ?? 0
        let statusBarHeight = getStatusBarHeight()
        
        view.addSubview(navContainerView)
        navContainerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(navigationBarHeight + statusBarHeight)
        }
        
        view.addSubview(menuButton)
        menuButton.snp.makeConstraints { make in
            make.bottom.equalTo(navContainerView.snp.bottom).offset(-5)
            make.left.equalTo(navContainerView).offset(10)
            make.height.width.equalTo(40)
        }
        
        view.addSubview(addButton)
        addButton.snp.makeConstraints { make in
            make.bottom.equalTo(navContainerView.snp.bottom).offset(-5)
            make.right.equalTo(navContainerView).offset(-10)
            make.height.width.equalTo(40)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navContainerView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    lazy var navContainerView: UIView = {
        let navContainerView = UIView()
        navContainerView.backgroundColor = .white
        return navContainerView
    }()
    
    lazy var menuButton: UIButton = {
        let menuButton = UIButton(type: .custom)
        menuButton.setImage(UIImage(named:  "ic-list-options"), for: .normal)
        menuButton.addTarget(self, action: #selector(openMenu), for: .touchUpInside)
        return menuButton
    }()
    
    lazy var addButton: UIButton = {
        let addButton = UIButton(type: .custom)
        addButton.setImage(UIImage(named:  "ic-add"), for: .normal)
        addButton.addTarget(self, action: #selector(addPost), for: .touchUpInside)
        return addButton
    }()
    
    @objc func openMenu() {
        addChild(sideMenuVC)
        view.addSubview(sideMenuVC.view)
        
        sideMenuVC.didMove(toParent: self)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.sideMenuVC.view.frame.origin.x = 0
        }) { _ in
            self.view.addSubview(self.overlay)
            self.view.bringSubviewToFront(self.sideMenuVC.view)
        }
    }
    
    func closeMenu() {
        let menuXPosition = -view.frame.width
        
        UIView.animate(withDuration: 0.3, animations: {
            self.sideMenuVC.view.frame.origin.x = menuXPosition
        }) { _ in
            self.overlay.removeFromSuperview()
        }
    }
    
    lazy var sideMenuVC: SideMenuVC = {
        let sideMenuVC = SideMenuVC()
        sideMenuVC.view.frame = CGRect(x: -view.frame.width, y: 0, width: view.frame.width - 50, height: view.frame.height)
        sideMenuVC.delegate = self
        return sideMenuVC
    }()
    
    lazy var overlay: UIView = {
        let overlay = UIView()
        overlay.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        overlay.backgroundColor = .black.withAlphaComponent(0.5)
        return overlay
    }()
    
    @objc func addPost() {
        let createPost = CreatePostVC()
        createPost.delegate = self
        
        let creatPostController = UINavigationController(rootViewController: createPost)
        present(creatPostController, animated: true)
    }
    
    lazy var tableView: UITableView = {
        let tableView           = UITableView()
        tableView.rowHeight     = 80
        tableView.delegate      = self
        tableView.dataSource    = self
        tableView.register(PostListViewCell.self, forCellReuseIdentifier: PostListViewCell.reuseID)
        return tableView
    }()
}

extension PostListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostListViewCell.reuseID) as! PostListViewCell
        
        let post = posts[indexPath.row]
        cell.set(post: post)
        cell.usernameLabel.text = username
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let post    = posts[indexPath.row]
        let postVC  = PostVC()
        postVC.postModel = post
        postVC.username = username
        
        navigationController?.pushViewController(postVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        
        let post = posts[indexPath.row]
        
        userService.deletePost(withId: post.id) { [weak self] success in
            guard let self = self else { return }
            
            DispatchQueue.main.async() {
                if success {
                    self.posts.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                } else {
                    let alert = UIAlertController(title: "Error", message: "Failed to delete post", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                }
            }
        }
    }
}
