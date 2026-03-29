#!/usr/bin/env zsh
file="$1"

# If no argument or empty, exit
if [ -z "$file" ] || [ "$file" = "%{buffer_name}" ]; then
    echo "No file provided or variable not expanded"
    exit 1
fi

# Get the directory of the file and change to it
file_dir=$(dirname "$file")
file_name=$(basename "$file")
extension="${file_name##*.}"

# Change to the file's directory
cd "$file_dir" || {
    echo "Could not change to file directory: $file_dir"
    exit 1
}

case "$extension" in
    py)
        python3 "$file_name"
        ;;
    js)
        node "$file_name"
        ;;
    rs)
        # Check if we're in a Cargo project, otherwise use rustc
        if [ -f "Cargo.toml" ]; then
            cargo run
        else
            rustc "$file_name" -o "${file_name%.*}" && "./${file_name%.*}"
        fi
        ;;
    go)
        go run "$file_name"
        ;;
    sh)
        bash "$file_name"
        ;;
    c)
        gcc "$file_name" -o "${file_name%.*}" && "./${file_name%.*}"
        ;;
    cpp|cc|cxx)
        g++ "$file_name" -o "${file_name%.*}" && "./${file_name%.*}"
        ;;
    java)
        javac "$file_name" && java "${file_name%.*}"
        ;;
    ts)
        npx tsx "$file_name"
        ;;
    php)
        php "$file_name"
        ;;
    rb)
        ruby "$file_name"
        ;;
    pl)
        perl "$file_name"
        ;;
    sh)
        sh "$file_name"
        ;;
    lua)
        lua "$file_name"
        ;;
    *)
        echo "No runner configured for .$extension files"
        ;;
esac
