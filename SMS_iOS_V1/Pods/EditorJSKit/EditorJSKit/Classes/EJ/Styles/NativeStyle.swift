//
//  NativeStyle.swift
//  EditorJSKit
//
//  Created by Иван Глушко on 19/06/2019.
//  Copyright © 2019 Иван Глушко. All rights reserved.
//

import Foundation

///
class NativeStyle: EJStyle {

    override init(blockStyles: [BlockStyle]? = nil) {
        if #available(iOS 13.0, *) {
            super.init(blockStyles: [(EJNativeBlockType.header, HeaderBlockNativeStyle()),
                                     (EJNativeBlockType.image, ImageBlockNativeStyle()),
                                     (EJNativeBlockType.linkTool, LinkBlockNativeStyle()),
                                     (EJNativeBlockType.list, ListBlockNativeStyle()),
                                     (EJNativeBlockType.delimiter, DelimiterBlockNativeStyle()),
                                     (EJNativeBlockType.paragraph, ParagraphBlockNativeStyle()),
                                     (EJNativeBlockType.raw, RawHtmlBlockNativeStyle())])
        } else {
            super.init()
            // Fallback on earlier versions
        }
    }
}
