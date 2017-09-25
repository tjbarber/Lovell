//
//  ErrorMessages.swift
//  Lovell
//
//  Created by TJ Barber on 9/25/17.
//  Copyright © 2017 Novel. All rights reserved.
//

import Foundation

enum ErrorMessages: String {
    case oops = "Oops..."
    case somethingWentWrong = "Something went wrong..."
    case mustProvideRecipientName = "You must provide a recipient name."
    case mustHaveMessage = "You must have a message to send."
    case unableToSendMessage = "We are unable to send a message right now. Please try again later."
    case pleaseTryAgainLater = "There was an error. Please try again later."
    case internalServerError = "Cannot communicate with the server. Please try again later."
    case addressNeeded = "An address needs to be provided."
    case locationNotFound = "We could not find this location. Please try another."
}
