import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "TodayKit",
    product: .staticFramework,
    dependencies: [
        .Project.Core
    ],
    resources: ["Resources/**"],
    hasTest: true
)
