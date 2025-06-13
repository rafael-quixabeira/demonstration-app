//
//  ViewState.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 10/05/25.
//

import Foundation

public enum ViewState<T> {
    case undefined
    case loading
    case empty
    case loaded(T)
    case error(Error?)
}

extension ViewState {
    var loadedValue: T? {
        switch self {
        case .loaded(let value):
            return value
        default:
            return nil
        }
    }
    
    var isUndefinedState: Bool {
        switch self {
        case .undefined:
            return true
        default:
            return false
        }
    }
    
    var isInLoadingState: Bool {
        guard case .loading = self else { return false }
        return true
    }

    var isEmptyState: Bool {
        guard case .empty = self else { return false }
        return true
    }

    var isInErrorState: Bool {
        guard case .error = self else { return false }
        return true
    }
}
