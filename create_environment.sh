#!/bin/bash

# Ask for the user's name
read -p "Enter your name: " user_name

# Create the main application directory
app_directory="submission_reminder_${user_name}"
mkdir "$app_directory"

# Create subdirectories for the application structure
mkdir -p "$app_directory/app"
mkdir -p "$app_directory/modules"
mkdir -p "$app_directory/assets"
mkdir -p "$app_directory/config"

# Create the configuration file
cat > "$app_directory/config/config.env" << 'EOF'
# Configuration for the assignment
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

echo "config.env created successfully"

# Create the reminder script in the app directory
cat > "$app_directory/app/reminder.sh" << 'EOF'
#!/bin/bash

# Load environment variables and helper functions
source ../config/config.env
source ../modules/functions.sh

# Define the path to the submissions file
submissions_file="../assets/submissions.txt"

# Display assignment details
echo "Assignment: $ASSIGNMENT"
echo "Days remaining: $DAYS_REMAINING days"
echo "--------------------------------------------"

# Call the function to check submissions
check_submissions "$submissions_file"
EOF

echo "reminder.sh created successfully"

# Set executable permissions for reminder.sh
chmod +x "$app_directory/app/reminder.sh"
# Create the functions script in the modules directory
cat > "$app_directory/modules/functions.sh" << 'EOF'
#!/bin/bash

# Function to check which students haven't submitted their assignments
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Read through the submissions, skipping the header
    while IFS=, read -r student assignment status; do
        # Trim whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # If the assignment matches and is not submitted, remind the student
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]];
        then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF

echo "functions.sh created successfully"

# Make functions.sh executable
chmod +x "$app_directory/modules/functions.sh"

# Create the submissions file in the assets directory
cat > "$app_directory/assets/submissions.txt" << 'EOF'
student,assignment,submission status
Chinemerem,Shell Navigation,not submitted
Chiagoziem,Shell Navigation,submitted
Andrew,Shell Navigation,not submitted
Adrian,Shell Navigation,not submitted
Bode,Shell Navigation,not submitted
Alvin,Shell Navigation,not submitted
Tasimba,Shell Navigation,not submitted
EOF

echo "submissions.txt created successfully"

# Create the startup script in the main directory
cat > "$app_directory/startup.sh" << 'EOF'
#!/usr/bin/env bash
# Script to run the application
cd app/
./reminder.sh
EOF

echo "startup.sh created successfully"

# Set executable permissions for startup.sh
chmod +x "$app_directory/startup.sh"

# Final message
echo "Environment setup complete in $app_directory"
