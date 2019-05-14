# TwineDemo
A QuickStart for Twine. Used for demonstration only. Feel free to use as a playground to try out Twine!

## Twine Library
All documentation for Twine can be found [here](https://github.com/scelis/twine)

## Getting Started
Checkout this repository and install Twine from the root directory of the repo
```shell
$> bundle install
```

### Twine Files
For the purpose of this demo, the text files containing the string definitions in [Twine Format](https://github.com/scelis/twine#example) can be found under the *QuickTest* folder.

#### Example Twine File
~~~~
[[Login Errors]]
	[Errors_Authentication_Expired]
		en = Your credentials have expired. Please login again.
	[Errors_Authentication_Fail_Reason]
		en = This Username / Password combination does not match our records.
	[Errors_Service_Unreachable_Reason]
		en = Uh oh! Something went wrong! Try again later.
		comment = Generic sentence to indicate something went wrong when our servers are unreachable. Don't translate "Uh oh!".
~~~~

## Scripts
*Swift* scripts have been created to faciliate & automate Twine usage. The current demo setup allows for you to create multiple Twine files in the directory structure and in subdirectories.
The *generate<Platform>.swift* scripts simply combine the Twine files appropriate for the platform into 1 temporarily to generate the localization file with Twine.

### Generating Localization
Running the generate scripts will create the appropriate folder structure and files per language in the Resources folder.

#### Cloud
```shell
$> swift generateCloud.swift
```
This will generate a JSON file per language provided in your Twine files.

#### Portal
```shell
$> swift generatePortal.swift
```
This will generate a JSON file per language provided in your Twine files.

#### iOS
```shell
$> swift generateiOS.swift
```
This will generate a Apple Strings file per language provided in your Twine files.

### Exporting To Translation Service
```shell
$> swift exportForTranslation.swift
```
This will combine all Twine files in the *QuickTest* directory and generate a ZIP file containing a strings file that can be sent to a translation service.
A validation step is also executed prior to creating the ZIP that will check for invalid characters or duplicate key definitions.

### Importing A Translation
The demo provides a a quick French translation of the current contents that are stored in the Twine files. 
Assuming the translation service used the file created in the Export step highlighted above, use the translated file from the translation service and import it into your Twine files.
```shell
$> swift importTranslations.swift ../DemoTranslations/fr.strings fr
```

This script will look for matching keys in the translated file and update the Twine files accordingly, either adding the translation for a key or updating it.
If a key is not defined in a Twine file it will not create it.

#### Example Updated Twine File With Translation
~~~~
[[Login Errors]]
	[Errors_Authentication_Expired]
		en = Your credentials have expired. Please login again.
    		fr = Votre session a expiré. Veuillez vous réidentifier.
	[Errors_Authentication_Fail_Reason]
		en = This Username / Password combination does not match our records.
    		fr = Cette combinaison nom d'utilisateur / mot de passe ne correspond pas à nos enregistrements.
	[Errors_Service_Unreachable_Reason]
		en = Uh oh! Something went wrong! Try again later.
		comment = Generic sentence to indicate something went wrong when our servers are unreachable. Don't translate "Uh oh!".
    		fr = Uh oh! Quelque chose s'est mal passé! Réessayez plus tard.
~~~~

