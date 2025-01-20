# KNOXSSer v1.7

**An powerful bash script for massive XSS scanning leveraging [Brute Logic's](https://brutelogic.com.br/blog/about) [KNOXSS API](https://knoxss.pro)**

[![made-with-bash](https://img.shields.io/badge/Made%20with-Bash-1f425f.svg)](https://www.gnu.org/software/bash/) [![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://GitHub.com/0xPugal/KNOXSSer/graphs/commit-activity) [![MIT license](https://img.shields.io/badge/License-MIT-blue.svg)](https://lbesson.mit-license.org/) [![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com) [![Latest release](https://badgen.net/github/release/0xPugal/KNOXSSer?sort=semver&label=version)](https://github.com/0xPugal/KNOXSSer/releases) [![Open Source Love svg1](https://badges.frapsoft.com/os/v1/open-source.svg?v=103)](https://github.com/0xPugal/KNOXSSer)


![image](https://github.com/0xPugal/knoxsser/assets/75373225/b2219d21-d8d0-4b6a-8005-e402e0148964)


## Installation
```
curl -sSL https://raw.githubusercontent.com/0xPugal/knoxsser/master/knoxsser.sh -o knoxsser.sh && chmod +x knoxsser.sh && sudo mv knoxsser.sh /usr/bin/knoxsser
```

## Prerequisites
> jq and parallel must be installed in your system to run this tool
  + Debian based Distros - ``sudo apt install -y curl jq parallel``
  + RedHat based Distros - ``dnf install curl jq parallel``
  + Arch based Distros - ``pacman -S curl jq parallel``
  + Mac OS - ``brew install jq parallel``
> Configure your knoxss api key in [line 36 of knoxsser](https://github.com/0xPugal/knoxsser/blob/master/knoxsser.sh#L36) or pass the API key with ``-A`` argument.


> [Notify](https://github.com/projectdiscovery/notify) must be installed on your system, to send notifications on sucessful xss.(optional)


## Help
```
Options:
  -i, --input     Input file containing URLs or single URL to scan
  -o, --output    Output file to save XSS results (default: xss.txt)
  -A, --api       API key for Knoxss
  -s, --silent    Print only results without displaying the banner and target count
  -n, --notify    Send notifications on successful XSSes via notify
  -p, --process   Number of URLs to scan parallely(1-5) (default: 3)
  -r, --retry     Number of times to retry on target connection issues and can't finish scans"
  -v, --version   Display the version and exit
  -V, --verbose   Enable verbose output
  -h, --help      Display this help message and exit
```

## Features
   - Enables scanning of both single URLs and files containing multiple URLs
   - Unscanned / Remaining URLs and URLs that encountered errors  are saved in a `<input>+date-time.todo` file, providing a record of URLs not successfully scanned along with a timestamp.
   - Ability to stop the scan and save the remaining URLs in a `<input>+date-time.todo` file.
   - Successful XSS results are saved by default in `xss.txt`, with their full JSON responses, and `error.log` file for further investigation for Unknown Errors.
   - Ability to retry the scan, if any error like `Connection issues` or `can't able to scan by knoxss`
   - Prints the API calls number along with the scanning process.
   - Send notifications on successful XSSes through notify
   - Parallel scans options for faster scan completion
   - Verbose option functionality for printing response from knoxss api in the terminal

## Usage
```
# All in one
  knoxsser -i input.txt -p 3 -n -V -r 2 -o knoxss.txt

# Single URL scan
  knoxsser --input https://brutelogic.com.br/xss.php?a=1

# Scan a list of URLs
  knoxsser --input urls.txt

# Send the notification on successful xss through notify
  knoxsser --input input.txt --notify

# Verbose option functionality
  knoxsser --input input.txt --verbose

# Parallel scan process
  knoxsser --input input.txt --process 3
```

## ToDo
+ Allow knoxsser to read input from stdin
+ Stop the scan on `Invalid or Expired API Key` and `API rate limit exceeded` and save the urls in `<input>-date-time.todo` file

## Credits
+ An amazing [KNOXSS](https://knoxss.pro) API by Brute Logic.
+ This script was inspired from the [knoxnl](https://github.com/xnl-h4ck3r/knoxnl) tool created by [xnl_h4ck3r](https://twitter.com/xnl_h4ck3r).

> [!CAUTION]
> ⚠️ Disclaimer: I am not responsible for any use, and especially misuse, of this tool or the KNOXSS API
