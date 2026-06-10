param(
  [Parameter(Mandatory = $true)][string]$Path,
  [int]$Line = 0
)

if (-not $env:NVIM) {
  if ($Line -gt 0) {
    & nvim "+$Line" -- $Path
  } else {
    & nvim -- $Path
  }
  exit 0
}

$path = $Path -replace '\\', '/'
$expr = "luaeval('require(\`"lazygit_config\`").open_file([=[$path]=], $Line)')"
& nvim --server $env:NVIM --remote-expr $expr | Out-Null
