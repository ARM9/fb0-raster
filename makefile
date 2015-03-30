
CC	:= gcc
AS	:= gcc
LD	:= gcc
GDB	:= gdb

ARCH	:= -mfpu=neon
ASFLAGS	:= $(ARCH) -g
CFLAGS	:= -Wall -Wextra -std=c99 -g -O2 -Wa,$(ARCH)
LDFLAGS	:= -flto

TARGET	:= $(shell basename $(CURDIR))
BUILD	:= build
SOURCE	:= src

SFILES	:= $(wildcard src/*.S)
CFILES	:= $(wildcard src/*.c)

INCLUDE	:= -Iinclude

export OFILES	=	$(CFILES:src/%.c=build/%.o) \
					$(SFILES:src/%.S=build/%.o)

export OUTPUT	= $(TARGET)

#------------------------------------------------------
build/%.o : src/%.c
	$(CC) $(CFLAGS) $(INCLUDE) -c $< -o $@

build/%.o : src/%.S
	$(AS) $(ASFLAGS) $(INCLUDE) -c $< -o $@
#------------------------------------------------------
.PHONY: clean

all: $(BUILD) $(OUTPUT)

$(BUILD):
	@mkdir $@

$(OUTPUT): $(OFILES)
	@echo $(OFILES)
	$(LD) $(LDFLAGS) -o $@ $(OFILES)

clean:
	@rm -rf $(OUTPUT) $(BUILD)

run: all
	./$(OUTPUT)

debug: all
	$(GDB) $(OUTPUT)

