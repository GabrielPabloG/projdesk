#!/usr/bin/env bash

TEST_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck disable=SC2034
SRC="$TEST_ROOT/../src"

export PROJECTS_DIR
export RECENT_FILE
export DOCKER_MODE=wsl
export DOCKER_EXE="C:\\Program Files\\Docker\\Docker\\Docker Desktop.exe"
export AUTO_OPEN_CODE=true
export AUTO_START_CONTAINERS=false
export MOCK_LOG="$BATS_TEST_TMPDIR/mock.log"

setup() {
    PROJECTS_DIR="$BATS_TEST_TMPDIR/projects"
    RECENT_FILE="$BATS_TEST_TMPDIR/recent"
    : > "$MOCK_LOG"
    mkdir -p "$PROJECTS_DIR" "$BATS_TEST_TMPDIR/bin"
    export PATH="$BATS_TEST_TMPDIR/bin:$PATH"
}

mock_cmd() {
    local name="$1"
    local marker="$2"
    cat > "$BATS_TEST_TMPDIR/bin/$name" <<SCRIPT
#!/usr/bin/env bash
echo "${marker:-$name}" "\$@" >> "$MOCK_LOG"
exit 0
SCRIPT
    chmod +x "$BATS_TEST_TMPDIR/bin/$name"
}
