// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription
let package = Package(
    name: "ObjectiveDropboxOfficial",
    platforms: [
        .macOS(.v10_10),
        .iOS(.v9)
    ],
    products: [
        .library(
            name: "ObjectiveDropboxOfficial",
            targets: ["ObjectiveDropboxOfficial"])
	],
    targets: [
        .target(
            name: "ObjectiveDropboxOfficial",
			exclude: [
				"Platform/ObjectiveDropboxOfficial_macOS/Info.plist",
				"Platform/ObjectiveDropboxOfficial_iOS/Info.plist"
			],
			cSettings: [
				.headerSearchPath("Headers/Internal"),
				.headerSearchPath("Headers/Internal/Networking"),
				.headerSearchPath("Headers/Internal/OAuth"),
				.headerSearchPath("Headers/Internal/Resources"),
				.headerSearchPath("Headers/PlatformInternal/iOS", .when(platforms: [.iOS])),
			]
        )
    ]
)
