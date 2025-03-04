#!/usr/bin/env bash
#
# Copyright (C) 2020-2022 diva.exchange
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.
#
# Author/Maintainer: DIVA.EXCHANGE Association <contact@diva.exchange>
#

# -e  Exit immediately if a simple command exits with a non-zero status
set -e

PROJECT_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"/../
cd "${PROJECT_PATH}"
PROJECT_PATH=$( pwd )

# load helpers
source "${PROJECT_PATH}"/bin/util/echos.sh
source "${PROJECT_PATH}"/bin/util/helpers.sh

BASE_DOMAIN=${BASE_DOMAIN:-testnet.local}
NO_BOOTSTRAPPING=${NO_BOOTSTRAPPING:1}

PATH_DOMAIN=${PROJECT_PATH}/build/domains/${BASE_DOMAIN}
if [[ ! -d ${PATH_DOMAIN} ]]
then
  error "Path not found: ${PATH_DOMAIN}";
  exit 3
fi

BASE_DOMAIN=${BASE_DOMAIN} bin/halt.sh && BASE_DOMAIN=${BASE_DOMAIN} NO_BOOTSTRAPPING=${NO_BOOTSTRAPPING} bin/start.sh
