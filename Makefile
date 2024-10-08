include config.mk

# Look for source files relative to the top-level source directory
# VPATH           := $(ASF_PRJ_PATH)

# Output target file
project_type    := $(PROJECT_TYPE)

# Output target file
ifeq ($(project_type),flash)
target          := $(TARGET_FLASH)
linker_script   := $(LINKER_SCRIPT_FLASH)
debug_script    := $(ASF_PRJ_PATH)/$(DEBUG_SCRIPT_FLASH)
else
target          := $(TARGET_SRAM)
linker_script   := $(ASF_PRJ_PATH)/$(LINKER_SCRIPT_SRAM)
debug_script    := $(ASF_PRJ_PATH)/$(DEBUG_SCRIPT_SRAM)
endif

# Output project name (target name minus suffix)
project         := $(basename $(target))

# Output target file (typically ELF or static library)
ifeq ($(suffix $(target)),.a)
target_type     := lib
else
ifeq ($(suffix $(target)),.elf)
target_type     := elf
else
$(error "Target type $(target_type) is not supported")
endif
endif

CROSS           ?= arm-none-eabi-
AR              := $(CROSS)ar
AS              := $(CROSS)as
CC              := $(CROSS)gcc
CPP             := $(CROSS)gcc -E
CXX             := $(CROSS)g++
LD              := $(CROSS)g++
NM              := $(CROSS)nm
OBJCOPY         := $(CROSS)objcopy
OBJDUMP         := $(CROSS)objdump
SIZE            := $(CROSS)size
GDB             := gdb-multiarch

RM              := rm
RMDIR           := rmdir -p --ignore-fail-on-non-empty
os              := Linux

# Strings for beautifying output
MSG_CLEAN_FILES         = "RM      *.o *.d"
MSG_CLEAN_DIRS          = "RMDIR   $(strip $(clean-dirs))"
MSG_CLEAN_DOC           = "RMDIR   $(docdir)"
MSG_MKDIR               = "MKDIR   $(dir $@)"

MSG_INFO                = "INFO    "
MSG_PREBUILD            = "PREBUILD  $(PREBUILD_CMD)"
MSG_POSTBUILD           = "POSTBUILD $(POSTBUILD_CMD)"

MSG_ARCHIVING           = "AR      $@"
MSG_ASSEMBLING          = "AS      $@"
MSG_BINARY_IMAGE        = "OBJCOPY $@"
MSG_COMPILING           = "CC      $@"
MSG_COMPILING_CXX       = "CXX     $@"
MSG_EXTENDED_LISTING    = "OBJDUMP $@"
MSG_IHEX_IMAGE          = "OBJCOPY $@"
MSG_LINKING             = "LN      $@"
MSG_PREPROCESSING       = "CPP     $@"
MSG_SIZE                = "SIZE    $@"
MSG_SYMBOL_TABLE        = "NM      $@"

# Don't use make's built-in rules and variables
MAKEFLAGS       += -rR

# Don't print 'Entering directory ...'
MAKEFLAGS       += --no-print-directory

# Function for reversing the order of a list
reverse = $(if $(1),$(call reverse,$(wordlist 2,$(words $(1)),$(1)))) $(firstword $(1))

# Hide command output by default, but allow the user to override this
# by adding V=1 on the command line.
#
# This is inspired by the Kbuild system used by the Linux kernel.
ifdef V
  ifeq ("$(origin V)", "command line")
    VERBOSE = $(V)
  endif
endif
ifndef VERBOSE
  VERBOSE = 0
endif

ifeq ($(VERBOSE), 1)
  Q =
else
  Q = @
endif

arflags-gnu-y           := $(ARFLAGS)
asflags-gnu-y           := $(ASFLAGS)
cflags-gnu-y            := $(CFLAGS)
cxxflags-gnu-y          := $(CXXFLAGS)
cppflags-gnu-y          := $(CPPFLAGS)
cpuflags-gnu-y          :=
dbgflags-gnu-y          := $(DBGFLAGS)
libflags-gnu-y          := $(foreach LIB,$(LIBS),-l$(LIB))
ldflags-gnu-y           := $(LDFLAGS)
flashflags-gnu-y        :=
clean-files             :=
clean-dirs              :=

clean-files             += $(wildcard $(target) $(project).map)
clean-files             += $(wildcard $(project).hex $(project).bin)
clean-files             += $(wildcard $(project).lss $(project).sym)
clean-files             += $(wildcard $(build))

# Use pipes instead of temporary files for communication between processes
cflags-gnu-y    += -pipe
asflags-gnu-y   += -pipe
ldflags-gnu-y   += -pipe

# Archiver flags.
arflags-gnu-y   += rcs

# Always enable warnings. And be very careful about implicit
# declarations.
cflags-gnu-y    += -Wall -Wstrict-prototypes -Wmissing-prototypes
cflags-gnu-y    += -Werror-implicit-function-declaration
cxxflags-gnu-y  += -Wall
# IAR doesn't allow arithmetic on void pointers, so warn about that.
cflags-gnu-y    += -Wpointer-arith
cxxflags-gnu-y  += -Wpointer-arith

# Preprocessor flags.
cppflags-gnu-y  += $(foreach INC,$(INC_PATH),-I$(INC))
cppflags-gnu-y  += -I. 
asflags-gnu-y   += $(foreach INC,$(INC_PATH),'-Wa,-I$(INC)')

# CPU specific flags.
cpuflags-gnu-y  += -mcpu=$(ARCH) -mthumb -D=__$(PART)__

# Dependency file flags.
depflags        = -MD -MP -MQ $@

# Debug specific flags.
ifdef BUILD_DEBUG_LEVEL
dbgflags-gnu-y  += -g$(BUILD_DEBUG_LEVEL)
else
dbgflags-gnu-y  += -g3
endif

# Optimization specific flags.
ifdef BUILD_OPTIMIZATION
optflags-gnu-y  = -O$(BUILD_OPTIMIZATION)
else
optflags-gnu-y  = $(OPTIMIZATION)
endif

# Always preprocess assembler files.
asflags-gnu-y   += -x assembler-with-cpp
# Compile C files using the GNU99 standard.
cflags-gnu-y    += -std=gnu99
# Compile C++ files using the GNU++98 standard.
cxxflags-gnu-y  += -std=c++11

# Don't use strict aliasing (very common in embedded applications).
cflags-gnu-y    += -fno-strict-aliasing
cxxflags-gnu-y  += -fno-strict-aliasing

# Separate each function and data into its own separate section to allow
# garbage collection of unused sections.
cflags-gnu-y    += -ffunction-sections -fdata-sections
cxxflags-gnu-y  += -ffunction-sections -fdata-sections

# Various cflags.
cflags-gnu-y += -Wchar-subscripts -Wcomment -Wformat=2 -Wimplicit-int
cflags-gnu-y += -Wmain -Wparentheses
cflags-gnu-y += -Wsequence-point -Wreturn-type -Wswitch -Wtrigraphs -Wunused
cflags-gnu-y += -Wuninitialized -Wunknown-pragmas -Wfloat-equal -Wundef
cflags-gnu-y += -Wshadow -Wbad-function-cast -Wwrite-strings
cflags-gnu-y += -Wsign-compare -Waggregate-return
cflags-gnu-y += -Wmissing-declarations
cflags-gnu-y += -Wformat -Wmissing-format-attribute -Wno-deprecated-declarations
cflags-gnu-y += -Wpacked -Wredundant-decls -Wnested-externs -Wlong-long
cflags-gnu-y += -Wunreachable-code
cflags-gnu-y += -Wcast-align
cflags-gnu-y += --param max-inline-insns-single=500

# To reduce application size use only integer printf function.
cflags-gnu-y += -Dprintf=iprintf

# Use newlib-nano to reduce application size
ldflags-gnu-y   += --specs=nano.specs

# Garbage collect unreferred sections when linking.
ldflags-gnu-y   += -Wl,--gc-sections

# If a custom build directory is specified, use it -- force trailing / in directory name.
ifdef BUILD_DIR
	build-dir       := $(dir $(BUILD_DIR))$(if $(notdir $(BUILD_DIR)),$(notdir $(BUILD_DIR))/)
else
	build-dir        =
endif

# Use the linker script if provided by the project.
ifneq ($(strip $(linker_script)),)
ldflags-gnu-y   += -Wl,-T $(linker_script)
endif

# Output a link map file and a cross reference table
ldflags-gnu-y   += -Wl,-Map=$(build-dir)$(project).map,--cref

# Add library search paths relative to the top level directory.
ldflags-gnu-y   += $(foreach _LIB_PATH,$(addprefix $(ASF_PRJ_PATH)/,$(LIB_PATH)),-L$(_LIB_PATH))

a_flags  = $(cpuflags-gnu-y) $(depflags) $(cppflags-gnu-y) $(asflags-gnu-y) -D__ASSEMBLY__
c_flags  = $(cpuflags-gnu-y) $(dbgflags-gnu-y) $(depflags) $(optflags-gnu-y) $(cppflags-gnu-y) $(cflags-gnu-y)
cxx_flags= $(cpuflags-gnu-y) $(dbgflags-gnu-y) $(depflags) $(optflags-gnu-y) $(cppflags-gnu-y) $(cxxflags-gnu-y)
l_flags  = -Wl,--entry=Reset_Handler -Wl,--cref $(cpuflags-gnu-y) $(optflags-gnu-y) $(ldflags-gnu-y)
ar_flags = $(arflags-gnu-y)


# Create object files list from source files list.
obj-y                   := $(addprefix $(build-dir), $(addsuffix .o,$(basename $(CSRCS) $(ASSRCS))))
$(info    obj-y is $(obj-y))
#$(info $$obj-y is [${obj-y}])
# Create dependency files list from source files list.
dep-files               := $(wildcard $(foreach f,$(obj-y),$(basename $(f)).d))

clean-files             += $(wildcard $(obj-y))
clean-files             += $(dep-files)

clean-dirs              += $(call reverse,$(sort $(wildcard $(dir $(obj-y)))))

# Default target.
.PHONY: all
ifeq ($(project_type),all)
all:
	$(MAKE) all PROJECT_TYPE=flash
	$(MAKE) all PROJECT_TYPE=sram
else
ifeq ($(target_type),lib)
all: $(target) $(project).lss $(project).sym
else
ifeq ($(target_type),elf)
all: prebuild $(target) $(project).lss $(project).sym $(project).hex $(project).bin postbuild
endif
endif
endif

prebuild:
ifneq ($(strip $(PREBUILD_CMD)),)
	@echo $(MSG_PREBUILD)
	$(Q)$(PREBUILD_CMD)
endif

postbuild:
ifneq ($(strip $(POSTBUILD_CMD)),)
	@echo $(MSG_POSTBUILD)
	$(Q)$(POSTBUILD_CMD)
endif

# Clean up the project.
.PHONY: clean
clean:
	@$(if $(strip $(clean-files)),echo $(MSG_CLEAN_FILES))
	$(if $(strip $(clean-files)),$(Q)$(RM) $(clean-files),)
	@$(if $(strip $(clean-dirs)),echo $(MSG_CLEAN_DIRS))
# Remove created directories, and make sure we only remove existing
# directories, since recursive rmdir might help us a bit on the way.
ifeq ($(os),Windows)
	$(Q)$(if $(strip $(clean-dirs)),                        \
			$(RMDIR) $(strip $(subst /,\,$(clean-dirs))))
else
	$(Q)$(if $(strip $(clean-dirs)),                        \
		for directory in $(strip $(clean-dirs)); do     \
			if [ -d "$$directory" ]; then           \
				$(RMDIR) $$directory;           \
			fi                                      \
		done                                            \
	)
endif

# Rebuild the project.
.PHONY: rebuild
rebuild: clean all

# Debug the project in flash.
.PHONY: debug_flash
debug_flash: all
	gdb-multiarch -iex "target extended-remote localhost:3333" $(ELF)

.PHONY: objfiles
objfiles: $(obj-y)

# Create object files from C source files.
$(build-dir)%.o: %.c $(MAKEFILE_PATH) config.mk
	$(Q)test -d $(dir $@) || echo $(MSG_MKDIR)
	$(Q)test -d $(dir $@) || mkdir -p $(dir $@)
	@echo $(MSG_COMPILING)
	$(Q)$(CC) $(c_flags) -c $< -o $@

# Create object files from C++ source files.
$(build-dir)%.o: %.cpp $(MAKEFILE_PATH) config.mk
	$(Q)test -d $(dir $@) || echo $(MSG_MKDIR)
	$(Q)test -d $(dir $@) || mkdir -p $(dir $@)
	echo $(MSG_COMPILING_CXX)
	$(Q)$(CXX) $(cxx_flags) -c $< -o $@

# Preprocess and assemble: create object files from assembler source files.
$(build-dir)%.o: %.S $(MAKEFILE_PATH) config.mk
	$(Q)test -d $(dir $@) || echo $(MSG_MKDIR)
	$(Q)test -d $(dir $@) || mkdir -p $(dir $@)
	@echo $(MSG_ASSEMBLING)
	$(Q)$(CC) $(a_flags) -c $< -o $@

# Include all dependency files to add depedency to all header files in use.
include $(dep-files)

ifeq ($(target_type),lib)
# Archive object files into an archive
$(target): $(MAKEFILE_PATH) config.mk $(obj-y)
	@echo $(MSG_ARCHIVING)
	$(Q)$(AR) $(ar_flags) $@ $(obj-y)
	@echo $(MSG_SIZE)
	$(Q)$(SIZE) -Bxt $@
else
ifeq ($(target_type),elf)
# Link the object files into an ELF file. Also make sure the target is rebuilt
# if the common Makefile.sam.in or project config.mk is changed.
$(target): $(linker_script) $(MAKEFILE_PATH) config.mk $(obj-y)
	@echo $(MSG_LINKING)
	$(Q)$(LD) $(l_flags) $(obj-y) $(libflags-gnu-y) -o $(build-dir)$@
	@echo $(MSG_SIZE)
	$(Q)$(SIZE) -Ax $(build-dir)$@
	$(Q)$(SIZE) -Bx $(build-dir)$@
endif
endif

# Create extended function listing from target output file.
%.lss: $(build-dir)$(target)
	@echo $(MSG_EXTENDED_LISTING)
	$(Q)$(OBJDUMP) -h -S $< > $(build-dir)$@

# Create symbol table from target output file.
%.sym: $(build-dir)$(target)
	@echo $(MSG_SYMBOL_TABLE)
	$(Q)$(NM) -n $< > $(build-dir)$@

# Create Intel HEX image from ELF output file.
%.hex: $(build-dir)$(target)
	@echo $(MSG_IHEX_IMAGE)
	$(Q)$(OBJCOPY) -O ihex $(flashflags-gnu-y)  $< $(build-dir)$@

# Create binary image from ELF output file.
%.bin: $(build-dir)$(target)
	@echo $(MSG_BINARY_IMAGE)
	$(Q)$(OBJCOPY) -O binary $< $(build-dir)$@

.PHONY: build
build:
	$(MAKE) all BUILD_DIR=build