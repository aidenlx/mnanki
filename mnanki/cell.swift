//
//  main.swift
//  cb
//
//  Created by Aiden Liu on 2019/9/13.
//  Copyright © 2019 Aiden Liu. All rights reserved.
//

import Foundation
import AppKit

func firstImage(textStorage: NSAttributedString) -> NSImage? {
    for idx in 0 ..< textStorage.string.count {
        if
            let attr = textStorage.attribute(NSAttributedString.Key.attachment, at: idx, effectiveRange: nil),
            let attachment = attr as? NSTextAttachment,
            let cell = attachment.attachmentCell as? NSTextAttachmentCell,
            let image = cell.image {
            return image
        }
    }
    return nil
}

extension NSAttributedString {
    var attributedString2Html: String? {
        do {
            let htmlData = try self.data(from: NSRange(location: 0, length: self.length), documentAttributes:[.documentType: NSAttributedString.DocumentType.html]);
            return String.init(data: htmlData, encoding: String.Encoding.utf8)
        } catch {
            print("error:", error)
            return nil
        }
    }
}
public extension NSImage {
    func writePNG(toURL url: URL) {
        
        guard let data = tiffRepresentation,
            let rep = NSBitmapImageRep(data: data),
            let imgData = rep.representation(using: .png, properties: [.compressionFactor : NSNumber(floatLiteral: 1.0)]) else {
                
                Swift.print("\(self) Error Function '\(#function)' Line: \(#line) No tiff rep found for image writing to \(url)")
                return
        }
        
        do {
            try imgData.write(to: url)
        }catch let error {
            Swift.print("\(self) Error Function '\(#function)' Line: \(#line) \(error.localizedDescription)")
        }
    }
}
//遍历文档
func cell() {
let pb = NSPasteboard.general
if let raw = pb.data(forType: .rtfd){
    if let atext = NSMutableAttributedString(rtfd: raw, documentAttributes: nil)
    {
        //删除空行
        atext.deleteCharacters(in: NSRange(location: 0, length: 1))
//        提取MN链接
        atext.enumerateAttribute(.link, in: NSRange(location: 0, length: atext.length)) { (value, range, stop) in
            if (value is URL){
                //let link: URL? = (value as? URL)
                //atext.removeAttribute(.link, range: range)
                //atext.append(NSAttributedString(string: "$"+link!.absoluteString))
                atext.deleteCharacters(in: .init(location: range.upperBound, length: 1))
                atext.insert(NSAttributedString(string: "\t"), at: range.upperBound)
            }
        }
        var html = atext.attributedString2Html
        //检查图片并导出
        if (atext.containsAttachments)
        {
            //获取NSImage附件
            var images = [NSImage]()
            for idx in 0 ..< atext.string.count {
                if
                    let attr = atext.attribute(.attachment, at: idx, effectiveRange: nil),
                    let attachment = attr as? NSTextAttachment,
                    let cell = attachment.attachmentCell as? NSTextAttachmentCell,
                    let image = cell.image {
                    images.append(image)
                }
            }
            //写入硬盘
            //替换html里的png路径
            for idx in 0 ..< images.count{
                images[idx].writePNG(toURL: URL(string: "file:///tmp/test"+String(idx)+".png")!)
                let pattern = "src=\"file:///hnote.+?\\.png\""
                
                let pathRange = html!.range(of: pattern, options:.regularExpression)
                html?.replaceSubrange(pathRange!, with: "src=\"file:///tmp/test"+String(idx)+".png\"")
            }
            

        }

/*
        let file = try! FileWrapper(url: urltemp!, options: FileWrapper.ReadingOptions.immediate)
        let imgatt = NSTextAttachment(fileWrapper: file)
        let imgstr = NSAttributedString(attachment: imgatt)
        atext.append(imgstr)*/

        //导出
        pb.clearContents()
        pb.setString(html!, forType: NSPasteboard.PasteboardType.html)
        print("1")
    }
    else{print("0")}
}
else {print("0")}
}



