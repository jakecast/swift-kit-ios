import UIKit

public class StoryboardVibrantImageView: StoryboardTemplateImageView {
    public override func awakeFromNib() {
        super.awakeFromNib()

        self.alpha = UIDevice.isSimulator ? 0.2 : self.alpha
    }
}
