//
//  ErrorAlertController.swift
//  LyricsITunes
//
//  Created by Paul Ossenbruggen on 6/24/17.
//  Copyright © 2017 Paul Ossenbruggen. All rights reserved.
//

import UIKit


class ErrorAlertController {
    
    static func displayError(
        _ error: (Error),
        sourceView: UIView,
        presentingController: UIViewController
    ) {
        let alert = UIAlertController(title: "NetworkError", message: "error \(error)", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: {})
        })
        alert.addAction(okAction)
        alert.popoverPresentationController?.sourceView = sourceView
        presentingController.present(alert, animated: true, completion: {})
    }
}
