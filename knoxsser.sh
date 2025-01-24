#!/usr/bin/env bash

# Color codes for output
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Script version and URLs
VERSION="v2.0"
REPO_URL="https://raw.githubusercontent.com/0xPugal/knoxsser/master/VERSION"
SCRIPT_URL="https://raw.githubusercontent.com/0xPugal/knoxsser/master/knoxsser.sh"
SCRIPT_PATH="/usr/bin/knoxsser"

# Function to print the banner
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

# Function to check for script updates
check_version() {
    latest_version=$(curl -s "$REPO_URL")
    if [[ "$VERSION" != "$latest_version" ]]; then
        echo -e "${YELLOW}Your script is outdated. Latest version is ${latest_version}.${NC}"
        read -p "${BOLD}Do you want to update to the latest version? (Y/N):${NC} " update_choice
        if [[ "$update_choice" =~ ^[Yy]$ ]]; then
            echo -e "${YELLOW}Updating KNOXSSer...${NC}"
            
            # Remove existing knoxsser script if it exists
            if command -v knoxsser &>/dev/null; then
                echo -e "${YELLOW}Removing existing knoxsser script...${NC}"
                sudo rm -f "$(which knoxsser)"
            fi
            
            # Download and update to the latest version
            curl -sSL "$SCRIPT_URL" -o knoxsser.sh && chmod +x knoxsser.sh && sudo mv knoxsser.sh "$SCRIPT_PATH"
            echo -e "${GREEN}${BOLD}KNOXSSer updated!!!${NC}"
            echo -e "${YELLOW}Reminder: Make sure to set the API key in the knoxsser file (updating overwrites the knoxsser file), or pass it with the -A argument.${NC}"
            exit 0
        fi
    else
        echo -e "${GREEN}Your script is up-to-date.${NC}"
    fi
}

# Function to display the number of targets
target_count() {
    if ! $silent_mode; then
        echo -e "${BOLD}Scanning $(wc -l < "$urls_file") URLs for XSS...${NC}\n"
    fi
}

# Exit if no arguments are provided
if [[ $# -eq 0 ]]; then
    print_banner
    exit 0
fi

# Default values
input_type="file"
input_file=""
api_key="KNOXSS_API_KEY"
output_file="xss.txt"
silent_mode=false
use_notify=false
parallel_processes=3
verbose_mode=false
retry_count=2
retry_interval=15
unknown_error_log="error.log"
cookies=""
post_data=""

# Function to display usage
usage() {
    print_banner
    echo "Options:"
    echo "  -i,  --input            Input file containing URLs or single URL to scan"
    echo "  -o,  --output           Output file to save XSS results (default: xss.txt)"
    echo "  -A,  --api              API key for Knoxss"
    echo "  -s,  --silent           Print only results without displaying the banner and target count"
    echo "  -n,  --notify           Send notifications on successful XSSes via notify"
    echo "  -p,  --process          Number of URLs to scan in parallel (1-5) (default: 3)"
    echo "  -r,  --retry            Number of times to retry on target connection issues & can't finish scans (default: 1)"
    echo "  -ri, --retry-interval   Seconds to wait before retrying when having issues connecting to the KNOXSS API (default: 15)"
    echo "  -v,  --version          Display the version and exit"
    echo "  -V,  --verbose          Enable verbose output"
    echo "  -h,  --help             Display this help message and exit"
    echo "  -c,  --cookies          Cookies for authenticated GET requests"
    echo "  -pd, --postdata         POST data for POST requests"
    exit 1
}

# Parse command-line arguments
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
        -ri|--retry-interval)
            retry_interval="$2"
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
        -c|--cookies)
            cookies="$2"
            shift
            shift
            ;;
        -pd|--postdata)
            post_data="$2"
            shift
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

# Validate required arguments
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
    echo -e "\n${BOLD}Ctrl-C detected. Remaining unscanned URLs are saved into $todo_file${NC}"
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

# Display banner and target count
if ! $silent_mode; then
    print_banner
    check_version
    target_count
fi

# Function to process URLs
process_url() {
    local line="$1"
    local lineno="$2"
    local retries=0
    
    while [[ $retries -lt $retry_count ]]; do
        if [[ -n "$cookies" ]]; then
            response=$(curl "https://api.knoxss.pro" -d "target=$line&auth=Cookie:$cookies" -H "X-API-KEY: $api_key" -s)
        elif [[ -n "$post_data" ]]; then
            response=$(curl "https://api.knoxss.pro" -d "target=$line&post=$post_data" -H "X-API-KEY: $api_key" -s)
        else
            response=$(curl "https://api.knoxss.pro" -d "target=$line" -H "X-API-KEY: $api_key" -s)
        fi

        if [[ "$response" == *"Invalid or expired API key."* ]]; then
            echo -e "${RED}Invalid or expired API key. Exiting.${NC}"
            if $verbose_mode; then
                echo -e "${BOLD}Verbose response from KNOXSS API:${NC}"
                echo "$response"
            fi
            # Save remaining URLs to .todo file
            grep -vFf "$processed_file" "$urls_file" >> "$todo_file"
            exit 1
        
        elif [[ "$response" == *"API rate limit exceeded."* ]]; then
            echo -e "${RED}API rate limit exceeded. Exiting.${NC}"
            if $verbose_mode; then
                echo -e "${BOLD}Verbose response from KNOXSS API:${NC}"
                echo "$response"
            fi
            # Save remaining URLs to .todo file
            grep -vFf "$processed_file" "$urls_file" >> "$todo_file"
            exit 1
        
        elif [[ "$response" == *"service unavailable"* ]]; then
            echo -e "${RED}Service unavailable. Exiting.${NC}"
            if $verbose_mode; then
                echo -e "${BOLD}Verbose response from KNOXSS API:${NC}"
                echo "$response"
            fi
            # Save remaining URLs to .todo file
            grep -vFf "$processed_file" "$urls_file" >> "$todo_file"
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

            elif [[ "$error" == "target connection issues (timeout)" ]]; then
                retries=$((retries + 1))
                if [[ $retries -lt $retry_count ]]; then
                    echo -e "${RED}[ ERROR ] - $line - [Target connection issues (timeout)] Retrying in ${retry_interval} seconds... (${retries}/${retry_count})${NC}"
                    sleep "$retry_interval"
                else
                    echo -e "${RED}[ ERROR ] - $line - [Target connection issues (timeout)]${NC} [$api_call]"
                    echo "$line" >> "$todo_file"
                fi
                if $verbose_mode; then
                    echo -e "${BOLD}Verbose response from KNOXSS API:${NC}"
                    echo "$response" | jq .
                fi

            elif [[ "$error" == "KNOXSS can't finish scan gracefully (reason unknown)" ]]; then
                retries=$((retries + 1))
                if [[ $retries -lt $retry_count ]]; then
                    echo -e "${RED}[ ERROR ] - $line - [KNOXSS can't finish scan gracefully (reason unknown)] Retrying in ${retry_interval} seconds... (${retries}/${retry_count})${NC}"
                    sleep "$retry_interval"
                else
                    echo -e "${RED}[ ERROR ] - $line - [KNOXSS can't finish scan gracefully (reason unknown)]${NC} [$api_call]"
                    echo "$line" >> "$todo_file"
                fi
                if $verbose_mode; then
                    echo -e "${BOLD}Verbose response from KNOXSS API:${NC}"
                    echo "$response" | jq .
                fi

            elif [[ "$error" == "KNOXSS engine failed at some point, please retry" ]]; then
                retries=$((retries + 1))
                if [[ $retries -lt $retry_count ]]; then
                    echo -e "${RED}[ ERROR ] - $line - [KNOXSS engine failed at some point, please retry] Retrying in ${retry_interval} seconds... (${retries}/${retry_count})${NC}"
                    sleep "$retry_interval"
                else
                    echo -e "${RED}[ ERROR ] - $line - [KNOXSS engine failed at some point, please retry]${NC} [$api_call]"
                    echo "$line" >> "$todo_file"
                fi
                if $verbose_mode; then
                    echo -e "${BOLD}Verbose response from KNOXSS API:${NC}"
                    echo "$response" | jq .
                fi

            elif [[ "$error" == "KNOXSS PoC attempt got no response from target, please retry" ]]; then
                retries=$((retries + 1))
                if [[ $retries -lt $retry_count ]]; then
                    echo -e "${RED}[ ERROR ] - $line - [KNOXSS PoC attempt got no response from target, please retry] Retrying in ${retry_interval} seconds... (${retries}/${retry_count})${NC}"
                    sleep "$retry_interval"
                else
                    echo -e "${RED}[ ERROR ] - $line - [KNOXSS PoC attempt got no response from target, please retry]${NC} [$api_call]"
                    echo "$line" >> "$todo_file"
                fi
                if $verbose_mode; then
                    echo -e "${BOLD}Verbose response from KNOXSS API:${NC}"
                    echo "$response" | jq .
                fi

            elif [[ "$error" == "Expiration time reset, please try again." ]]; then
                retries=$((retries + 1))
                if [[ $retries -lt $retry_count ]]; then
                    echo -e "${RED}[ ERROR ] - $line - [Expiration time reset, please try again.] Retrying in ${retry_interval} seconds... (${retries}/${retry_count})${NC}"
                    sleep "$retry_interval"
                else
                    echo -e "${RED}[ ERROR ] - $line - [Expiration time reset, please try again.]${NC} [$api_call]"
                    echo "$line" >> "$todo_file"
                fi
                if $verbose_mode; then
                    echo -e "${BOLD}Verbose response from KNOXSS API:${NC}"
                    echo "$response" | jq .
                fi

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
export api_key output_file use_notify todo_file processed_file unknown_error_log verbose_mode CYAN GREEN RED YELLOW BOLD NC retry_count retry_interval cookies post_data

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