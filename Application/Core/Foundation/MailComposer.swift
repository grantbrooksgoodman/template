//
//  MailComposer.swift
//
//  Created by Grant Brooks Goodman.
//  Copyright © NEOTechnica Corporation. All rights reserved.
//

/* Native */
import Foundation
import MessageUI
import UIKit

/* 3rd-party */
import CoreArchitecture

public final class MailComposer: UIViewController, MFMailComposeViewControllerDelegate {
    // MARK: - Types

    public struct AttachmentData {
        /* MARK: Properties */

        // Data
        public let data: Data

        // String
        public let fileName: String
        public let mimeType: String

        /* MARK: Init */

        public init(
            _ data: Data,
            fileName: String,
            mimeType: String
        ) {
            self.data = data
            self.fileName = fileName
            self.mimeType = mimeType
        }
    }

    // MARK: - Dependencies

    @Dependency(\.build) private var build: Build
    @Dependency(\.coreKit.ui) private var coreUI: CoreKit.UI
    @Dependency(\.fileManager) private var fileManager: FileManager

    // MARK: - Properties

    public static let shared = MailComposer()

    private var onComposeFinished: ((Result<MFMailComposeResult, Error>) -> Void)?

    // MARK: - Computed Properties

    public var canSendMail: Bool { MFMailComposeViewController.canSendMail() }

    // MARK: - Init

    private init() {
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Compose

    @MainActor
    public func compose(
        subject: String,
        body: (string: String, isHTML: Bool)?,
        recipients: [String],
        attachments: [AttachmentData] = []
    ) {
        let composeController = MFMailComposeViewController()
        composeController.mailComposeDelegate = self

        if let body {
            composeController.setMessageBody(body.string, isHTML: body.isHTML)
        }

        composeController.setSubject(subject)
        composeController.setToRecipients(recipients)

        for attachment in attachments {
            composeController.addAttachmentData(
                attachment.data,
                mimeType: attachment.mimeType,
                fileName: attachment.fileName
            )
        }

        coreUI.present(composeController)
    }

    // MARK: - On Compose Finished

    public func onComposeFinished(perform: @escaping (Result<MFMailComposeResult, Error>) -> Void) {
        onComposeFinished = perform
    }

    // MARK: - MFMailComposeViewControllerDelegate Conformance

    public func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        controller.dismiss(animated: true) {
            guard let error else {
                self.onComposeFinished?(.success(result))
                return
            }

            self.onComposeFinished?(.failure(error))
        }
    }
}
