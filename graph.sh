#!/bin/bash

INPUT=${1:-}
ROW_COUNT=${2:-}
if [[ -z ${INPUT} ]]; then
    echo "You should specific results files as an input."
    exit 1
fi

function bar_gen(){
    BAR_LENGHT=$(echo "${1}/1" | bc)
    BAR=""
    COUNTER=0
    while [ "${COUNTER}" -lt "${BAR_LENGHT}" ]; do
        BAR="${BAR}#"
        COUNTER=$(echo "${COUNTER} + 1" | bc)
    done
    echo "$BAR ${BAR_LENGHT} MB/s"
}



function drawer() {
    D_SUM=0
    U_SUM=0
    while read LINE; do
        DATE=$(echo "${LINE}" | cut -d"|" -f3)
        UP=$(echo "${LINE}" | cut -d"|" -f2)
        U_SUM=$((${U_SUM} + $(echo "${UP}/1" | bc)))
        DOWN=$(echo "${LINE}" | cut -d"|" -f1)
        D_SUM=$((${D_SUM} + $(echo "${DOWN}/1" | bc)))
        echo "${DATE} |Dl|" $(bar_gen "${DOWN}")
        echo "                |Ul|" $(bar_gen "${UP}")
    done <$(echo ${1})
    echo "Average         |Dl|" $(bar_gen $(echo "${D_SUM}/${ROW_COUNT}" | bc))
    echo "                |Ul|" $(bar_gen $(echo "${U_SUM}/${ROW_COUNT}" | bc))
    echo "                     ____5___10___15___20___25___30___35___40___45___50___55___60___65___70___75___80___85___90___"
}

tail --lines="${ROW_COUNT}" ${INPUT} > /tmp/speedtest-result.txt
drawer "/tmp/speedtest-result.txt"

exit 0

