#!/bin/bash
# pack.sh --- RisohEditor deploy script
################################################################################
# RisohEditor --- Another free Win32 resource editor
# Copyright (C) 2017-2018 Katayama Hirofumi MZ <katayama.hirofumi.mz@gmail.com>
# 
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
################################################################################

RE_VERSION=3.7
RE_BIN_DIR="build/re-$RE_VERSION-bin"
RE_FILES="README.txt READMEJP.txt LICENSE.txt src/resource.h build/RisohEditor.exe"
RE_TARGET="build/re-$RE_VERSION-bin.zip"

################################################################################

if ! which zip > /dev/null 2>&1; then
    echo ERROR: there is no executable zip.
    exit 10
fi

if [ ! -d build ]; then
    echo ERROR: the build directory doesn't exists.
    exit 1
fi

if [ ! -d data ]; then
    echo ERROR: the data directory doesn't exists.
    exit 2
fi

if [ ! -e build/RisohEditor.exe ]; then
    echo ERROR: build/RisohEditor.exe doesn't exists.
    exit 3
fi

if [ ! -e build/mcdx.exe ]; then
    echo ERROR: build/mcdx.exe doesn't exists.
    exit 4
fi

if [ -e "$RE_BIN_DIR" ]; then
    echo Deleting "$RE_BIN_DIR"...
    rm -fr "$RE_BIN_DIR"
    mkdir "$RE_BIN_DIR"
else
    mkdir "$RE_BIN_DIR"
fi

################################################################################

echo Copying No.1...
if cp $RE_FILES "$RE_BIN_DIR"; then
    echo Copying No.2...
    if cp -r data "$RE_BIN_DIR"; then
        echo Copying No.3...
        if cp build/mcdx.exe "$RE_BIN_DIR/data/bin"; then
            echo Zipping...
            cd build
            if zip -9 -r -q "re-$RE_VERSION-bin.zip" "re-$RE_VERSION-bin"; then
                cd ..
                if [ -e "$RE_TARGET" ]; then
                    echo Success. "$RE_TARGET" was generated.
                else
                    echo ERROR: Target not found.
                    exit 9
                fi
            else
                cd ..
                echo ERROR: Zipping failed.
                exit 8
            fi
        else
            echo ERROR: Copying No.3 failed.
            exit 7
        fi
    else
        echo ERROR: Copying No.2 failed.
        exit 6
    fi
else
    echo ERROR: Copying No.1 failed.
    exit 5
fi

exit 0

################################################################################