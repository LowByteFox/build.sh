#!/usr/bin/env sh

if [ "$PREFIX" = "" ]; then
	PREFIX='/usr/local/bin'
else
	PREFIX="$PREFIX"
fi

cmd="$(cat build.sh | sed 's|#-- INSTALL PREFIX FOR SED --#|PREFIX='\'${PREFIX}/\''|')"

if command -v doas > /dev/null 2>&1; then
	SUDO_CMD='doas'
elif command -v sudo > /dev/null 2>&1; then
	SUDO_CMD='sudo'
else
	echo 'Error: Neither doas nor sudo found!'
	exit 1
fi

if [ -w "$PREFIX" ]; then
	echo "$cmd" > "$PREFIX/build.sh"
	chmod +x "$PREFIX/build.sh"
	echo "Installed build.sh"
	echo "Installing components"
	cp -rv ./build_sh_tools/ "$PREFIX/build_sh_tools/"
else
	echo "$cmd" | $SUDO_CMD tee "$PREFIX/build.sh" > /dev/null
	$SUDO_CMD chmod +x "$PREFIX/build.sh"
	echo "Installed build.sh"
	echo "Installing components"
	$SUDO_CMD cp -rv ./build_sh_tools/ "$PREFIX/build_sh_tools/"
fi
