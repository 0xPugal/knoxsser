# KNOXSSer v1.1

[![made-with-bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)](https://www.gnu.org/software/bash/) [![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://GitHub.com/Naereen/StrapDown.js/graphs/commit-activity) [![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://lbesson.mit-license.org/) [![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com) [![Open Source Love svg1](https://badges.frapsoft.com/os/v1/open-source.svg?v=103)](https://github.com/ellerbrock/open-source-badges/) [![Latest release](https://badgen.net/github/release/Naereen/Strapdown.js)](https://github.com/0xPugal/KNOXSSer/releases)


**A concise and effective bash script for mass XSS scanning utilizing the KNOXSS API by Brute Logic**

<img src=KNOXSSer.png>

## Installation
```
curl -sSL https://raw.githubusercontent.com/0xPugal/KNOXSSer/master/knoxsser -o knoxsser && chmod +x knoxsser && sudo mv knoxsser /usr/bin/
```

## Help
```
Options:
  -i, --input     Input file containing URLs or single URL to scan
  -o, --output    Output file to save XSS results (default: xss.txt)
  -A, --api       API key for Knoxss
  -s, --silent    Print only results without displaying the banner
  -n, --notify    Send notifications on successful XSSes via notify
  -p, --process   Number of URLs to scan parallely (1-5) (default: 1)
  -h, --help      Display this help message and exit
  -v, --version   Display the version and exit
```

## Features
   - Enables scanning of both single URLs and files containing multiple URLs
   - Unscanned URLs are saved in a `<input>+date-time.todo` file, providing a record of URLs not successfully scanned along with a timestamp.
   - URLs that encountered timeouts or errors during scanning, possibly due to issues with the KNOXSS API, are saved in a `<input>.errors` file. 
   - Successful XSS results are saved by default in `xss.txt`, with their full JSON responses.
   - Prints the number of API calls made during the scanning process.
   - Send notifications on successful XSSes through notify
   - Parallel scans options for faster scan completion

## Usage
> Configure your [knoxss api key](https://knoxss.me/) in [line 30 of knoxsser](https://github.com/0xPugal/KNOXSSer/blob/master/knoxsser#L30) or pass the API key with ``-A`` argument. (Required)

> By default XSS outputs are saved in xss.txt or you can specify the custom output file

> [Notify](https://github.com/projectdiscovery/notify) must be installed on your system, to send notifications on sucessful xss. Use ``--notify`` to send notifications

+ Single URL scan
```
knoxsser -i https://brutelogic.com.br/xss.php?a=1
```
+ Scan a list of URLs
```
knoxsser -i urls.txt
```
+ Send the notification on successful xss through notify
```
knoxsser -i input.txt --notify
```
![knoxsser](https://github.com/0xPugal/KNOXSSer/assets/75373225/0b97af75-e1c8-410c-b4d3-8a555f0bb599)


## ToDo
+ Allow knoxsser to read input from stdin
+ Add verbose option for verbose output

## Credits
+ An amazing [KNOXSS](https://knoxss.me/) API by Brute Logic.
+ This script was inspired from the [knoxnl](https://github.com/xnl-h4ck3r/knoxnl) tool created by [xnl_h4ck3r](https://twitter.com/xnl_h4ck3r).
+ Notification on successful XSS via [Project Discovery](https://github.com/projectdiscovery)'s [Notify](https://github.com/projectdiscovery/notify).
