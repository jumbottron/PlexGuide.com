# Function: execute_dynamic_menu
execute_dynamic_menu() {
    local selected_option=$1

    # Source the app script to load the functions
    echo "source /pg/apps/\"$app_name\""
    source /pg/apps/$app_name

    # Get the selected option name (e.g., "Admin Token" or "Token")
    local selected_name=$(echo "${dynamic_menu_items[$((selected_option-1))]}" | awk '{print $2, $3}')  # Capture full menu item name
    echo "Selected function name: $selected_name"  # Debugging: Check the function name extracted

    # Determine if the selected name has multiple words
    if [[ "$selected_name" =~ [[:space:]] ]]; then
        # If it has spaces, replace them with underscores
        local function_name=$(echo "$selected_name" | tr '[:upper:]' '[:lower:]' | tr ' ' '_')
    else
        # If it's a single word, just convert to lowercase
        local function_name=$(echo "$selected_name" | tr '[:upper:]' '[:lower:]')
    fi
    echo "Function name derived: $function_name"  # This will echo the function name

    # Check if the function exists and execute it
    if declare -f "$function_name" > /dev/null; then
        echo "Executing commands for ${function_name}..."
        "$function_name"  # Execute the function
    else
        echo "Error: No corresponding function found for ${function_name}."
    fi

    read -p "Press Enter to continue..."  # Pause to observe output
}
