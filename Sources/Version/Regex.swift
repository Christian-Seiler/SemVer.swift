//
//  Regex.swift
//  
//
//  Created by Christian Seiler on 03.03.22.
//

import Foundation

let numeric = #"0|[1-9]\d*"#
let alphanumeric = #"[0-9a-zA-Z-]+"#
let buildIdentifier = #"\d*[a-zA-Z-][0-9a-zA-Z-]*"#
let dot = #"\."#
let plus = #"\+"#

let prerelease = "(?:-(?<prerelease>(?:\(numeric)|\(buildIdentifier))(?:\(dot)(?:\(numeric)|\(buildIdentifier)))*))?"
let build = "(?:\(plus)(?<buildmetadata>\(alphanumeric)(?:\(dot)\(alphanumeric))*))?"
let major = "(?<major>\(numeric))"
let minor = "(?<minor>\(numeric))"
let patch = "(?<patch>\(numeric))"
let versionCore = "\(major)\\.\(minor)\\.\(patch)"
let validVersion = "\(versionCore)\(prerelease)\(build)"

let regex = NSRegularExpression(validVersion)

let s = #"(?<major>0|[1-9]\d*)\.(?<minor>0|[1-9]\d*)\.(?<patch>0|[1-9]\d*)(?:-(?<prerelease>(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+(?<buildmetadata>[0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+*))?"#
let t = #"(?<major>0|[1-9]\d*)\.(?<minor>0|[1-9]\d*)\.(?<patch>0|[1-9]\d*)(?:-(?<prerelease>(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\.(?:0|[1-9]\d*|\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\+(?<buildmetadata>[0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?"#
