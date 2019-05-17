var onesky = require('@brainly/onesky-utils'),
fs = require('fs'),
path = require("path");

var options = {
    language: 'en',
    secret: 'CXrhUode8sTjFdMjD0PZc1m4UKCwaDKC',
    apiKey: 'q1JbfMfe5YnA20KwRplTgyN19goaJYD0',
    format: 'IOS_STRINGS',
    keepStrings: true
};

function printExecExample() {
    console.log([
        '',
        "Example usage : ",
        "node uploadTranslations.js <stringsFilePath> <projectId>"
    ].join('\n'))
}

function readCLIArguments() {
    var filePath = process.argv[2]
    options.fileName = path.basename(filePath)
    options.projectId = process.argv[3]

    //Validate file exists
    if (!fs.existsSync(filePath)) {
        console.error("File does not exist.")
        printExecExample()
        process.exit(1)
    }

    //Load File Contents
    options.content = fs.readFileSync(filePath)
    
    //Validate projectId is set
    if (!options.projectId) {
        console.error("Missing projectId")
        printExecExample()
        process.exit(1)
    }    
}

function uploadTranslationFile() {
    console.log("Uploading...")
    console.log(options)
    onesky.postFile(options).then(function(content){
        var result = JSON.parse(content)
        console.log(result)
        if (result.meta.status != 201) {
            console.error("Failed to create file")
            process.exit(1)
        }
        console.log("Uploaded!")
        process.exit()
    }).catch(function(error){
        console.log(error)
        process.exit(1)
    })
}

readCLIArguments()
uploadTranslationFile()