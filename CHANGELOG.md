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
