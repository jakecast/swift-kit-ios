import UIKit

public class SKTemplateImageView: UIImageView {
    public override func awakeFromNib() {
        super.awakeFromNib()

        if let templateImage = self.image {
            self.image = nil
            self.image = templateImage.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        }
    }
}
