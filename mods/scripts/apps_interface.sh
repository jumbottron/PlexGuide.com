execute_dynamic_command() {
    local app_script="/pg/apps/${app_name}"
    local start_delimiter="### START $1 COMMANDS"
    local end_delimiter="### END $1 COMMANDS"
    local inside_block=false

    echo "Executing commands for $1..."

    if [[ -f "$app_script" ]]; then
        while IFS= read -r line; do
            # Debug: Print the current line being read
            echo "Reading line: $line"

            if [[ "$line" == "$start_delimiter" ]]; then
                inside_block=true
                echo "Found start of $1 commands..."
            elif [[ "$line" == "$end_delimiter" ]]; then
                inside_block=false
                echo "Found end of $1 commands..."
            elif [[ "$inside_block" == true ]]; then
                echo "Executing: $line"
                eval "$line"
            fi
        done < "$app_script"
    else
        echo "Error: Script file for $app_name not found!"
        read -p "Press Enter to continue..."
    fi
}
