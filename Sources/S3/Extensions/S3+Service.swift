//
//  S3+Service.swift
//  S3
//
//  Created by Ondrej Rafaj on 11/05/2018.
//

import Foundation
import Vapor
import XMLCoding


// Helper S3 extension for working with services
public extension S3 {
    
    // MARK: Buckets
    
    /// Get list of buckets
    public func buckets(on container: Container) throws -> Future<BucketsInfo> {
        let signer = try container.makeS3Signer()
        
        let url = try self.url(on: container)
        
        let headers = try signer.headers(for: .GET, urlString: url.absoluteString, payload: .none)
        
        return try make(request: url, method: .GET, headers: headers, data: "".convertToData(), on: container).map(to: BucketsInfo.self) { response in
            if response.http.status == .notFound {
                throw Error.notFound
            }
            guard response.http.status == .ok || response.http.status == .noContent else {
                throw Error.badResponse(response)
            }
            
            return try response.decode(to: BucketsInfo.self)
        }
    }
    
}
