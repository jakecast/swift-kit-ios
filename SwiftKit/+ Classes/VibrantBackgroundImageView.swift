import UIKit

public class VibrantBackgroundImageView: TemplateImageView {
    public override func awakeFromNib() {
        super.awakeFromNib()

        self.alpha = UIDevice.isSimulator ? 0.2 : self.alpha
    }
}
