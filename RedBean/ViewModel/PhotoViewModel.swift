//
//  PhotoViewModel.swift
//  RedBean
//
//  Created by Angel on 7/11/25.
//

import SwiftUI
import UIKit
import Combine
import StreamVideoSwiftUI

/// Builds the photobooth strip: four shots placed behind the windows of the "Frame" artwork.
enum PhotoStrip {
    static let shotCount = 4

    /// Window bounds in the Frame image's pixels (2048 × 4413), measured from its transparent areas.
    /// The 4th window is irregular (the table art covers part of it); the frame drawn on top hides the overlap.
    static let windows: [CGRect] = [
        CGRect(x: 368, y: 432, width: 1260, height: 896),
        CGRect(x: 364, y: 1428, width: 1272, height: 776),
        CGRect(x: 364, y: 2312, width: 1280, height: 860),
        CGRect(x: 360, y: 3304, width: 1288, height: 1048),
    ]

    /// The visible part of the strip. The frame image has transparent margins left and right.
    static let stripArea = CGRect(x: 278, y: 0, width: 1493, height: 4413)

    /// Photos extend this far under the frame so no gaps show at the window edges.
    static let bleed: CGFloat = 12

    /// Width ÷ height of the live preview, matching the windows.
    static let shotAspectRatio: CGFloat = 1260.0 / 896.0

    static func makeStrip(shots: [UIImage], frame: UIImage? = UIImage(named: "Frame")) -> UIImage? {
        guard let frameCG = frame?.cgImage else { return nil }
        let frameSize = CGSize(width: frameCG.width, height: frameCG.height)

        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        format.opaque = true
        let renderer = UIGraphicsImageRenderer(size: stripArea.size, format: format)

        return renderer.image { context in
            let cg = context.cgContext
            cg.translateBy(x: -stripArea.minX, y: -stripArea.minY)

            UIColor(named: "aPink")?.setFill() ?? UIColor.white.setFill()
            cg.fill(CGRect(origin: .zero, size: frameSize))

            for (shot, window) in zip(shots, windows) {
                let target = window.insetBy(dx: -bleed, dy: -bleed).intersection(stripArea)
                cg.saveGState()
                cg.clip(to: target)
                shot.draw(in: aspectFill(shot.size, into: target))
                cg.restoreGState()
            }

            UIImage(cgImage: frameCG).draw(in: CGRect(origin: .zero, size: frameSize))
        }
    }

    /// The rect that scales `size` to cover `target` completely, centered.
    static func aspectFill(_ size: CGSize, into target: CGRect) -> CGRect {
        guard size.width > 0, size.height > 0 else { return target }
        let scale = max(target.width / size.width, target.height / size.height)
        let scaled = CGSize(width: size.width * scale, height: size.height * scale)
        return CGRect(
            x: target.midX - scaled.width / 2,
            y: target.midY - scaled.height / 2,
            width: scaled.width,
            height: scaled.height
        )
    }
}

/// Tells Stream's `.snapshot` modifier when to grab the live preview.
final class BoothSnapshotTrigger: SnapshotTriggering {
    private let subject = CurrentValueSubject<Bool, Never>(false)

    lazy var binding: Binding<Bool> = Binding(
        get: { [subject] in subject.value },
        set: { [subject] in subject.send($0) }
    )

    var publisher: AnyPublisher<Bool, Never> { subject.eraseToAnyPublisher() }

    func capture() { subject.send(true) }
}
