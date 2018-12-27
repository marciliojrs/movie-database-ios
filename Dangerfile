# PR is a work in progress and shouldn't be merged yet
warn("PR is classed as Work in Progress") if github.pr_title.include? "[WIP]"

# Warn when there is a big PR
warn("Big PR, consider splitting into smaller") if git.lines_of_code > 500

# Ensure a clean commits history
if git.commits.any? { |c| c.message =~ /^Merge branch '#{github.branch_for_base}'/ }
  fail("Please rebase to get rid of the merge commits in this PR")
end

has_app_changes = !git.modified_files.grep(/MovieDatabase/).empty?
has_test_changes = !git.modified_files.grep(/Tests/).empty?

# Let people say that this isn't worth a CHANGELOG entry in the PR if they choose
declared_trivial = (github.pr_title + github.pr_body).include?("#trivial") || !has_app_changes

if !git.modified_files.include?("CHANGELOG.md") && !declared_trivial
  warn("Please include a CHANGELOG entry.", sticky: false)
end

if has_app_changes && !has_test_changes && git.lines_of_code > 20
  warn("Tests were not updated", sticky: false)
end

swiftlint.lint_files fail_on_error: true