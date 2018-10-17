// =======
// Copyright 2018 Heidelpay GmbH
// 
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// =========


import Foundation

/// Protocol of the BackendService which is responsible to create and execute
/// backend requests
///
/// The protocol allows the service to be mocked for unit testing
protocol BackendService {
    
    /// perform a request on the backend
    /// - Parameter request: the request to be performed
    /// - Parameter completionHandler: Block that is called after completion. In case of success the response element
    ///                                which belongs to the given request is provided as first parameter. The second
    ///                                parameter will be nil.
    ///                                In case of an error a BackendError is provided as second parameter and the first
    ///                                parameter is nil.
    func perform(request: HeidelpayRequest, completionHandler: @escaping ((Any?, BackendError?) -> Void))
    
}
