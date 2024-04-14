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
  -A, --api       Pass the KNOXSS API key
  -s, --silent    Print only results without displaying the banner
  -h, --help      Display this help message and exit
  -v, --version   Display the version and exit
```

## Usage
> Configure your [KNOXSS API KEY](https://knoxss.me/) in [KNOXSSer](https://github.com/0xPugal/KNOXSSer/blob/master/knoxsser#L30) or pass the API key with ``-A`` argument.

> By default XSS outputs are saved in xss.txt or you can specify the custom output file
+ Single URL scan
```
knoxsser -i https://brutelogic.com.br/xss.php?a=1 -A API_KEY
```
+ Scan a list of URLs
```
knoxsser -i urls.txt -A API_KEY
```

![poc2](https://github.com/0xPugal/KNOXSSer/assets/75373225/cca324aa-5c35-4018-9e7d-d87a524a31b1)
![poc](https://github.com/0xPugal/KNOXSSer/assets/75373225/c12f5b38-f668-4e9f-8c1e-28cda061defc)

## ToDo
+ Add Parallel scan functionality
+ Properly handle and print error messages from KNOXSS API
+ Add knoxsser to read input from stdin
+ Add option to save the urls which are timedout and skipped due to errors in knoxss api

## Credits
+ An amazing [KNOXSS](https://knoxss.me/) API by Brute Logic.
+ This script was inspired from the [knoxnl](https://github.com/xnl-h4ck3r/knoxnl) tool by [xnl_h4ck3r](https://twitter.com/xnl_h4ck3r).
