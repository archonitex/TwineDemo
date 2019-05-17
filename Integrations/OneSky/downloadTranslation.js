var onesky = require('@senatorsfc/onesky-utils'),
fs = require('fs'),
minimist = require('minimist'),
path = require("path");

var options = {
    secret: 'CXrhUode8sTjFdMjD0PZc1m4UKCwaDKC',
    apiKey: 'q1JbfMfe5YnA20KwRplTgyN19goaJYD0'
};

function printExecExample() {
    console.log([
        '',
        "Example usage : ",
        "node downloadTranslations.js <projectId>",
        '',
        "Parameters :",
        "--output <filepath>",
        "--language <language code>: The language of the file to download.",
        "--filename: The filename to download."
    ].join('\n'))
}

function readCLIArguments() {
    var argv = minimist(process.argv.slice(3));
    options.projectId = process.argv[2]
    options.output = argv.output
    options.fileName = argv.filename
    options.language = argv.language

    //Validate projectId is set
    if (!options.projectId) {
        console.error("Missing projectId")
        printExecExample()
        process.exit(1)
    }

    //Validate language is set
    if (!options.language) {
        console.error("Missing language")
        printExecExample()
        process.exit(1)
    }
    
    //Validate output is set
    if (!options.output) {
        console.error("Missing output")
        printExecExample()
        process.exit(1)
    }

    //Validate fileName is set
    if (!options.fileName) {
        console.error("Missing fileName")
        printExecExample()
        process.exit(1)
    }
}

function downloadTranslationFile() {
    console.log("Fetching file...")
    onesky.getFile(options).then(function(content){
        fs.writeFile(options.output, content, (err) => {
            if(err) console.log(err)
        })
    }).catch(function(error){
        console.log(error)
        process.exit(1)
    })
}

readCLIArguments()
downloadTranslationFile()