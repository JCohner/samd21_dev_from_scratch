# Path to top level ASF directory relative to this project directory.
ASF_PRJ_PATH = /home/jambox/asf-standalone/xdk-asf-3.52.0
ARDUINO_SAMD_PRJ_PATH = /home/jambox/ArduinoCore-samd/cores/arduino
ARDUINO_API_PRJ_PATH = /home/jambox/ArduinoCore-API

# Target CPU architecture: cortex-m3, cortex-m4
ARCH = cortex-m0

# Target part: none, sam3n4 or sam4l4aa
PART = samd21g18a

# Application target name. Given with suffix .a for library and .elf for a
# standalone application.
TARGET_FLASH = samd21_fuck_flash.elf
TARGET_SRAM =samd21_fuck_sram.elf

# List of C source files.
CSRCS = \
       $(ASF_PRJ_PATH)/common/utils/interrupt/interrupt_sam_nvic.c        \
       $(ASF_PRJ_PATH)/sam0/utils/stdio/read.c                            \
       $(ASF_PRJ_PATH)/sam0/utils/stdio/write.c                           \
       $(ASF_PRJ_PATH)/sam0/utils/syscalls/gcc/syscalls.c                 \
       $(ARDUINO_SAMD_PRJ_PATH)/abi.cpp \
       $(ARDUINO_SAMD_PRJ_PATH)/cortex_handlers.c \
       $(ARDUINO_SAMD_PRJ_PATH)/delay.c \
       $(ARDUINO_SAMD_PRJ_PATH)/hooks.c \
       $(ARDUINO_SAMD_PRJ_PATH)/itoa.c \
       $(ARDUINO_SAMD_PRJ_PATH)/new.cpp \
       $(ARDUINO_SAMD_PRJ_PATH)/pulse.c \
       $(ARDUINO_SAMD_PRJ_PATH)/Reset.cpp \
       $(ARDUINO_SAMD_PRJ_PATH)/SERCOM.cpp \
       $(ARDUINO_SAMD_PRJ_PATH)/startup.c \
       $(ARDUINO_SAMD_PRJ_PATH)/Tone.cpp \
       $(ARDUINO_SAMD_PRJ_PATH)/Uart.cpp \
       $(ARDUINO_SAMD_PRJ_PATH)/WInterrupts.c \
       $(ARDUINO_SAMD_PRJ_PATH)/wiring.c                                           \
       $(ARDUINO_SAMD_PRJ_PATH)/wiring_analog.c \
       $(ARDUINO_SAMD_PRJ_PATH)/wiring_digital.c \
       $(ARDUINO_SAMD_PRJ_PATH)/wiring_private.c \
       $(ARDUINO_SAMD_PRJ_PATH)/wiring_shift.c \
       $(ARDUINO_SAMD_PRJ_PATH)/WMath.cpp \
       $(ARDUINO_SAMD_PRJ_PATH)/USB/CDC.cpp \
       $(ARDUINO_SAMD_PRJ_PATH)/USB/samd21_host.c \
       $(ARDUINO_SAMD_PRJ_PATH)/USB/USBCore.cpp \
       $(ARDUINO_API_PRJ_PATH)/api/CanMsg.cpp \
       $(ARDUINO_API_PRJ_PATH)/api/CanMsgRingbuffer.cpp \
       $(ARDUINO_API_PRJ_PATH)/api/Common.cpp \
       $(ARDUINO_API_PRJ_PATH)/api/IPAddress.cpp \
       $(ARDUINO_API_PRJ_PATH)/api/PluggableUSB.cpp \
       $(ARDUINO_API_PRJ_PATH)/api/Print.cpp \
       $(ARDUINO_API_PRJ_PATH)/api/Stream.cpp \
       $(ARDUINO_API_PRJ_PATH)/api/String.cpp \
       variant.cpp \
       main.cpp \


# List of assembler source files.
ASSRCS = 

# List of include paths.
INC_PATH = \
       $(ASF_PRJ_PATH)/common/boards                                      \
       $(ASF_PRJ_PATH)/common/services/serial                             \
       $(ASF_PRJ_PATH)/common/utils                                       \
       $(ASF_PRJ_PATH)/sam0/boards                                        \
       $(ASF_PRJ_PATH)/sam0/utils                                         \
       $(ASF_PRJ_PATH)/sam0/utils/cmsis/samd21/include                    \
       $(ASF_PRJ_PATH)/sam0/utils/cmsis/samd21/source                     \
       $(ASF_PRJ_PATH)/sam0/utils/header_files                            \
       $(ASF_PRJ_PATH)/sam0/utils/preprocessor                            \
       $(ASF_PRJ_PATH)/sam0/utils/stdio/stdio_serial                      \
       $(ASF_PRJ_PATH)/thirdparty/CMSIS/Include                           \
       $(ASF_PRJ_PATH)/thirdparty/CMSIS/Lib/GCC \
       $(ARDUINO_API_PRJ_PATH) \
       $(ARDUINO_SAMD_PRJ_PATH) \
       $(ARDUINO_SAMD_PRJ_PATH)/USB \

# Additional search paths for libraries.
LIB_PATH =  \
       thirdparty/CMSIS/Lib/GCC                          

# List of libraries to use during linking.
LIBS =  \
       arm_cortexM0l_math                                

# Path relative to top level directory pointing to a linker script.
# LINKER_SCRIPT_FLASH = $(ASF_PRJ_PATH)/sam0/utils/linker_scripts/samd21/gcc/samd21g18a_flash.ld
LINKER_SCRIPT_FLASH = flash_without_bootloader.ld
LINKER_SCRIPT_SRAM  = sam0/utils/linker_scripts/samd21/gcc/samd21g18a_sram.ld

# Path relative to top level directory pointing to a linker script.
#DEBUG_SCRIPT_FLASH = 
#DEBUG_SCRIPT_SRAM  = sam0/boards/samb11_xplained_pro/debug_scripts/gcc/samb11_xplained_pro_sram.gdb

# Project type parameter: all, sram or flash
PROJECT_TYPE        = flash

# Additional options for debugging. By default the common Makefile.in will
# add -g3.
DBGFLAGS = 

# Application optimization used during compilation and linking:
# -O0, -O1, -O2, -O3 or -Os
OPTIMIZATION = -O1

# Extra flags to use when archiving.
ARFLAGS = 

# Extra flags to use when assembling.
ASFLAGS = 

# Extra flags to use when compiling.
CFLAGS = 

# Extra flags to use when preprocessing.
#
# Preprocessor symbol definitions
#   To add a definition use the format "-D name[=definition]".
#   To cancel a definition use the format "-U name".
#
# The most relevant symbols to define for the preprocessor are:
#   BOARD      Target board in use, see boards/board.h for a list.
#   EXT_BOARD  Optional extension board in use, see boards/board.h for a list.
CPPFLAGS = \
       -D ARM_MATH_CM0=true                               \
       -D __SAMD21G18A__ \
       -DF_CPU=48000000L \
       -DUSB_VID=0x2341 -DUSB_PID=0x8057 -DUSBCON 

# Extra flags to use when linking
LDFLAGS = \

# Pre- and post-build commands
PREBUILD_CMD = 
POSTBUILD_CMD = 