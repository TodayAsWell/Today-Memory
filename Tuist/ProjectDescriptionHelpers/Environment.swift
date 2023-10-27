import ProjectDescription

public enum Environment {
    public static let appBundleId = "com.Today.Release"
    public static let organizationName = "Today-iOS"
    public static let deploymentTarget: DeploymentTarget = .iOS(targetVersion: "15.0", devices: [.ipad])
}
