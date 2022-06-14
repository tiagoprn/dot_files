require('blame_line').setup({
  show_in_visual = false,
  show_in_insert = false,
  template = "<committer-mail> • <committer-time> • <commit-short> • <summary>",
  date = {
  	relative = false,
  	format = "+%A %d, %B %Y"
  }
})
