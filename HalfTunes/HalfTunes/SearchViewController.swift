//
//  ViewController.swift
//  HalfTunes
//
//  Created by Arpit Pittie on 14/12/16.
//  Copyright © 2016 Metacube. All rights reserved.
//

import UIKit
import AVKit
import MediaPlayer

class SearchViewController: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, URLSessionDelegate, URLSessionDownloadDelegate, TrackCellDelegate {

    // MARK: Properties
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    var searchResults = [Tracks]()
    var activeDownloads = [String: Download]()
    
    lazy var downloadSession: URLSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    // MARK: Actions
    func startDownload(_ track: Tracks) {
        if let urlString = track.previewUrl, let url = URL(string: urlString) {
            let download = Download(url: urlString)
            
            download.downloadTask = downloadSession.downloadTask(with: url)
            
            download.downloadTask!.resume()
            download.isDownloading = true
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            activeDownloads[download.url] = download
        }
    }
    
    func cancelDownload(_ track: Tracks) {
        if let urlString = track.previewUrl,
            let download = activeDownloads[urlString] {
            download.downloadTask?.cancel()
            activeDownloads[urlString] = nil
        }
    }
    
    func updateSearchResults(_ data: Data?) {
        searchResults.removeAll()
        do {
            if let data = data, let response = try JSONSerialization.jsonObject(with: data, options: .init(rawValue: 0)) as? [String: AnyObject] {
                if let array: AnyObject = response["results"] {
                    for trackDictionary in array as! [AnyObject] {
                        if let trackDictionary = trackDictionary as? [String: AnyObject] {
                            let name = trackDictionary["trackName"] as? String
                            let artist = trackDictionary["artistName"] as? String
                            let previewUrl = trackDictionary["previewUrl"] as? String
                            
                            searchResults.append(Tracks(name: name, artist: artist, previewUrl: previewUrl))
                        } else {
                            print("Not a Dictionary")
                        }
                    }
                } else {
                    print("Results key not found in response")
                }
            } else {
                print("JSON error")
            }
        } catch let error as NSError {
            print("Error parsing results: \(error.localizedDescription)")
        }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.tableView.setContentOffset(CGPoint.zero, animated: false)
        }
    }
    
    // MARK: Helper Methods
    
    func trackIndexForDownloadTask(_ downloadTask: URLSessionDownloadTask) -> Int? {
        if let url = downloadTask.originalRequest?.url?.absoluteString {
            for (index, track) in searchResults.enumerated() {
                if url == track.previewUrl! {
                    return index
                }
            }
        }
        return nil
    }
    
    func localFilePathForUrl(_ previewUrl: String) -> URL? {
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        
        if let url = URL(string: previewUrl) {
            let lastPathComponent = url.lastPathComponent
            
            let fullPath = documentsPath.appending(lastPathComponent)
            return URL(fileURLWithPath:fullPath)
        }
        return nil
    }
    
    func localFileExistsForTrack(_ track: Tracks) -> Bool {
        if let urlString = track.previewUrl, let localUrl = localFilePathForUrl(urlString) {
            var isDir: ObjCBool = false
            return FileManager.default.fileExists(atPath: localUrl.path, isDirectory: &isDir)
        }
        return false
    }
    
    // MARK: Media Player
    
    func playDownloadedTrack(_ track: Tracks) {
        if let urlString = track.previewUrl, let url = localFilePathForUrl(urlString) {
            //let moviePlayer: mp
            do {
                let audioPlayer = try AVAudioPlayer(contentsOf: url)
                
                audioPlayer.prepareToPlay()
                audioPlayer.play()
                print("audio player")
            } catch let error {
                print(error.localizedDescription)
            }
            
            //let playerViewController = AVPlayerViewController()
            //playerViewController.player = audioPlayer
            
            
            
            //let moviePlayers:MPMoviePlayerViewController! = MPMoviePlayerViewController(contentURL: url)
            //presentMoviePlayerViewControllerAnimated(moviePlayers)
        }
    }

    // MARK: UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        if !(searchBar.text!.isEmpty) {
            // Stop any current data task
            if dataTask != nil {
                dataTask?.cancel()
            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            
            // Encoding text in Query Format
            let expectedCharSet = CharacterSet.urlQueryAllowed
            let searchTerm = searchBar.text!.addingPercentEncoding(withAllowedCharacters: expectedCharSet)
            
            let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=\(searchTerm!)")
            dataTask = defaultSession.dataTask(with: url!) {
                data, response, error in
                
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                
                if let error = error {
                    print(error.localizedDescription)
                } else if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200 {
                        print(data)
                        self.updateSearchResults(data)
                    }
                }
            }
            dataTask?.resume()
        }
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let track = searchResults[indexPath.row]
        if localFileExistsForTrack(track) {
            playDownloadedTrack(track)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackTableCell", for: indexPath) as! TrackTableViewCell
        
        cell.delegate = self
        
        let track = searchResults[indexPath.row]
        
        cell.trackLabel.text = track.name
        cell.artistLabel.text = track.artist
        
        var showDownloadControls = false
        if let download = activeDownloads[track.previewUrl!] {
            showDownloadControls = true
            cell.downloadProgress.progress = download.progress
            cell.downloadProgressLabel.text = (download.isDownloading) ? "Downloading..": "Paused"
            
            let title = (download.isDownloading) ? "Pause" : "Resume"
            cell.pauseButton.setTitle(title, for: UIControlState())
        }
        
        cell.downloadProgress.isHidden = !showDownloadControls
        cell.downloadProgressLabel.isHidden = !showDownloadControls
        
        let downloaded = localFileExistsForTrack(track)
        cell.selectionStyle = downloaded ? UITableViewCellSelectionStyle.gray : UITableViewCellSelectionStyle.none
        cell.downloadButton.isHidden = downloaded || showDownloadControls
        
        cell.pauseButton.isHidden = !showDownloadControls
        cell.cancelButton.isHidden = !showDownloadControls
        
        return cell
    }
    
    // MARK: URLSessionDelegate
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        print("Downloading Finished")
    }
    
    // MARK: URLSessionDownloadDelegate
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        if let originalUrl = downloadTask.originalRequest?.url?.absoluteString, let destinationUrl = localFilePathForUrl(originalUrl) {
            
            let fileManager = FileManager.default
            
            do {
                try fileManager.removeItem(at: destinationUrl)
            } catch {
                // Non-fatal error : File does not exist
            }
            
            do {
                try fileManager.copyItem(at: location, to: destinationUrl)
            } catch let error as NSError {
                print("could copy file to disk: \(error.localizedDescription)")
            }
        }
        
        if let url = downloadTask.originalRequest?.url?.absoluteString {
            activeDownloads[url] = nil
            
            if let trackIndex = trackIndexForDownloadTask(downloadTask) {
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [IndexPath(row: trackIndex, section: 0)], with: .none)
                }
            }
        }
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    // MARK: TrackCellDelegate
    
    func pauseTapped(_ cell: TrackTableViewCell) {
    }
    
    func resumeTapped(_ cell: TrackTableViewCell) {
    }
    
    func cancelTapped(_ cell: TrackTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
            cancelDownload(track)
        }
    }
    
    func downloadTapped(_ cell: TrackTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let track = searchResults[indexPath.row]
            startDownload(track)
            tableView.reloadRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .none)
        }
    }
}

