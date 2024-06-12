//
//  UIKit+CoreExtensions.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import UIKit

/* 3rd-party */
import Redux

// MARK: - UIApplication

public extension UIApplication {
    /* MARK: Properties */

    var interfaceStyle: UIUserInterfaceStyle? {
        keyWindow?.overrideUserInterfaceStyle
    }

    var isPresentingAlertController: Bool {
        guard let keyViewController,
              keyViewController.isKind(of: UIAlertController.self) else { return false }
        return true
    }

    var keyViewController: UIViewController? {
        keyViewController(keyWindow?.rootViewController)
    }

    var keyWindow: UIWindow? {
        connectedScenes
            .first(where: { $0 is UIWindowScene })
            .flatMap { $0 as? UIWindowScene }?.windows
            .first(where: \.isKeyWindow)
    }

    var mainScreen: UIScreen? {
        keyWindow?.screen
    }

    var snapshot: UIImage? {
        #if targetEnvironment(simulator)
        guard let mainScreen else { return nil }
        let snapshotView = mainScreen.snapshotView(afterScreenUpdates: true)
        snapshotView.bounds = .init(origin: .zero, size: mainScreen.bounds.size)

        let renderer = UIGraphicsImageRenderer(size: mainScreen.bounds.size)
        return renderer.image { _ in
            snapshotView.drawHierarchy(in: mainScreen.bounds, afterScreenUpdates: true)
        }
        #else
        guard let keyWindow else { return nil }
        var image: UIImage?

        UIGraphicsBeginImageContextWithOptions(keyWindow.layer.frame.size, false, keyWindow.screen.scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        keyWindow.layer.render(in: context)

        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image
        #endif
    }

    /* MARK: Methods */

    private func keyViewController(_ baseVC: UIViewController?) -> UIViewController? {
        if let navigationController = baseVC as? UINavigationController {
            return keyViewController(navigationController.visibleViewController)
        }

        if let tabBarController = baseVC as? UITabBarController {
            if let selectedVC = tabBarController.selectedViewController {
                return keyViewController(selectedVC)
            }
        }

        if let presented = baseVC?.presentedViewController {
            return keyViewController(presented)
        }

        return baseVC
    }
}

// MARK: - UIColor

public extension UIColor {
    /**
     Creates a color object using the specified RGB/hexadecimal code.

     - Parameter rgb: A hexadecimal integer.
     - Parameter alpha: The opacity of the color, from 0.0 to 1.0.
     */
    convenience init(rgb: Int, alpha: CGFloat = 1.0) {
        self.init(red: (rgb >> 16) & 0xFF, green: (rgb >> 8) & 0xFF, blue: rgb & 0xFF, alpha: alpha)
    }

    /**
     Creates a color object using the specified hexadecimal code.

     - Parameter hex: A hexadecimal integer.
     */
    convenience init(hex: Int) {
        self.init(red: (hex >> 16) & 0xFF, green: (hex >> 8) & 0xFF, blue: hex & 0xFF, alpha: 1.0)
    }

    private convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
}

// MARK: - UIImage

public extension UIImage {
    static func downloadedFrom(_ link: String) async -> UIImage? {
        guard let url = URL(string: link) else { return nil }
        return await downloadedFrom(url)
    }

    static func downloadedFrom(_ url: URL) async -> UIImage? {
        @Dependency(\.urlSession) var urlSession: URLSession

        guard let response = try? await urlSession.data(from: url),
              let image = UIImage(data: response.0) else { return nil }
        return image
    }

    static func downloadedFrom(_ link: String, completion: @escaping (_ image: UIImage?) -> Void) {
        guard let url = URL(string: link) else {
            completion(nil)
            return
        }

        downloadedFrom(url) { image in
            completion(image)
        }
    }

    static func downloadedFrom(_ url: URL, completion: @escaping (_ image: UIImage?) -> Void) {
        @Dependency(\.urlSession) var urlSession: URLSession

        urlSession.dataTask(with: url) { data, _, _ in
            guard let data,
                  let image = UIImage(data: data) else {
                completion(nil)
                return
            }

            completion(image)
        }.resume()
    }
}

// MARK: - UINavigationController

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        gestureRecognizer == interactivePopGestureRecognizer
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        gestureRecognizer != interactivePopGestureRecognizer
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        InteractivePopGestureRecognizer.isEnabled && viewControllers.count > 1
    }
}

// MARK: - UIView

public extension UIView {
    func addOverlay(
        alpha: CGFloat = 1,
        activityIndicator indicatorConfig: (style: UIActivityIndicatorView.Style, color: UIColor)? = nil,
        blurStyle: UIBlurEffect.Style? = nil,
        color: UIColor? = nil,
        name tag: String? = nil
    ) {
        @Dependency(\.coreKit.ui) var coreUI: CoreKit.UI

        let overlayView = blurStyle == nil ? UIView() : UIVisualEffectView(effect: UIBlurEffect(style: blurStyle!))
        overlayView.alpha = alpha
        overlayView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlayView.backgroundColor = color ?? .black
        overlayView.frame = bounds
        overlayView.tag = coreUI.semTag(for: tag ?? "OVERLAY_VIEW")
        addSubview(overlayView)

        guard let indicatorConfig else { return }

        let indicatorView = UIActivityIndicatorView(style: indicatorConfig.style)
        indicatorView.center = overlayView.center
        indicatorView.color = indicatorConfig.color
        indicatorView.startAnimating()
        indicatorView.tag = coreUI.semTag(for: "OVERLAY_VIEW_ACTIVITY_INDICATOR")
        addSubview(indicatorView)
    }

    func firstSubview(for string: String) -> UIView? {
        @Dependency(\.coreKit.ui) var coreUI: CoreKit.UI
        return subviews.first(where: { $0.tag == coreUI.semTag(for: string) })
    }

    func removeOverlay(name tag: String? = nil, animated: Bool = true) {
        let overlayViews = subviews(for: tag ?? "OVERLAY_VIEW")
        let activityIndicatorViews = subviews(for: "OVERLAY_VIEW_ACTIVITY_INDICATOR")

        Task { @MainActor in
            UIView.animate(withDuration: 0.2) {
                overlayViews.forEach { $0.alpha = 0 }
                activityIndicatorViews.forEach { $0.alpha = 0 }
            } completion: { _ in
                overlayViews.forEach { $0.removeFromSuperview() }
                activityIndicatorViews.forEach { $0.removeFromSuperview() }
            }
        }
    }

    func removeSubviews(for string: String, animated: Bool = true) {
        Task { @MainActor in
            let subviews = subviews(for: string)

            guard animated else {
                subviews.forEach { $0.removeFromSuperview() }
                return
            }

            subviews.forEach { subview in
                UIView.animate(withDuration: 0.2) {
                    subview.alpha = 0
                } completion: { _ in
                    subview.removeFromSuperview()
                }
            }
        }
    }

    func subviews(for string: String) -> [UIView] {
        @Dependency(\.coreKit.ui) var coreUI: CoreKit.UI
        return subviews.filter { $0.tag == coreUI.semTag(for: string) }
    }
}
