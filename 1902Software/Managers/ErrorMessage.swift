//
//  ErrorMessage.swift
//  1902Software
//
//  Created by Aldrei Glenn Nuqui on 7/4/24.
//

import Foundation

enum ErrorMessage: String, Error {
    case invalidRegister        = "This username or email is already exist. Please try again"
    case unableToComplete       = "Unable to complete your request. Please check you internet connection"
    case invalidResponse        = "Invalid response from the server. Please try again."
    case invalidData            = "The data received from the server is invalid. Please try again"
    case invalidCredentials     = "You enter wrong username or password."
    case invalidURL             = "There's something wrong with the URL. Please try again."
}
