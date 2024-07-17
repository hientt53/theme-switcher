import Cocoa

@discardableResult
func shell(_ args: [String], launchPath: String) -> Int32 {
    let task = Process()
    let isDark = UserDefaults.standard.string(forKey: "AppleInterfaceStyle") == "Dark"
    var env = ProcessInfo.processInfo.environment
    env["DARKMODE"] = isDark ? "1" : "0"
    task.environment = env
    task.launchPath = launchPath
    task.arguments = args
    task.standardError = FileHandle.standardError
    task.standardOutput = FileHandle.standardOutput
    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
}

func parseArguments() -> (launchPath: String, args: [String]) {
    var launchPath = "/usr/bin/env"
    var args = Array(CommandLine.arguments.suffix(from: 1))

    if let programIndex = args.firstIndex(of: "--launch-path") {
        let nextIndex = programIndex + 1
        if nextIndex < args.count {
            launchPath = args[nextIndex]
            args.removeSubrange(programIndex...nextIndex)
        }
    }

    return (launchPath, args)
}

let (launchPath, args) = parseArguments()
shell(args, launchPath: launchPath)

DistributedNotificationCenter.default.addObserver(
    forName: Notification.Name("AppleInterfaceThemeChangedNotification"),
    object: nil,
    queue: nil
) { (notification) in
    shell(args, launchPath: launchPath)
}

NSWorkspace.shared.notificationCenter.addObserver(
    forName: NSWorkspace.didWakeNotification,
    object: nil,
    queue: nil
) { (notification) in
    shell(args, launchPath: launchPath)
}

NSApplication.shared.run()
