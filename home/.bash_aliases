parse_git_branch() {
  git branch --show-current 2>/dev/null
}

export PS1='\[\e[1;30m\][\A]\[\e[0m\] \[\e[1;32m\]\u@<change-me>\[\e[0m\] \[\e[1;34m\]\w\[\e[0m\]$(branch=$(parse_git_branch); if [ -n "$branch" ]; then printf " \[\e[1;35m\](%s)\[\e[0m\]" "$branch"; fi) :: '

