//
//  ViewState.swift
//  rickandmortyapp
//
//  Created by Rafael Quixabeira on 10/05/25.
//

enum ViewState<T: Equatable> {
    case undefined
    case loading
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
        switch self {
        case .loading:
            return true
        default:
            return false
        }
    }

    var isInErrorState: Bool {
        switch self {
        case .error:
            return true
        default:
            return false
        }
    }
}
