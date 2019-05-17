var onesky = require('@senatorsfc/onesky-utils'),
fs = require('fs'),
minimist = require('minimist'),
path = require("path");

var options = {
    secret: 'CXrhUode8sTjFdMjD0PZc1m4UKCwaDKC',
    apiKey: 'q1JbfMfe5YnA20KwRplTgyN19goaJYD0',
    orderType: 'translate-review',
    translatorType: 'preferred',
    tone: 'informal',
    includeNotTranslated: false,
    includeNotApproved: false,
    includeOutdated: false,
    specialization: 'general',
    note: 'Automated Test, do not translate'
};

function printExecExample() {
    console.log([
        '',
        "Example usage : ",
        "node translate.js <projectId>",
        '',
        "Parameters :",
        "--files <comma seperated filenames>",
        "--toLocale <language code>: Target language to translate to. Required.",
        "--quoteOnly: Generate a quote. If this is not provided, an order is created."
    ].join('\n'))
}

function readCLIArguments() {
    var argv = minimist(process.argv.slice(3));
    options.files = argv.files.split(',')

    options.projectId = process.argv[2]
    options.toLocale = argv.toLocale
    options.quoteOnly = argv.quoteOnly !== undefined

    //Make sure files is an array
    if (!Array.isArray(options.files)) {
        console.error("Files invalid.")
        printExecExample()
        process.exit(1)
    }

    if (!options.projectId) {
        console.error("ProjectId missing.")
        printExecExample()
        process.exit(1)
    }

    if (!options.toLocale) {
        console.error("Missing translation locale.")
        printExecExample()
        process.exit(1)
    }
}

function requestQuote(cb) {
    console.log("Requesting Quote...")
    onesky.getQuotation(options).then(function(content){
        var result = JSON.parse(content)
        if (result.meta.status != 200) {
            console.error("Failed to request quote")
            console.log(result)
            process.exit(1)
        }

        console.log([
            '',
            "Translation Quote " + result.data.from_language.code + " → " + result.data.to_language.code,
            "Files: " + JSON.stringify(result.data.files),
            '',
            'Translation Only',
            'Cost: $' + result.data.translation_only.total_cost,
            'Estimated Completion Date: ' + result.data.translation_only.will_complete_at,
            '',
            'Translation & Review',
            'Cost: $' + result.data.translation_and_review.total_cost,
            'Estimated Completion Date: ' + result.data.translation_and_review.will_complete_at,
            '',
            'Review Only',
            'Cost: $' + result.data.review_only.total_cost,
            'Estimated Completion Date: ' + result.data.review_only.will_complete_at
        ].join('\n'))
        cb()
    }).catch(function(error){
        console.log(error)
        process.exit(1)
    })
}

function createOrder() {
    console.log("Creating Translation Order...")
    console.log(options)
    onesky.createOrder(options).then(function(content){
        var result = JSON.parse(content)
        if (result.meta.status != 201) {
            console.error("Failed to create order")   
            console.log(result)         
            process.exit(1)
        }

        console.log([
            '',
            "Translation Order Created! " + result.data.from_language.code + " → " + result.data.to_language.code,,
            "Order ID: " + result.data.id,
            "Files: " + JSON.stringify(result.data.files),
            "Order Type:" + result.data.order_type
        ].join('\n'))
        process.exit()
    }).catch(function(error){
        console.error("Failed to create order") 
        console.log(error)
        process.exit(1)
    })
}

readCLIArguments()
requestQuote( function (){
    if (!options.quoteOnly) {
        createOrder()
    }
})