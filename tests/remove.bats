#!/usr/bin/env bats
# shellcheck disable=SC1091
load helpers
source "$SRC/recent.sh"
source "$SRC/remove.sh"
source "$SRC/project.sh"

setup() {
    export PD_LANG=pt_BR
    PROJECTS_DIR="$BATS_TEST_TMPDIR/projects"
    RECENT_FILE="$BATS_TEST_TMPDIR/recent"
    TRASH_DIR="$BATS_TEST_TMPDIR/trash"
    export TRASH_MAX_ITEMS=3
    export TRASH_MAX_DAYS=3
    export MOCK_LOG="$BATS_TEST_TMPDIR/mock.log"
    : > "$MOCK_LOG"
    mkdir -p "$PROJECTS_DIR" "$TRASH_DIR" "$BATS_TEST_TMPDIR/bin"
    export PATH="$BATS_TEST_TMPDIR/bin:$PATH"
}

@test "remove: no args shows usage" {
    run remove_project
    [ "$status" -eq 1 ]
    [[ "$output" == *"Uso"* ]]
}

@test "remove: >3 args shows max error" {
    run remove_project a b c d
    [ "$status" -eq 1 ]
    [[ "$output" == *"Máximo"* ]]
}

@test "remove: project not found" {
    run remove_project "nonexistent"
    [ "$status" -eq 1 ]
    [[ "$output" == *"not found"* ]]
}

@test "remove: moves to trash" {
    mkdir -p "$PROJECTS_DIR/myproj"
    run remove_project "myproj"
    [ "$status" -eq 0 ]
    [ ! -d "$PROJECTS_DIR/myproj" ]
    [ -d "$TRASH_DIR/myproj" ]
    [ -f "$TRASH_DIR/myproj/.trash_info" ]
    [[ "$output" == *"movido para a lixeira"* ]]
}

@test "remove: batch moves 2 to trash" {
    mkdir -p "$PROJECTS_DIR/p1" "$PROJECTS_DIR/p2"
    run remove_project "p1" "p2"
    [ "$status" -eq 0 ]
    [ ! -d "$PROJECTS_DIR/p1" ]
    [ ! -d "$PROJECTS_DIR/p2" ]
    [ -d "$TRASH_DIR/p1" ]
    [ -d "$TRASH_DIR/p2" ]
}

@test "remove: --force deletes permanently" {
    mkdir -p "$PROJECTS_DIR/myproj"
    run remove_project --force "myproj"
    [ "$status" -eq 0 ]
    [ ! -d "$PROJECTS_DIR/myproj" ]
    [ ! -d "$TRASH_DIR/myproj" ]
    [[ "$output" == *"excluído permanentemente"* ]]
}

@test "remove: -f deletes permanently" {
    mkdir -p "$PROJECTS_DIR/myproj"
    run remove_project -f "myproj"
    [ "$status" -eq 0 ]
    [ ! -d "$PROJECTS_DIR/myproj" ]
    [[ "$output" == *"excluído permanentemente"* ]]
}

@test "remove: --force batch deletes all permanently" {
    mkdir -p "$PROJECTS_DIR/p1" "$PROJECTS_DIR/p2"
    run remove_project --force "p1" "p2"
    [ "$status" -eq 0 ]
    [ ! -d "$PROJECTS_DIR/p1" ]
    [ ! -d "$PROJECTS_DIR/p2" ]
}

@test "remove: trash full confirms and deletes" {
    mkdir -p "$PROJECTS_DIR/myproj"
    mkdir -p "$TRASH_DIR/a" "$TRASH_DIR/b" "$TRASH_DIR/c"
    echo "y" > "$BATS_TEST_TMPDIR/input"
    run remove_project "myproj" < "$BATS_TEST_TMPDIR/input"
    [ "$status" -eq 0 ]
    [ ! -d "$PROJECTS_DIR/myproj" ]
    [ ! -d "$TRASH_DIR/myproj" ]
    [[ "$output" == *"excluído permanentemente"* ]]
}

@test "remove: trash full cancels and skips" {
    mkdir -p "$PROJECTS_DIR/myproj"
    mkdir -p "$TRASH_DIR/a" "$TRASH_DIR/b" "$TRASH_DIR/c"
    echo "n" > "$BATS_TEST_TMPDIR/input"
    run remove_project "myproj" < "$BATS_TEST_TMPDIR/input"
    [ "$status" -eq 0 ]
    [ -d "$PROJECTS_DIR/myproj" ]
    [[ "$output" == *"ignorado"* ]]
}

@test "remove: removes from recent file" {
    mkdir -p "$PROJECTS_DIR/myproj"
    recent_add "myproj"
    [ "$(head -n1 "$RECENT_FILE")" = "myproj" ]
    run remove_project --force "myproj"
    ! grep -q "^myproj$" "$RECENT_FILE"
}

@test "remove: batch with trash filling mid-way" {
    mkdir -p "$PROJECTS_DIR/p1" "$PROJECTS_DIR/p2" "$PROJECTS_DIR/p3"
    mkdir -p "$TRASH_DIR/a" "$TRASH_DIR/b"
    printf "y\ny\n" > "$BATS_TEST_TMPDIR/input"
    run remove_project "p1" "p2" "p3" < "$BATS_TEST_TMPDIR/input"
    [ "$status" -eq 0 ]
    [ -d "$TRASH_DIR/p1" ]
    [ ! -d "$PROJECTS_DIR/p2" ]
    [ ! -d "$PROJECTS_DIR/p3" ]
    [[ "$output" == *"movido para a lixeira"* ]]
    [[ "$output" == *"excluído permanentemente"* ]]
}

@test "remove all: empty shows message" {
    run remove_project all
    [ "$status" -eq 0 ]
    [[ "$output" == *"Nenhum projeto"* ]]
}

@test "remove all: confirms and moves to trash" {
    mkdir -p "$PROJECTS_DIR/p1" "$PROJECTS_DIR/p2"
    echo "y" > "$BATS_TEST_TMPDIR/input"
    run remove_project all < "$BATS_TEST_TMPDIR/input"
    [ "$status" -eq 0 ]
    [ ! -d "$PROJECTS_DIR/p1" ]
    [ ! -d "$PROJECTS_DIR/p2" ]
    [ -d "$TRASH_DIR/p1" ]
    [ -d "$TRASH_DIR/p2" ]
    [[ "$output" == *"movido para a lixeira"* ]]
}

@test "remove all: cancels" {
    mkdir -p "$PROJECTS_DIR/p1"
    echo "n" > "$BATS_TEST_TMPDIR/input"
    run remove_project all < "$BATS_TEST_TMPDIR/input"
    [ "$status" -eq 0 ]
    [ -d "$PROJECTS_DIR/p1" ]
    [[ "$output" == *"Cancelado"* ]]
}

@test "remove all: --force deletes all permanently" {
    mkdir -p "$PROJECTS_DIR/p1" "$PROJECTS_DIR/p2"
    run remove_project --force all
    [ "$status" -eq 0 ]
    [ ! -d "$PROJECTS_DIR/p1" ]
    [ ! -d "$PROJECTS_DIR/p2" ]
    [[ "$output" == *"excluído permanentemente"* ]]
}

@test "remove all: used with other args shows error" {
    run remove_project all myproj
    [ "$status" -eq 1 ]
    [[ "$output" == *"use sozinho"* ]]
}

@test "trash_purge_expired: removes expired items" {
    local old_dir="$TRASH_DIR/oldproj"
    mkdir -p "$old_dir"
    echo "$(($(date +%s) - 4 * 86400 - 1))" > "$old_dir/.trash_info"
    trash_purge_expired
    [ ! -d "$old_dir" ]
}

@test "trash_purge_expired: keeps fresh items" {
    local fresh_dir="$TRASH_DIR/freshproj"
    mkdir -p "$fresh_dir"
    date +%s > "$fresh_dir/.trash_info"
    trash_purge_expired
    [ -d "$fresh_dir" ]
}

@test "main: routes remove / rm" {
    remove_project() { echo "_remove_ $*"; }
    run main remove myproj
    [[ "$output" == *"_remove_ myproj"* ]]
    run main rm myproj
    [[ "$output" == *"_remove_ myproj"* ]]
}

@test "main: routes trash / t" {
    trash() { echo "_trash_ $*"; }
    run main trash ls
    [[ "$output" == *"_trash_ ls"* ]]
    run main t empty
    [[ "$output" == *"_trash_ empty"* ]]
}
