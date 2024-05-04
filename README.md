# KNOXSSer
**A concise and effective bash script for mass XSS scanning utilizing the KN0X55 API by Brute Logic**

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
  -n, --nofify    Send notifications on successfull XSSes via notify
  -h, --help      Display this help message and exit
  -v, --version   Display the version and exit
```

## Features
   - Enables scanning of both single URLs and files containing multiple URLs
   - Unscanned URLs are saved in a `<input>+date-time.todo` file, providing a record of URLs not successfully scanned along with a timestamp.
   - URLs that encountered timeouts or errors during scanning, possibly due to issues with the KNOXSS API, are saved in a `<input>-errors.todo` file. 
   - Successful XSS results are saved by default in `xss.txt`, with their full JSON responses.
   - Prints the number of API calls made during the scanning process.
   - Send notifications on successful XSSes through notify

## Usage
> Configure your [knoxss api key](https://knoxss.me/) in [line 30 of knoxsser](https://github.com/0xPugal/KNOXSSer/blob/master/knoxsser#L30) or pass the API key with ``-A`` argument.

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
![knoxsser](https://github.com/0xPugal/KNOXSSer/assets/75373225/2e9878f5-d81c-479b-9be2-4ab52c3c62cf)

## ToDo
+ Add Parallel scan functionality
+ Properly handle and print error messages from KNOXSS API
+ Allow knoxsser to read input from stdin
+ Add verbose option for verbose output
+ Prints if the provided API key is valid or not and fix the parse error

## Credits
+ An amazing [KNOXSS](https://knoxss.me/) API by Brute Logic.
+ This script was inspired from the [knoxnl](https://github.com/xnl-h4ck3r/knoxnl) tool by [xnl_h4ck3r](https://twitter.com/xnl_h4ck3r).
+ Send Notification via [Project Discovery](https://github.com/projectdiscovery)'s [Notify](https://github.com/projectdiscovery/notify) 
