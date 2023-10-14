import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "TodayNavigator",
    product: .staticFramework,
    dependencies: [
        .Project.Presentation,
        .Project.Data
    ]
)
