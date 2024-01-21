#!/usr/bin/env sh

### UTILS

expand_tilde() {
	eval "expanded_path=$1"
	echo "$expanded_path"
}

### END

#-- INSTALL PREFIX FOR SED --#

HELP_MSG="Usage: $0 [subcommand]
Subcommands:
  configure          configure the project
  build              build the project"

build_helper() {
	if ! [ -f "build.sh" ]; then
		echo 'File build.sh not found! Generate one with `build.sh configure`'
		exit 1
	fi

	. ./build.sh

	if [ "$TARGETS" = "" ]; then
		echo "No targets found, skip!"
		exit 1
	fi

	if [ $# == 0 ]; then
		printf "Found targets: "

		for target in $TARGETS; do
			printf '%s ' "$target"
		done
		echo ""
	else
		./build.sh $@
	fi
}

PREFIX="$(expand_tilde $PREFIX)"

while [ $# -gt 0 ]; do
	case "$1" in
		--help)
			echo "$HELP_MSG"
			exit 0
			;;
		configure)
			shift
			set -- $@
			. "$PREFIX/build_sh_tools/configure"
			exit 0
			;;
		build)
			shift
			set -- $@
			build_helper $@
			exit 0
			;;
		*)
			;;
	esac
done

echo "$HELP_MSG"
exit 1
