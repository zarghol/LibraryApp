//
//  ErrorStore.swift
//  Library
//
//  Created by Admin on 11/02/2023.
//

import Foundation
import SwiftUI

/// An object storing errors useful on order track error from the view hierarchy and display it from the top one.
final class ErrorStore: ObservableObject {
    @Published var error: Error? = nil

    var errorString: LocalizedStringKey? {
        guard let error else { return nil }

        guard let error = error as? LocalizedError else {
            return "An error occured. Please try again later"
        }

        return error.errorDescription.map { LocalizedStringKey($0) }
    }


    /// Catch an error, displaying an error toast from ``AppRootView``for 2 seconds.
    /// - Parameter error: The error to display.
    func catchError(error: Error) {
        self.error = error

        Task { @MainActor [weak self] in
            try? await Task.sleep(nanoseconds: 2_000_000_000)

            self?.error = nil
        }
    }
}
