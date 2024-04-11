# KNOXSSer
A concise and effective bash script for mass XSS scanning utilizing the KN0X55 API by Brute Logic.
![KNOXSSer](https://github.com/0xPugal/KNOXSSer/blob/master/knoxsser.png)

## Usage
```
Usage: knoxsser.sh [OPTIONS]
Options:
  -i, --input     Input file containing URLs to scan
  -o, --output    Output file to save XSS results (default: xss.txt)
  -A, --api       API key for Knoxss
  -h, --help      Display this help message
  ```
+ ``./KNOXSSer.sh -i input.txt``
![poc](https://github.com/0xPugal/KNOXSSer/assets/75373225/6c5eaa15-c781-4f83-abdf-127b336a08d5)
>Successfull XSS will be stored in xss.txt by default with full json reponse

## ToDo
+ Add Parallel scan functionality
+ Properly handle and print error messages from KNOXSS API

## Credits
+ An amazing [KNOXSS](https://knoxss.me/) API by Brute Logic.
+ This script was inspired by the [knoxnl](https://github.com/xnl-h4ck3r/knoxnl) tool by [xnl_h4ck3r](https://twitter.com/xnl_h4ck3r).
