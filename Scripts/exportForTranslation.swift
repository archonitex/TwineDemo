import Foundation

let ignoreFilesRx = "^ignore_.*"
let validFilesRx = ".*.txt"
let combinedFilePath = "combined.export.tmp.txt"

let filesDirectoryPaths: [String] = [
	"../QuickTest"
]

let outputFilePath = "../Export/QuickTestLocalization.zip"

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

func validateFile() {
	//Execute Twine commands
	let twineTask = Process()
	twineTask.launchPath = "/usr/local/bin/bundle"
	twineTask.arguments = ["exec", "twine", "validate-twine-file", combinedFilePath]
	twineTask.launch()
	twineTask.waitUntilExit()
	if twineTask.terminationStatus != 0 {
		cleanupCombinedFile()
		exit(twineTask.terminationStatus)
	}
}

func exportArchive() {
	//Execute Twine commands
	let twineTask = Process()
	twineTask.launchPath = "/usr/local/bin/bundle"
	twineTask.arguments = ["exec", "twine", "generate-localization-archive", combinedFilePath, outputFilePath, "--format", "apple"]
	twineTask.launch()
	twineTask.waitUntilExit()
	if twineTask.terminationStatus != 0 {
		cleanupCombinedFile()
		exit(twineTask.terminationStatus)
	}
}

// MARK: - Program execute

generateCombinedFile()
validateFile()
exportArchive()
cleanupCombinedFile()

exit(0)



