if type gsed > /dev/null 2>&1
	set sed gsed
else
	set sed sed
end

set -l query (commandline -b)
[ -n "$query" ]; and set flags --query="$query"; or set flags
ghq list --full-path | $sed -e "1i$home/Downloads\n$home/tmp" | sk $flags | read select
[ -n "$select" ]; and cd "$select"
commandline -f repaint
