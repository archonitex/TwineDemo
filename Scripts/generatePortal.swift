import Foundation

let ignoreFilesRx = "^ignore_.*"
let validFilesRx = ".*.txt"
let combinedFilePath = "combined.portal.tmp.txt"

let filesDirectoryPaths: [String] = [
	"../QuickTest/Portal",
	"../QuickTest/Shared"
]

let outputFileName = "portalLocalization.json"
let outputDirectory = "../Resources/Locales"

// MARK: - Private Functions

func getLocalizableFilePaths(inDirectory directory: String = FileManager.default.currentDirectoryPath) -> [URL] {
	var allContents = [URL]()

	//Get all subdirectory contents
	for filePath in FileManager.default.subpaths(atPath:directory) ?? [String]() {
		if filePath.range(of: validFilesRx, options: [.regularExpression, .caseInsensitive], range: nil, locale: nil) != nil {
			let fileURL = URL(fileURLWithPath:"\(directory)/\(filePath)")
			allContents.append(fileURL)
		}
	}

    return allContents    
}

func generateCombinedFile() {
	var stringsFiles = [URL]()
	for directory in filesDirectoryPaths {
		stringsFiles.append(contentsOf: getLocalizableFilePaths(inDirectory: directory))
	}

	guard !stringsFiles.isEmpty else {
		print("No valid files found")
		exit(1)
	}

	do{
		var combined = [String]()
		for filePath in stringsFiles {
			combined.append( try String(contentsOf: filePath, encoding: .utf8) )
		}
		try combined.joined(separator: "\n").write(to: URL(fileURLWithPath: combinedFilePath), atomically: false, encoding: .utf8)
	}catch{
		print(error)
		exit(1)
	}	
}

func cleanupCombinedFile() {
	do {
		try FileManager.default.removeItem(at: URL(fileURLWithPath: combinedFilePath))
	}catch{
		print(error)
		exit(1)
	}
}

func createLocalizations() {
	let twineTask = Process()
	twineTask.launchPath = "/usr/local/bin/bundle"
	twineTask.arguments = ["exec", "twine", "generate-all-localization-files", combinedFilePath, outputDirectory, "--format", "jquery", "--file-name", outputFileName, "--create-folders"]
	twineTask.launch()
	twineTask.waitUntilExit()
	if twineTask.terminationStatus != 0 {
		cleanupCombinedFile()
		exit(twineTask.terminationStatus)
	}
}

// MARK: - Program execute

generateCombinedFile()
createLocalizations()
cleanupCombinedFile()

exit(0)






