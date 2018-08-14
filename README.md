# What's this
A simple script which dumps G Suite groups (mailing list) to JSON(machine-readable) and CSV(Excel-Readable) files.

# Preparation
## Create a Google Cloud project
Create a project on new Google Cloud Platform.

## Activate API
Activate "Groups Settings API".

## Create credentials
Create a new OAuth Client ID. You need both of client Id and client secret.

## Get token
Execute this:
`ruby authorize.rb <filename.json>` (filename is optional)

You'll be asked to input client id and client secret and get a URL. Open it with your web-browswer and you'll get an authrorization code. Return to the console and paste it.

These actions finally end up with a credentials file. It contains:

* client Id
* client secret
* refresh token

This is all you need to access Google API. The refresh token can generate a fresh token ANYTIME, and the refresh token NEVER expires, so you have to store it in a safe vault.

# Dump
Execute this:
`ruby dump.rb <your-domain.com> <filename.json>` (domain is required, filename is optional)

All the groups hosted on your G Suite domain will be dumped to:

* `dump_DOMAINNAME.json`
* `dump_DOMAINNAME_1.csv`
* `dump_DOMAINNAME_2.csv`

CSV files have two different formats.
