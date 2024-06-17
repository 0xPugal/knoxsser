+ v1.5
    - Add retry options for ``target connection issues`` and ``can't finish scan gracefully`` (default: 1)"
    - Add verbose output for all responses from knoxss api

+ v1.4
    - Add verbose mode for all reponses
    - Add silent mode option also for count_targets

+ v1.3
    - Print Service unavailable message form KNOXSS API
    - Add verbose mode also for Unknown errors
    - Add urlencode for ``+`` to ``%2B``

+ v1.2
    - Add verbose option for printing response from knoxss api in the terminal

+ v1.1
    - Add ``Ctrl-C`` option to stop the scan and save remaining urls in a ``todo_file``
    - Modify script to save urls which encounter erros due to error in knoxss api are saved in ``{urls_file}.error`` file
    - Beautify the way of printing output from knoxss in terminal

+ v1.0
    - Temporarily removed ``Ctrl-C`` option to stop and save remaining urls due to some errors
    - Temporarily removed ``$api_calls`` option due to some errors

+ v0.9
    - Add parallel scan functionality
    - Prints number of urls are in a input file to scan

+ v0.8
    - Fix the error of printing the url in unknown error
    - Change the ``error_url`` to ``todo_file`` to save the both unscanned urls and error urls
+ v0.7
    - Fix the json jq parse error while the url content type is not vulnerable to xss
    - Fix the json parse error when the provided api key is invalid

+ v0.6
    - Send notifications on successfull XSSes via notify
    - Beautify the way of printing output from knoxss in terminal

+ v0.5
    - Properly prints the error messages
      1. ``ERROR: Content type of target page can't lead to XSS!`` -> XSS not possible
      2. ``target connection issues (timeout)`` -> Target timeout

+ v0.4
    - Fix the false positive in API calls. It count increment only happens if the "API Call" field is not "0"
    - URLs which encountered errors are saved into ``${urls_file%.*}-errors.todo`` file
+ v0.3
    - Add option to scan single url
    - Decrease the ``sleep 10`` to 2 seconds to speed up the scan
    - Add option to print only results without printing banner(``-s/--silent``)

+ v0.2
    - Remove Scanning URL...
    - Prints only successfull XSS in output file
    - Add version number
    - Add ``sleep 10`` 10 seconds delay between each request to overwhelming the server or getting rate-limited

+ v0.1
    - Initial release
