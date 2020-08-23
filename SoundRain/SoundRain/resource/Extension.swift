//
//  Extension.swift
//  SoundRain
//
//  Created by Phan Hai on 22/08/2020.
//  Copyright © 2020 Phan Hai. All rights reserved.
//
import UIKit
import RxSwift
import RxCocoa
import SwiftyJSON
import Firebase

let image_Cache = NSCache<AnyObject, AnyObject>()

public protocol CaseIterable {
    associatedtype AllCases: Collection where AllCases.Element == Self
    static var allCases: AllCases { get }
}
extension CaseIterable where Self: Hashable {
    static var allCases: [Self] {
        return [Self](AnySequence { () -> AnyIterator<Self> in
            var raw = 0
            var first: Self?
            return AnyIterator {
                let current = withUnsafeBytes(of: &raw) { $0.load(as: Self.self) }
                if raw == 0 {
                    first = current
                } else if current == first {
                    return nil
                }
                raw += 1
                return current
            }
        })
    }
}
protocol Weakifiable: AnyObject {}
extension Weakifiable {
    func weakify(_ code: @escaping (Self) -> Void) -> () -> Void {
        return { [weak self] in
            guard let self = self else { return }
            code(self)
        }
    }
    
    func weakify<T>(_ code: @escaping (T, Self) -> Void) -> (T) -> Void {
        return { [weak self] arg in
            guard let self = self else { return }
            code(arg, self)
        }
    }
}
extension UIViewController: Weakifiable {}

extension UIView {
    static var identifier: String {
        return "\(self)"
    }
    
    static var nib: UINib? {
        let bundle = Bundle(for: self)
        let name = "\(self)"
        guard bundle.path(forResource: name, ofType: "nib") != nil else {
            return nil
        }
        return UINib(nibName: name, bundle: nil)
    }
    
    func applyShadowAndRadius(sizeX: CGFloat, sizeY: CGFloat,shadowRadius: CGFloat, shadowColor: UIColor) {
        self.backgroundColor = UIColor.clear
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = CGSize(width: sizeX, height: sizeY) //x,
        self.layer.shadowOpacity = 0.7
        self.layer.shadowRadius = shadowRadius //blur
        
        // add the border to subview
        //        let borderView = UIView()
        //        borderView.frame = self.bounds
        //        borderView.layer.cornerRadius = 10
        //
        //        borderView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.16)
        //        borderView.layer.borderWidth = 0.1
        //        borderView.layer.masksToBounds = true
        //        self.addSubview(borderView)
    }
    
    func radiusShadow(radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.16)
        self.layer.borderWidth = 0.1
        self.layer.masksToBounds = true
    }
    func clipToBoundAndRadius(radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
    }
}

extension UIViewController {
    func convertDataSnapshotToCodable<T: Codable> (data: DataSnapshot, type: T.Type) -> T? {
        do {
            let value = try JSONSerialization.data(withJSONObject: data.value, options: .prettyPrinted)
            let objec = try JSONDecoder().decode(T.self, from: value)
            return objec
        } catch let err {
            print(err.localizedDescription)
        }
        return nil
    }
}
extension UIImage {
    
    /// convert image to base64
    public var base64: String? {
        return self.jpegData(compressionQuality: 1.0)?.base64EncodedString()
    }
    func decodeBase64(toImage strEncodeData: String?) -> UIImage {
        
        if let decData = Data(base64Encoded: strEncodeData ?? "", options: .ignoreUnknownCharacters), strEncodeData?.count ?? 0 > 0 {
            return UIImage(data: decData)!
        }
        return UIImage(named: "avatar-placeholder") ?? UIImage()
    }
    
}

extension UIImageView {
    func loadhinh(link: String){
        //add cache đã lưu vào image, để khỏi load lần nữa
        if let image_cache_data = image_Cache.object(forKey: link as AnyObject) {
            self.image = image_cache_data as? UIImage
            return
        }
        
        guard let url = URL(string: link) else {
            return
        }
        let activies: UIActivityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        activies.frame = CGRect(x: self.frame.width / 2, y: self.frame.height / 2, width: 0, height: 0)
        activies.color = .blue
        activies.startAnimating()
        self.addSubview(activies)
        
        let queue = DispatchQueue(label: "queue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        queue.async {
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    if let image_dowload = UIImage(data: data){
                        activies.stopAnimating()
                        //tăng speed dowload
                        image_Cache.setObject(image_dowload, forKey: link as AnyObject)
                        self.image = image_dowload
                    }
                }
            } catch let err {
                print(err.localizedDescription)
            }
            
        }
        
    }
    
}
extension Encodable {
    func toData() throws -> Data {
        let encoder = JSONEncoder()
        let data = try encoder.encode(self)
        return data
    }
    func toJSON() throws -> JSON {
        let data = try toData()
        let value = try JSONSerialization.jsonObject(with: data, options: [])
        guard let json = value as? JSON else {
              throw NSError(domain: NSURLErrorDomain, code: NSURLErrorUnknown, userInfo: [NSLocalizedDescriptionKey : "Failed make json!!!!"])
        }
        return json
    }
}


