import ProjectDescription
import ProjectDescriptionHelpers
import UtilityPlugin

let project = Project.makeModule(
    name: "ThirdPartyLib",
    product: .framework,
    packages: [],
    dependencies: [
        .external(name: "RxSwift"),
        .external(name: "RxCocoa"),
        .external(name: "SnapKit"),
        .external(name: "Lottie"),
        .external(name: "RxFlow"),
        .external(name: "XCameraKit"),
        .external(name: "Then")
    ]
)
