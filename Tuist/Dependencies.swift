import ProjectDescription
import ProjectDescriptionHelpers

let spm = SwiftPackageManagerDependencies([
    .remote(url: "https://github.com/SnapKit/SnapKit.git", requirement: .upToNextMinor(from: "5.0.0")),
    .remote(url: "https://github.com/ReactiveX/RxSwift.git", requirement: .upToNextMinor(from: "6.5.0")),
    .remote(url: "https://github.com/Quick/Quick.git", requirement: .upToNextMajor(from: "6.1.0")),
    .remote(url: "https://github.com/Quick/Nimble.git", requirement: .upToNextMajor(from: "11.0.0")),
    .remote(url: "https://github.com/airbnb/lottie-ios", requirement: .upToNextMajor(from:"4.0.1")),
    .remote(url: "https://github.com/RxSwiftCommunity/RxFlow.git", requirement: .upToNextMajor(from: "2.13.0")),
    .remote(url: "https://github.com/jjunhaa0211/XCameraKit", requirement: .upToNextMinor(from: "1.1.1"))
])

let dependencies = Dependencies(
    carthage: [],
    swiftPackageManager: spm,
    platforms: [.iOS]
)
