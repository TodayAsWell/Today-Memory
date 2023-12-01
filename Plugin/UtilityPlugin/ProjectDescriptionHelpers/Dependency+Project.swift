import ProjectDescription

public extension TargetDependency {
    struct Project {}
}

public extension TargetDependency.Project {
    static let APPNavigator = TargetDependency.project(target: "TodayNavigator", path: .relativeToRoot("Projects/Modules/TodayNavigator"))
    
    static let Presentation = TargetDependency.project(target: "Presentation", path: .relativeToRoot("Projects/Presentation"))
    
    static let Core = TargetDependency.project(target: "Core", path: .relativeToRoot("Projects/Core"))
        
    static let APPKit = TargetDependency.project(target: "TodayKit", path: .relativeToRoot("Projects/Modules/TodayKit"))
    static let ThridPartyLib = TargetDependency.project(target: "ThirdPartyLib", path: .relativeToRoot("Projects/Modules/ThirdPartyLib"))
    static let TodayLogger = TargetDependency.project(target: "TodayLogger", path: .relativeToRoot("Projects/Modules/TodayLogger"))
}
