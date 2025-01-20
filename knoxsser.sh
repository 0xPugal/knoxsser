#!/usr/bin/env bash

CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BOLD='\033[1m'
NC='\033[0m'

print_banner() {
    echo ""
    echo -e "${CYAN}██╗  ██╗███╗   ██╗ ██████╗ ██╗  ██╗███████╗███████╗███████╗██████╗  ${NC}"
    echo -e "${CYAN}██║ ██╔╝████╗  ██║██╔═══██╗╚██╗██╔╝██╔════╝██╔════╝██╔════╝██╔══██╗ ${NC}"
    echo -e "${CYAN}█████╔╝ ██╔██╗ ██║██║   ██║ ╚███╔╝ ███████╗███████╗█████╗  ██████╔╝ ${NC}"
    echo -e "${CYAN}██╔═██╗ ██║╚██╗██║██║   ██║ ██╔██╗ ╚════██║╚════██║██╔══╝  ██╔══██╗ ${NC}"
    echo -e "${CYAN}██║  ██╗██║ ╚████║╚██████╔╝██╔╝ ██╗███████║███████║███████╗██║  ██║ ${NC}"
    echo -e "${CYAN}╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝$VERSION ${NC}"
    echo -e "                                        Made with ${RED}${BOLD}<3${NC} by${BOLD} @0xPugal    ${NC}"
    echo ""
}

target_count() {
    if ! $silent_mode; then
        echo -e "${BOLD}Scanning $(wc -l < "$urls_file") urls for XSS...${NC}\n"
    fi
}

if [[ $# -eq 0 ]]; then
    print_banner
    exit 0
fi

# Default values
input_type="file"
input_file=""
api_key="KNOXSS_API_KEY"
output_file="xss.txt"
VERSION="v1.7"
silent_mode=false
use_notify=false
parallel_processes=3
verbose_mode=false
retry_count=2
unknown_error_log="error.log"

usage() {
    print_banner
    echo "Options:"
    echo "  -i, --input     Input file containing URLs or single URL to scan"
    echo "  -o, --output    Output file to save XSS results (default: xss.txt)"
    echo "  -A, --api       API key for Knoxss"
    echo "  -s, --silent    Print only results without displaying the banner and target count"
    echo "  -n, --notify    Send notifications on successful XSSes via notify"
    echo "  -p, --process   Number of URLs to scan parallely(1-5) (default: 3)"
    echo "  -r, --retry     Number of times to retry on target connection issues & can't finish scans (default: 1)"
    echo "  -v, --version   Display the version and exit"
    echo "  -V, --verbose   Enable verbose output"
    echo "  -h, --help      Display this help message and exit"
    exit 1
}

# Parsing command-line arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -i|--input)
            input="$2"
            if [[ -f "$input" ]]; then
                input_type="file"
                input_file="$input"
            else
                input_type="url"
                single_url="$input"
                single_url=$(echo "$single_url" | sed 's/&/%26/g')
                single_url=$(echo "$single_url" | sed 's/+/%2B/g')
            fi
            shift
            shift
            ;;
        -o|--output)
            output_file="$2"
            shift
            shift
            ;;
        -A|--api)
            api_key="$2"
            shift
            shift
            ;;
        -s|--silent)
            silent_mode=true
            shift
            ;;
        -n|--notify)
            use_notify=true  
            shift
            ;;
        -p|--process)
            parallel_processes="$2"
            shift
            shift
            ;;
        -r|--retry)
            retry_count="$2"
            shift
            shift
            ;;
        -v|--version)
            echo "Version: ${VERSION}"
            exit 0
            ;;
        -V|--verbose)
            verbose_mode=true
            shift
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Error: Unknown option: $1"
            usage
            ;;
    esac
done

# Validations for required arguments
if [[ "$input_type" == "file" && -z "$input_file" ]]; then
    echo "Error: Input file not specified"
    usage
elif [[ "$input_type" == "url" && -z "$single_url" ]]; then
    echo "Error: Single URL not specified"
    usage
fi

# Set up URLs for scanning based on input type
if [[ "$input_type" == "file" ]]; then
    sed -i 's/&/%26/g' "$input_file"
    sed -i 's/+/%2B/g' "$input_file"
    urls_file="$input_file"
else
    urls_file=$(mktemp)
    echo "$single_url" > "$urls_file"
fi

# Function to handle Ctrl-C interruptions
handle_ctrl_c() {
    echo -e "\n${BOLD}Ctrl-C detected. Remaining Unscanned URLs are saved into $todo_file${NC}"
    grep -vFf "$processed_file" "$urls_file" > "$todo_file"
    rm -f "$processed_file" 
    exit 1
}

# Set up Ctrl-C handler
trap handle_ctrl_c INT

lineno=1
api_calls=0
todo_file="${urls_file}-$(date +'%Y%m%d%H%M%S').todo"
processed_file="${urls_file}-$(date +'%Y%m%d%H%M%S').processed"

# Displaying banner and target count
if ! $silent_mode; then
    print_banner
    target_count
fi

# Main loop to scan URLs
process_url() {
    local line="$1"
    local lineno="$2"
    local retries=0
    
    while [[ $retries -lt $retry_count ]]; do
        response=$(curl "https://api.knoxss.pro" -d target="$line" -H "X-API-KEY: $api_key" -s)

        if [[ "$response" == *"Invalid or expired API key."* ]]; then
            echo -e "${RED}Invalid or expired API key. Exiting.${NC}"
            if $verbose_mode; then
                echo -e "${BOLD}Verbose response from KNOXSS API:${NC}"
                echo "$response"
            fi
            exit 1
        
        elif [[ "$response" == *"<p"* ]]; then
            echo -e "${YELLOW}[ NOPE/ ] - $line - [XSS is not possible in this content-type]${NC} [0]"
            if $verbose_mode; then
                echo -e "${BOLD}Verbose response from KNOXSS API:${NC}"
                echo "$response"
            fi
            break
        
        else
            xss=$(jq -r '.XSS' <<< "$response")
            poc=$(jq -r '.PoC' <<< "$response")
            error=$(jq -r '.Error' <<< "$response")
            api_call=$(jq -r '.["API Call"]' <<< "$response")
            time_elapsed=$(jq -r '.["Time Elapsed"]' <<< "$response")
            timestamp=$(jq -r '.Timestamp' <<< "$response")
            version=$(jq -r '.Version' <<< "$response")

            # Handle XSS detection
            if [[ "$xss" == "true" ]]; then
                echo -e "${GREEN}${BOLD}[ XSS!! ] - $poc ${NC} [$api_call]"
                echo "$response" >> "$output_file"

                if [[ "$use_notify" == true ]]; then
                    echo "$poc" | notify -silent > /dev/null 2>&1 
                    if [[ "$api_call" != "0" ]]; then
                        api_calls=$((api_calls + 1))
                    fi
                fi
                if $verbose_mode; then
                    echo -e "${BOLD}Verbose response from KNOXSS API:${NC}"
                    echo "$response" | jq .
                fi
                break

            elif [[ "$xss" == "false" ]]; then
                echo -e "${YELLOW}[ noXSS ] - $line ${NC} [$api_call]"
                if [[ "$api_call" != "0" ]]; then
                    api_calls=$((api_calls + 1))
                fi
                if $verbose_mode; then
                    echo -e "${BOLD}Verbose response from KNOXSS API:${NC}"
                    echo "$response" | jq .
                fi
                break

            elif [[ "$error" == "KNOXSS can't test it (forbidden)" ]]; then
                echo -e "${RED}[ 403:( ] - $line - [$error]${NC} [$api_call]"
                if $verbose_mode; then
                    echo -e "${BOLD}Verbose response from KNOXSS API:${NC}"
                    echo "$response" | jq .
                fi
                break

            elif [[ "$error" == "target connection issues (timeout)" || "$error" == "KNOXSS can't finish scan gracefully (reason unknown)" || "$error" == "KNOXSS engine failed at some point, please retry" || "$error" == "KNOXSS PoC attempt got no response from target, please retry" || "$error" == "Expiration time reset, please try again." ]]; then
                retries=$((retries + 1))
                if [[ $retries -lt $retry_count ]]; then
                    echo -e "${RED}[ ERROR ] - $line - [${error}]Retrying... (${retries}/${retry_count})${NC}"
                    sleep 2  # Adding a small delay before retrying
                else
                    echo -e "${RED}[ ERROR ] - $line - [${error}]${NC} [$api_call]"
                fi
                if $verbose_mode; then
                    echo -e "${BOLD}Verbose response from KNOXSS API:${NC}"
                    echo "$response" | jq .
                fi

            elif [[ "$error" == "service unavailable" ]]; then
                echo -e "${RED}[ ERROR ] - $line - [Service Unavailable]${NC} [$api_call]"
                echo -e "$line" >> "$todo_file"
                if $verbose_mode; then
                    echo -e "${BOLD}Verbose response from KNOXSS API:${NC}"
                    echo "$response" | jq .
                fi
                break

            elif [[ "$error" == "API rate limit exceeded." ]]; then
                echo -e "${RED}[ ERROR ] - $line - [API rate limit exceeded]${NC} [$api_call]"
                echo -e "$line" >> "$todo_file"
                if $verbose_mode; then
                    echo -e "${BOLD}Verbose response from KNOXSS API: ${NC}"
                    echo "$response" | jq .
                fi
                break

            elif [[ "$error" == "not allowed" ]]; then
                echo -e "${RED}[ ERROR ] - $line - [Not Allowed]${NC} [$api_call]"
                echo -e "$line" >> "$todo_file"
                if $verbose_mode; then
                    echo -e "${BOLD}Verbose response from KNOXSS API: ${NC}"
                    echo "$response" | jq .
                fi
                break

            else
                echo -e "${RED}[ ERROR ] - $line - [Unknown Error]${NC} [$api_call]"
                echo "$line" >> "$todo_file"
                echo "$response" >> "$unknown_error_log"
                if $verbose_mode; then
                    echo -e "${BOLD}Verbose response from KNOXSS API:${NC}"
                    echo "$response" | jq .
                fi
                break
            fi
        fi
    done

    echo "$line" >> "$processed_file"
}

# Setup for parallel processing
export -f process_url
export api_key output_file use_notify todo_file processed_file unknown_error_log verbose_mode CYAN GREEN RED YELLOW BOLD NC retry_count

# Start processing URLs in parallel
parallel -j "$parallel_processes" process_url :::: "$urls_file"

# Final summary
if [[ -s "$todo_file" ]]; then
    echo -e "\n${BOLD}Some URLs encountered errors and are saved into $todo_file${NC}"
fi

if [[ -s "$unknown_error_log" ]]; then
    echo -e "\n${BOLD}Some URLs encountered unknown errors and their responses are saved into $unknown_error_log${NC}"
fi

rm -f "$processed_file"
