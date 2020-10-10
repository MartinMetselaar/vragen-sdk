import UIKit

private enum Constants {
    static let lineWidth: CGFloat = 1
    static let borderColor: UIColor = .init(red: 161.0/255, green: 161.0/255, blue: 161.0/255, alpha: 1)

    struct Selected {
        static let spacing: CGFloat = 4
        static let color: UIColor = .init(red: 40.0/255, green: 40.0/255, blue: 161.0/255, alpha: 1)
    }
}

/// The checkmark that is used in the `AnswerButton`
class AnswerButtonCheckmark: UIControl {
    init() {
        super.init(frame: .zero)

        backgroundColor = .clear
    }

    override var isSelected: Bool {
        didSet {
            setNeedsDisplay()
        }
    }

    override var isHighlighted: Bool {
        didSet {
            setNeedsDisplay()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.setLineWidth(Constants.lineWidth);
        Constants.borderColor.set()

        // Create Circle
        let radius = frame.size.height / 2 - Constants.lineWidth
        let center = CGPoint(x: frame.size.width / 2 , y: frame.size.height / 2)
        context.addArc(center: center, radius: radius, startAngle: 0.0, endAngle: .pi * 2.0, clockwise: true)

        // Draw the circle
        context.strokePath()

        // When the view is highlighted or selected we need to fill the circle with a dot
        if isHighlighted || isSelected {

            Constants.Selected.color.set()

            // Create fill
            let radiusDot = (frame.size.height - Constants.lineWidth) / 2 - Constants.Selected.spacing
            let centerDot = CGPoint(x: frame.size.width / 2 , y: frame.size.height / 2)
            context.addArc(center: centerDot, radius: radiusDot, startAngle: 0.0, endAngle: .pi * 2.0, clockwise: true)

            // Fill the circle
            context.fillPath()
        }
    }
}
