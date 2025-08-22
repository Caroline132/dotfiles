# Function to create Azure DevOps PR with smart defaults
azpr() {
    # Check if PAT is configured
    if [[ -z "$AZURE_DEVOPS_EXT_PAT" ]]; then
        echo "\033[31mERROR\033[0m Please set your Azure DevOps PAT in ~/.zshrc:"
        return 1
    fi
    
    # Get current branch
    local current_branch=$(git branch --show-current)
    
    # Determine the default branch (main or master)
    local default_branch
    if git show-ref --verify --quiet refs/heads/main; then
        default_branch="main"
    elif git show-ref --verify --quiet refs/heads/master; then
        default_branch="master"
    else
        echo "\033[31mERROR\033[0m Could not find main or master branch"
        return 1
    fi
    
    # Check if we're on a valid branch (not main/master)
    if [[ "$current_branch" == "$default_branch" ]]; then
        echo "\033[31mERROR\033[0m Cannot create PR from $default_branch branch"
        return 1
    fi
    
    # Get repository name from remote origin
    local repo_name=$(git remote get-url origin | sed 's/.*\///' | sed 's/\.git$//')
    
    # Get last commit message
    local last_commit=$(git log -1 --pretty=format:"%s")
    
    # Check if description was provided as argument
    local description="$1"
    
    # If no description provided, use last commit message
    if [[ -z "$description" ]]; then
        description="$last_commit"
    fi
    
    echo "\033[34mINFO\033[0m PR Details:"
    echo "   Branch: $current_branch → $default_branch"
    echo "   Repo: $repo_name" 
    echo "   Title: $last_commit"
    echo "   Description: $description"
    echo "   Options: auto-complete, delete-source-branch, squash"
    echo ""
    
    # Confirmation prompt
    echo -n "Create this PR? (Y/n): "
    read -r confirmation
    
    # Default to 'Y' if just Enter is pressed
    confirmation=${confirmation:-Y}
    
    case $confirmation in
        [Yy]* )
            echo "\033[32mSUCCESS\033[0m Creating PR..."
            local pr_result=$(az repos pr create \
                --source-branch "$current_branch" \
                --target-branch "$default_branch" \
                --title "$last_commit" \
                --description "$description" \
                --repository "$repo_name" \
                --auto-complete \
                --delete-source-branch \
                --squash)
            
            local pr_exit_code=$?
            
            # Show PR result
            if [[ $pr_exit_code -eq 0 ]]; then
                echo "$pr_result"
            else
                return $pr_exit_code
            fi
            ;;
        [Nn]* )
            echo "\033[31mERROR\033[0m PR creation cancelled"
            return 0
            ;;
        * )
            echo "\033[31mERROR\033[0m Invalid response. PR creation cancelled"
            return 1
            ;;
    esac
}

# Alternative shorter alias
alias pr='azpr'
 
