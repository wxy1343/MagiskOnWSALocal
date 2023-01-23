#!/bin/bash
#
# This file is part of MagiskOnWSALocal.
#
# MagiskOnWSALocal is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as
# published by the Free Software Foundation, either version 3 of the
# License, or (at your option) any later version.
#
# MagiskOnWSALocal is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with MagiskOnWSALocal.  If not, see <https://www.gnu.org/licenses/>.
#
# Copyright (C) 2023 LSPosed Contributors
#

# DEBUG=--debug
# CUSTOM_MAGISK=--magisk-custom
if [ ! "$BASH_VERSION" ]; then
    echo "Please do not use sh to run this script, just execute it directly" 1>&2
    exit 1
fi
cd "$(dirname "$0")" || exit 1

./install_deps.sh

WHIPTAIL=$(command -v whiptail 2>/dev/null)
DIALOG=$(command -v dialog 2>/dev/null)
DIALOG=${WHIPTAIL:-$DIALOG}
function Radiolist {
    declare -A o="$1"
    shift
    if ! $DIALOG --nocancel --radiolist "${o[title]}" 0 0 0 "$@" 3>&1 1>&2 2>&3; then
        echo "${o[default]}"
    fi
}

function YesNoBox {
    declare -A o="$1"
    shift
    $DIALOG --title "${o[title]}" --yesno "${o[text]}" 0 0
}

if [ "$GAPPS_VARIANT" != "none" ]; then
    GAPPS_BRAND="OpenGApps"
fi

COMPRESS_OUTPUT="--compress"
COMPRESS_FORMAT="7z"

declare -A RELEASE_TYPE_MAP=(["retail"]="retail" ["release preview"]="RP" ["insider slow"]="WIS" ["insider fast"]="WIF")
COMMAND_LINE=(--arch "$ARCH" --release-type "${RELEASE_TYPE_MAP[$RELEASE_TYPE]}" --magisk-ver "$MAGISK_VER" --gapps-brand "$GAPPS_BRAND" --gapps-variant "$GAPPS_VARIANT" "$REMOVE_AMAZON" --root-sol "$ROOT_SOL" "$COMPRESS_OUTPUT" "$OFFLINE" "$DEBUG" "$CUSTOM_MAGISK" --debug --compress-format "$COMPRESS_FORMAT")
echo "COMMAND_LINE=${COMMAND_LINE[*]}"
./build.sh "${COMMAND_LINE[@]}"