//
//  HelpStruct.swift
//  AImergence2
//
//  Created by Olivier Georgeon on 25/01/16.
//  Copyright © 2016 Olivier Georgeon. All rights reserved.
//

import UIKit

struct HelpStruct
{
    // static let language = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode)!

    // Debug: use "fr" or "base" in the line below to force language to French or to default
    static let bundlePath:NSString = NSBundle.mainBundle().pathForResource("Help", ofType: "strings", inDirectory: nil, forLocalization: "fr")!
    static let bundle:NSBundle = NSBundle(path: bundlePath.stringByDeletingLastPathComponent)!

    static let text:[String] =
    [
        NSLocalizedString("help00", tableName: "Help", bundle: bundle, comment: "") +
        NSLocalizedString("help01", tableName: "Help", bundle: bundle, comment: "") +
        NSLocalizedString("help02", tableName: "Help", bundle: bundle, comment: "") +
        NSLocalizedString("help03", tableName: "Help", bundle: bundle, comment: "") +
        NSLocalizedString("help04", tableName: "Help", bundle: bundle, comment: "") +
        NSLocalizedString("help05", tableName: "Help", bundle: bundle, comment: "")
        ,
        NSLocalizedString("help10", tableName: "Help", bundle: bundle, comment: "") +
        NSLocalizedString("help11", tableName: "Help", bundle: bundle, comment: "") +
        NSLocalizedString("help12", tableName: "Help", bundle: bundle, comment: "") +
        NSLocalizedString("help13", tableName: "Help", bundle: bundle, comment: "") +
        NSLocalizedString("help14", tableName: "Help", bundle: bundle, comment: "") +
        NSLocalizedString("help15", tableName: "Help", bundle: bundle, comment: "")
        ,
        NSLocalizedString("help20", tableName: "Help", bundle: bundle, comment: "") +
        NSLocalizedString("help21", tableName: "Help", bundle: bundle, comment: "") +
        NSLocalizedString("help22", tableName: "Help", bundle: bundle, comment: "") +
        NSLocalizedString("help23", tableName: "Help", bundle: bundle, comment: "") +
        NSLocalizedString("help24", tableName: "Help", bundle: bundle, comment: "") +
        NSLocalizedString("help25", tableName: "Help", bundle: bundle, comment: "")
        ,
        NSLocalizedString("help30", tableName: "Help", bundle: bundle, comment: "") +
        NSLocalizedString("help31", tableName: "Help", bundle: bundle, comment: "") +
        NSLocalizedString("help32", tableName: "Help", bundle: bundle, comment: "") +
        NSLocalizedString("help33", tableName: "Help", bundle: bundle, comment: "") +
        NSLocalizedString("help34", tableName: "Help", bundle: bundle, comment: "") +
        NSLocalizedString("help35", tableName: "Help", comment: "")
        ,
        NSLocalizedString("help40", tableName: "Help", bundle: bundle, comment: "") +
        NSLocalizedString("help41", tableName: "Help", bundle: bundle, comment: "") +
        NSLocalizedString("help42", tableName: "Help", bundle: bundle, comment: "") +
        NSLocalizedString("help43", tableName: "Help", bundle: bundle, comment: "") +
        NSLocalizedString("help44", tableName: "Help", bundle: bundle, comment: "") +
        NSLocalizedString("help45", tableName: "Help", bundle: bundle, comment: "")
    ]
}