//
//  Result.swift
//  Weather
//
//  Created by Pau on 26/10/2016.
//  Copyright © 2016 Pau. All rights reserved.
//

import Foundation

/**
 Represents either a success or a failure condition.
 Example of a result for an asynch image loaded: Result<UIImage,NSError>
 Inspired by: https://github.com/antitypical/Result
 
 - Success: In case of a success, this contains a generic associated completion value type
 - Failure: In case of a failure, this contains a generic associated error value type
 */
public enum Result<T,E> {
    case Success(T)
    case Failure(E)
}

/**
 Same for Result, but it also provides an extra case for when an operation is cancelled.
 
 - Success: In case of a success, this contains a generic associated completion value type
 - Failure: In case of a failure, this contains a generic associated error value type
 - Cancel:  In case of a cancel.
 */

public enum CancellableResult<T,E> {
    case Success(T)
    case Failure(E)
    case Cancellation
}
