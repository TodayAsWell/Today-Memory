import ProjectDescription

public extension TargetDependency {
    struct Project {}
}

public extension TargetDependency.Project {
    static let APPNavigator = TargetDependency.project(target: "TodayNavigator", path: .relativeToRoot("Projects/Modules/TodayNavigator"))
    
    static let Presentation = TargetDependency.project(target: "Presentation", path: .relativeToRoot("Projects/Presentation"))
    
    static let Core = TargetDependency.project(target: "Core", path: .relativeToRoot("Projects/Core"))
    
    static let Data = TargetDependency.project(target: "Data", path: .relativeToRoot("Projects/Data"))
    
    static let Domain = TargetDependency.project(target: "Domain", path: .relativeToRoot("Projects/Domain"))
    
    static let APPNetwork = TargetDependency.project(target: "TodayNetwork", path: .relativeToRoot("Projects/Modules/TodayNetwork"))
    static let APPKit = TargetDependency.project(target: "TodayKit", path: .relativeToRoot("Projects/Modules/TodayKit"))
    static let ThridPartyLib = TargetDependency.project(target: "ThirdPartyLib", path: .relativeToRoot("Projects/Modules/ThirdPartyLib"))
    static let APPLogger = TargetDependency.project(target: "TodayLogger", path: .relativeToRoot("Projects/Modules/TodayLogger"))
}
