#!/bin/sh

EMU=standalone

EMU_TAG=$(basename "$(dirname "$0")" .pak)
#CPU_OC=${CPU_SPEED_MAX} # 1.512 GHz
#CPU_OC=${CPU_SPEED_PERF}  # 1.344 GHz
CPU_OC=${CPU_SPEED_GAME}  # 1.2 GHz
#CPU_OC=${CPU_SPEED_POWERSAVE}  # 816MHz
#CPU_OC=${CPU_SPEED_MENU}  # 576MHz


overclock.elf ${CPU_OC}

/bin/sh "$1"
overclock.elf ${CPU_SPEED_MENU}
