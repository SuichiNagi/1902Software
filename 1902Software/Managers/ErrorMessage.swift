//
//  ErrorMessage.swift
//  1902Software
//
//  Created by Aldrei Glenn Nuqui on 7/4/24.
//

import Foundation

enum ErrorMessage: String, Error {
    case invalidRegister        = "This username created an invalid request. Please try again"
    case unableToComplete       = "Unable to complete your request. Please check you internet connection"
    case invalidResponse        = "Invalid response from the server. Please try again."
    case invalidData            = "The data received from the server is invalid. Please try again"
    case unableToFavorite       = "There was an error adding this user to favorites. Please try again"
    case invalidJSON            = "invalid JSON Format"
    case serverError            = "Server Error"
    case invalidURL             = "Invalid URL."
}
