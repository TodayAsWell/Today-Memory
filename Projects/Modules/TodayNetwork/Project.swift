import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "TodayNetwork",
    product: .staticFramework,
    dependencies: [
        .Project.Core
    ],
    hasTest: true
)
