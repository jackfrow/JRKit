//
//  Cache.swift
//  JRKit
//
//  Created by jackfrow on 2021/6/1.
//

import Foundation
import UIKit
class GroupDisk {
    var pathUrl: URL?
    var fileName: String? {
        didSet {
            self.configurationFileName()
        }
    }
    var fileUrl: URL?
    
    init() {
        _ = FileManager.default
        var url = URL(fileURLWithPath: NSHomeDirectory())
        url.appendPathComponent("VPNCache", isDirectory: true)
        self.pathUrl = url
    }
    
    func setObject(value: Any?, key: String){
        guard let url = self.fileUrl else {
            return
        }
        var storeDict = [String: Any]()
        if let localData = try? Data.init(contentsOf: url), var dict = try? JSONSerialization.jsonObject(with: localData, options: []) as? [String : Any] {
            if value != nil {
                dict[key] = value
            } else {
                dict.removeValue(forKey: key)
            }
            // save
            storeDict = dict
        } else {
            if value != nil {
                storeDict[key] = value!
            }
        }
        guard let data = try? JSONSerialization.data(withJSONObject: storeDict, options: []) else {
            return
        }
        (data as NSData).write(to: url, atomically: true)
    }
    
     func getObject(Key: String)-> Any? {
        guard let url = self.fileUrl else {
            return nil
        }
        if let jsonData = try? Data.init(contentsOf: url){
            guard let dict = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] else {
                return nil
            }
            return dict[Key]
        }
        return nil
    }
    
     func configurationFileName(){
        guard let fileName = self.fileName, fileName.count > 0 else {
            return
        }
        let fileManager = FileManager.default
        guard var url = self.pathUrl else {
            return
        }
        if !fileManager.fileExists(atPath: url.path) {
            do {
                try fileManager.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print("[DISK] [] create url failed",error);
            }
        }
        url.appendPathComponent(fileName, isDirectory: false)
        self.fileUrl = url;
    }
}

enum ReportDataType: String {
    case ss_delay = "ss_delay"
    case ss_use = "ss_use"
    case admin_error = ""
}

class ReportDataCachManager: GroupDisk {
    static let shared = ReportDataCachManager()
    static let KEY_LOCAL_REPORT_DATA = "key_local_report_data_version1"
    
    override init() {
        super.init()
        self.config()
    }
    
    func config(){
        self.fileName = "reportDataDB"
    }
    private func deleteLocalReportData(uuid: String) {
     if var localData = getObject(Key: ReportDataCachManager.KEY_LOCAL_REPORT_DATA) as? [String: Any] {
             if localData.keys.contains(uuid) {
                 localData.removeValue(forKey: uuid)
                 setObject(value: localData, key: ReportDataCachManager.KEY_LOCAL_REPORT_DATA)
            }
        }
    }
     
     // MARK: - Public methods
     func storeData(value: [String: Any]?, uuid: String, url: String, key: String, maxUploadCount: Int? = 1) {
          guard let obj = value else {return}
          let storeData: [String: Any] = ["parames":obj,
                                          "maxUpLoadCount": maxUploadCount ?? 1,
                                          "upLoadCount":0,
                                          "urlString": url,
                                          "key": key,
                                          "dateInterval":UInt64(Date().timeIntervalSince1970 * 1000)];
         if var localData =  getObject(Key: ReportDataCachManager.KEY_LOCAL_REPORT_DATA) as? [String: Any] {
              localData[uuid] = storeData;
              self.setObject(value: localData, key: ReportDataCachManager.KEY_LOCAL_REPORT_DATA)
          } else {
              let data = [uuid: storeData];
              self.setObject(value: data, key: ReportDataCachManager.KEY_LOCAL_REPORT_DATA)
          }
      }
      
     func successReportData(uuid: String) {
          deleteLocalReportData(uuid: uuid)
      }
      
     func failedReportData(uuid: String) {
         guard var localData = getObject(Key: ReportDataCachManager.KEY_LOCAL_REPORT_DATA) as? [String: Any], var data = localData[uuid] as? [String: Any], let maxUpLoadCount = data["maxUpLoadCount"] as? Int, let upLoadCount = data["upLoadCount"] as? Int else {
              return
          }
          let updateUploadCount = upLoadCount + 1
          if updateUploadCount >= maxUpLoadCount {
              self.deleteLocalReportData(uuid: uuid)
          } else {
              data["upLoadCount"] = updateUploadCount;
              localData[uuid] = data
              self.setObject(value: localData, key: ReportDataCachManager.KEY_LOCAL_REPORT_DATA)
          }
          
      }
}

