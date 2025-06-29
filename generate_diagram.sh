#!/bin/bash
# Install PlantUML if not already installed
if ! command -v plantuml &> /dev/null; then
    echo "PlantUML not found, installing..."
    # Make sure Java is installed
    if ! command -v java &> /dev/null; then
        echo "Java is required. Please install Java first."
        exit 1
    fi
    
    # Download PlantUML jar
    mkdir -p ~/bin
    wget -O ~/bin/plantuml.jar https://github.com/plantuml/plantuml/releases/download/v1.2023.10/plantuml-1.2023.10.jar
    echo 'alias plantuml="java -jar ~/bin/plantuml.jar"' >> ~/.bashrc
    source ~/.bashrc
    echo "PlantUML installed to ~/bin/plantuml.jar"
fi

# Generate diagram with no dependencies on external resources
echo "Generating simple diagram from infrastructure_diagram.puml"
OUTPUT_FILE="./aws/CKAN-AWS-Infrastructure.png"
PUML_FILE="./aws/infrastructure_diagram.puml"
rm -f "$OUTPUT_FILE"  # Remove existing file if it exists

# Generate diagram (no verbose output to reduce noise)
java -jar ~/bin/plantuml.jar -DPLANTUML_LIMIT_SIZE=20000 -tpng $PUML_FILE

# Check if the file was created
if [ -f "$OUTPUT_FILE" ] && [ -s "$OUTPUT_FILE" ]; then
    echo "Success! PNG file created at $OUTPUT_FILE"
    ls -la $OUTPUT_FILE
    # Optional: open the image if we're in a graphical environment
    if command -v xdg-open &> /dev/null; then
        echo "Opening diagram..."
        xdg-open $OUTPUT_FILE
    elif command -v open &> /dev/null; then
        echo "Opening diagram..."
        open $OUTPUT_FILE
    fi
else
    echo "Error: PNG file was not created or is empty."
    exit 1
fi
