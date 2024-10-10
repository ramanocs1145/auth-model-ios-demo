//
//  UserProfileModel.swift
//  AuthenticationModule
//
//  Created by Ramanathan on 08/08/24.
//

import Foundation

public struct UserProfileDataModel: NetworkResponse {
    public let data: UserProfileModel?
    
    public init(data: UserProfileModel?) {
        self.data = data
    }
    
    private enum CodingKeys: String, CodingKey {
        case data
    }
}

public struct UserProfileModel: NetworkResponse {
    public let uuid: Int64?
    public let firstName: String?
    public let lastName: String?
    public let email: String?
    public let phoneNumber: String?
    
    public init(uuid: Int64?, firstName: String?, lastName: String?, email: String?, phoneNumber: String?) {
        self.uuid = uuid
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.phoneNumber = phoneNumber
    }
    
    private enum CodingKeys: String, CodingKey {
        case uuid
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case phoneNumber = "phone_number"
    }
}
