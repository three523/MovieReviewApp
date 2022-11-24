//
//  Extenstion.swift
//  MovieReviewApp
//
//  Created by 김도현 on 2022/10/18.
//

import Foundation

enum DeviceType {
    case iPhoneSE
    case iPhone12
    case iPhone14Pro
    case iPhone14ProMax

    func name() -> String {
        switch self {
        case .iPhoneSE:
            return "iPhone SE (3rd generation)"
        case .iPhone12:
            return "iPhone 12"
        case .iPhone14Pro:
            return "iPhone 14 Pro"
        case .iPhone14ProMax:
            return "iPhone 14 Pro Max"
        }
    }
}

#if canImport(SwiftUI) && DEBUG
import SwiftUI
extension UIViewController {

    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController

        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }

        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        }
    }

    func showPreview(_ deviceType: DeviceType = .iPhone12) -> some View {
        Preview(viewController: self).previewDevice(PreviewDevice(rawValue: deviceType.name()))
    }
}
#endif

extension UIViewController {
    var statusBarView: UIView? {
        if #available(iOS 13.0, *) {
            let statusBarFrame = UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame
            if let statusBarFrame = statusBarFrame {
                let statusBar = UIView(frame: statusBarFrame)
                view.addSubview(statusBar)
                return statusBar
            } else {
                return nil
            }
        } else {
            return UIApplication.shared.value(forKey: "statusBar") as? UIView
        }
    }
    
    func createStatusBar() -> UIView? {
        return statusBarView
    }
}
