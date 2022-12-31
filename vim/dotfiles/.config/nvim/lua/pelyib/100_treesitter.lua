require'nvim-treesitter.configs'.setup {
  ensure_installed = {"bash", "cmake", "css", "dockerfile", "dot", "graphql", "html", "lua", "make", "python", "javascript", "sql", "vim", "yaml", "regex", "go", "php", "markdown", "json"},
  highlight={
    enable=true,
    additional_vim_regex_highlighting=true,
  }
}
