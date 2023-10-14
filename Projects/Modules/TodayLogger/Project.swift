import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "TodayLogger",
    product: .staticFramework,
    dependencies: [
        .Project.ThridPartyLib
    ]
)
