import Foundation

let ignoreFilesRx = "^ignore_.*"
let validFilesRx = ".*.txt"

let filesDirectoryPaths: [String] = [
	"../QuickTest"
]

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

func validateArguments() {
	guard CommandLine.arguments.count == 3 else {
		print("Invalid arguments. Run the script with :")
		print("Argument 1: File path for the translation file ")
		print("Argument 2: Language to import")
		print("")
		print("Example: swift importTranslation.swift ../Import/en/localizable.strings en")
		exit(1)
	}
}

func importTranslations() {
	let translationFilePath = CommandLine.arguments[1]
	let importLanguage = CommandLine.arguments[2]

	var stringsFiles = [URL]()
	for directory in filesDirectoryPaths {
		stringsFiles.append(contentsOf: getLocalizableFilePaths(inDirectory: directory))
	}

	guard !stringsFiles.isEmpty else {
		print("No valid files found")
		exit(1)
	}

	//Import the translations for each text files. This will only update existing keys in the text files.
	for filePath in stringsFiles {
		//Execute Twine command
		let twineTask = Process()
		twineTask.launchPath = "/usr/local/bin/bundle"
		twineTask.arguments = ["exec", "twine", "consume-localization-file", filePath.relativePath, translationFilePath, "--lang", importLanguage, "--quiet"]
		twineTask.launch()
		twineTask.waitUntilExit()
		if twineTask.terminationStatus != 0 {
			exit(twineTask.terminationStatus)
		}
	}
}

validateArguments()
importTranslations()
exit(0)

