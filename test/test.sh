#!/usr/bin/env bash

shopt -s globstar
THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

function run () {
    src="$1"
    dir="$(dirname "$src")"
    basename="$(basename "$src")"
    obj="../bin/${dir}/${basename}.obj"
    exe="../bin/${dir}/$basename"
    description="$2"
    mkdir -p "../bin/$dir"
    echo "$(pwd)"
    g++ -c -std=c++1z -fsanitize=address -o "$obj" -I. -I../data "$src" 1>/dev/null 2>&1
    exval=$?
    if [ $exval -ne 0 ]; then
        echo "FAIL: $description"
        return $exval
    fi
    g++ -fsanitize=address -o "$exe" "$obj" 1>/dev/null 2>&1
    exval=$?
    if [ $exval -ne 0 ]; then
        echo "FAIL: $description"
        return $exval
    fi
    "$exe"
    exval=$? 1>/dev/null 2>&1
    if [ $exval -ne 0 ]; then
        echo "FAIL: $description"
        return $exval
    fi
    echo "PASS: $description"
    return 0
}

function compile () {
    src="$1"
    dir="$(dirname "$src")"
    basename="$(basename "$src")"
    obj="../bin/${dir}/${basename}.obj"
    description="$2"
    mkdir -p "../bin/$dir"
    g++ -c -std=c++1z -o "$obj" -I. -I../data "$src" 1>/dev/null 2>&1
    exval=$?
    if [ $exval -ne 0 ]; then
        echo "FAIL: $description"
        return $exval
    fi
    echo "PASS: $description"
    return 0
}

(cd "$THIS_DIR" &&
     for ph in **.cpp; do
         testtype="$(grep -E '//[[:space:]]*rysv-test-type[[:space:]]*:' "$ph" | head -n 1 | sed -e 's@//[[:space:]]*rysv-test-type[[:space:]]*:[[:space:]]*\([[:graph:]]*\)@\1@')"
         description="$(grep -E '//[[:space:]]*rysv-description[[:space:]]*:' "$ph" | head -n 1 | sed -e 's@//[[:space:]]*rysv-description[[:space:]]*:[[:space:]]*\(.*\)@\1@')"
         case "$testtype" in
         "run") run "$ph" "$description";;
         "compile") compile "$ph" "$description";;
         *) failed_to_test "$ph" "$description";;
         esac
     done
)
