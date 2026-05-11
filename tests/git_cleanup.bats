#!/usr/bin/env bats

setup() {
    export TEST_DIR="${BATS_TMPDIR}/git-cleanup-test-$$"
    mkdir -p "$TEST_DIR"
    cd "$TEST_DIR"
    git init -b master
    git config user.email "test@example.com"
    git config user.name "Test User"
    
    echo "initial" > file
    git add file
    git commit -m "initial commit"
    
    export BASHRC_PATH="$BATS_TEST_DIRNAME/../bashrc"
}

teardown() {
    rm -rf "$TEST_DIR"
}

@test "git-cleanup identifies and deletes merged local branches" {
    git checkout -b feature-merged
    echo "feature" > feature_file
    git add feature_file
    git commit -m "feature commit"
    
    git checkout master
    git merge feature-merged
    
    # Verify branch exists before cleanup
    run git branch
    [[ "$output" == *"feature-merged"* ]]
    
    # Run cleanup with "y" confirmation
    run bash -i -c "source $BASHRC_PATH && echo y | git-cleanup"
    [ "$status" -eq 0 ]
    [[ "$output" == *"Using 'master' as the primary branch"* ]]
    [[ "$output" == *"feature-merged"* ]]
    
    # Verify branch is gone
    run git branch
    [[ "$output" != *"feature-merged"* ]]
}

@test "git-cleanup handles 'main' as primary branch" {
    git branch -m master main
    git checkout -b feature-merged
    git commit --allow-empty -m "feature"
    git checkout main
    git merge feature-merged
    
    run bash -i -c "source $BASHRC_PATH && echo y | git-cleanup"
    [ "$status" -eq 0 ]
    [[ "$output" == *"Using 'main' as the primary branch"* ]]
    [[ "$output" == *"feature-merged"* ]]
    
    run git branch
    [[ "$output" != *"feature-merged"* ]]
}

@test "git-cleanup does not delete the current branch" {
    git checkout -b current-branch
    # It is merged into master (as it is exactly at master)
    
    run bash -i -c "source $BASHRC_PATH && echo y | git-cleanup"
    [ "$status" -eq 0 ]
    
    run git branch
    [[ "$output" == *"* current-branch"* ]]
}

@test "git-cleanup does not delete unmerged branches" {
    git checkout -b feature-unmerged
    echo "unmerged" > unmerged_file
    git add unmerged_file
    git commit -m "unmerged commit"
    
    git checkout master
    
    run bash -i -c "source $BASHRC_PATH && echo y | git-cleanup"
    [ "$status" -eq 0 ]
    
    run git branch
    [[ "$output" == *"feature-unmerged"* ]]
}

@test "git-cleanup skips remote prune when no remotes are configured" {
    run bash -i -c "source $BASHRC_PATH && git-cleanup"
    [ "$status" -eq 0 ]
    [[ "$output" == *"No remotes configured; skipping remote-tracking prune."* ]]
    [[ "$output" != *"remote-tracking references will be removed"* ]]
}

@test "git-cleanup default mode keeps non-merged patch-equivalent branches" {
    git checkout -b feature-cherry
    echo "shared change" >> file
    git add file
    git commit -m "feature change"

    git checkout master
    git commit --allow-empty -m "diverge main history"
    git cherry-pick feature-cherry

    run git branch --merged master
    [[ "$output" != *"feature-cherry"* ]]

    run bash -i -c "source $BASHRC_PATH && echo y | git-cleanup"
    [ "$status" -eq 0 ]

    run git branch
    [[ "$output" == *"feature-cherry"* ]]
}

@test "git-cleanup --aggressive deletes non-merged patch-equivalent branches" {
    git checkout -b feature-cherry
    echo "shared change" >> file
    git add file
    git commit -m "feature change"

    git checkout master
    git commit --allow-empty -m "diverge main history"
    git cherry-pick feature-cherry

    run git branch --merged master
    [[ "$output" != *"feature-cherry"* ]]

    run bash -i -c "source $BASHRC_PATH && echo y | git-cleanup --aggressive"
    [ "$status" -eq 0 ]
    [[ "$output" == *"Aggressive mode:"* ]]
    [[ "$output" == *"feature-cherry"* ]]

    run git branch
    [[ "$output" != *"feature-cherry"* ]]
}

@test "git-cleanup -a deletes non-merged patch-equivalent branches" {
    git checkout -b feature-cherry-short
    echo "shared change short" >> file
    git add file
    git commit -m "feature change short"

    git checkout master
    git commit --allow-empty -m "diverge main history"
    git cherry-pick feature-cherry-short

    run git branch --merged master
    [[ "$output" != *"feature-cherry-short"* ]]

    run bash -i -c "source $BASHRC_PATH && echo y | git-cleanup -a"
    [ "$status" -eq 0 ]
    [[ "$output" == *"Aggressive mode:"* ]]
    [[ "$output" == *"feature-cherry-short"* ]]

    run git branch
    [[ "$output" != *"feature-cherry-short"* ]]
}

@test "git-cleanup --help prints usage" {
    run bash -i -c "source $BASHRC_PATH && git-cleanup --help"
    [ "$status" -eq 0 ]
    [[ "$output" == *"Usage: git-cleanup [-a|--aggressive] [-h|--help]"* ]]
    [[ "$output" == *"-h, --help        Show this help message."* ]]
}

@test "git-cleanup -h prints usage" {
    run bash -i -c "source $BASHRC_PATH && git-cleanup -h"
    [ "$status" -eq 0 ]
    [[ "$output" == *"Usage: git-cleanup [-a|--aggressive] [-h|--help]"* ]]
    [[ "$output" == *"-h, --help        Show this help message."* ]]
}

@test "git-cleanup errors outside a git repository" {
    cd "$BATS_TMPDIR"

    run bash -i -c "source $BASHRC_PATH && git-cleanup"
    [ "$status" -eq 1 ]
    [[ "$output" == *"Error: Not inside a git repository."* ]]
}

@test "git-cleanup aborts on 'n' confirmation" {
    git checkout -b feature-merged
    git commit --allow-empty -m "feature"
    git checkout master
    git merge feature-merged
    
    run bash -i -c "source $BASHRC_PATH && echo n | git-cleanup"
    [ "$status" -eq 0 ]
    [[ "$output" == *"Cleanup aborted."* ]]
    
    run git branch
    [[ "$output" == *"feature-merged"* ]]
}
