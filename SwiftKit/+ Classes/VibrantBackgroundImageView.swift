import UIKit

public class VibrantBackgroundImageView: TemplateImageView {
    public override func awakeFromNib() {
        super.awakeFromNib()

        self.hidden = UIDevice.isSimulator
    }
}
