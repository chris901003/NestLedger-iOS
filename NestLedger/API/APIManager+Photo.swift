// Created for NestLedger in 2025
// Using Swift 5.0
//
//
// Created by HongYan on 2025/2/21.
// Copyright © 2025 HongYan. All rights reserved.


import Foundation
import UIKit

// MARK: - Photo API
extension APIManager {
    enum PhotoError: LocalizedError {
        case convertPhotoError
        case failedUploadSinglePhoto
        case failedFetchPhoto
        case failedDeleteSinglePhoto

        var errorDescription: String? {
            switch self {
                case .convertPhotoError:
                    return "轉換照片失敗"
                case .failedUploadSinglePhoto:
                    return "上傳單張照片失敗"
                case .failedFetchPhoto:
                    return "獲取單張照片失敗"
                case .failedDeleteSinglePhoto:
                    return "刪除單張照片失敗"
            }
        }
    }

    func fetchSinglePhoto(path: String) async throws -> UIImage {
        guard var url = APIPath.Photo.single.getUrl() else { throw APIManagerError.badUrl }
        url.append(path: path)

        let request = genRequest(url: url, method: .GET)
        do {
            let (data, _) = try await send(request: request)
            guard let image = UIImage(data: data) else {
                throw PhotoError.convertPhotoError
            }
            return image
        } catch {
            if error is PhotoError { throw error }
            throw PhotoError.failedFetchPhoto
        }
    }

    func deleteSinglePhoto(path: String) async throws {
        guard var url = APIPath.Photo.single.getUrl() else { throw APIManagerError.badUrl }
        url.append(path: path)

        let request = genRequest(url: url, method: .DELETE)
        do {
            let (_, response) = try await send(request: request)
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else { throw PhotoError.failedDeleteSinglePhoto }
        } catch {
            throw PhotoError.failedDeleteSinglePhoto
        }
    }

    func uploadSinglePhoto(_ image: UIImage, path: String, filename: String = UUID().uuidString) async throws -> String {
        guard let url = APIPath.Photo.single.getUrl() else { throw APIManagerError.badUrl }

        var request = genRequest(url: url, method: .POST)
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        let imageData = image.jpegData(compressionQuality: 0.3)
        guard let imageData else { throw PhotoError.convertPhotoError }

        let filename = filename.hasSuffix(".jpg") ? filename : filename + ".jpg"

        // Image Data
        let fieldName = "photo"
        let mimeType = "image/jpeg"
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)

        // Others
        let parameters: [String: String] = [
            "path": path,
            "name": filename
        ]
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body
        request.setValue("\(body.count)", forHTTPHeaderField: "Content-Length")

        do {
            let (_, response) = try await send(request: request)
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                throw PhotoError.failedUploadSinglePhoto
            }
        } catch {
            throw PhotoError.failedUploadSinglePhoto
        }
        return path + "/" + filename
    }
}
