//
//  ViewController.swift
//  ios101-project5-tumbler
//

import UIKit
import Nuke

class ViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableview: UITableView!
    var posts: [Post] = []

        // Refresh control for pull-to-refresh
        let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Setting tableview datasource
                tableview.dataSource = self
                
                // Setting up the refresh control
                refreshControl.addTarget(self, action: #selector(refreshPosts), for: .valueChanged)
                tableview.refreshControl = refreshControl

                // Fetch posts initially
                fetchPosts()

    }

    @objc func refreshPosts() {
          fetchPosts()
          tableview.refreshControl?.endRefreshing()
      }

    func fetchPosts() {
        let url = URL(string: "https://api.tumblr.com/v2/blog/humansofnewyork/posts/photo?api_key=1zT8CiXGXFcQDyMFG7RtcfGLwTdDjFUJnZzKJaWTmgyK4lKGYk")!
        let session = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Error: \(error.localizedDescription)")
                return
            }

            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, (200...299).contains(statusCode) else {
                print("❌ Response error: \(String(describing: response))")
                return
            }

            guard let data = data else {
                print("❌ Data is NIL")
                return
            }

            do {
                let blog = try JSONDecoder().decode(Blog.self, from: data)
                                self.posts = blog.response.posts
                                
                                // Reload table view on the main thread
                                DispatchQueue.main.async {
                                    self.tableview.reloadData()
                                }
            } catch {
                print("❌ Error decoding JSON: \(error.localizedDescription)")
            }
        }
        session.resume()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return posts.count
        }

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
            
            let post = posts[indexPath.row]
            cell.descriptionLabel.text = post.summary
            if let photo = post.photos.first {
                let url = photo.originalSize.url
                Nuke.loadImage(with: url, into: cell.customImageView)
            }
            
            return cell
        }
    }

