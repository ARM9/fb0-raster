
CC	:= gcc
AS	:= gcc
LD	:= gcc

CFLAGS	:= -Wall -Wextra -std=c99 -O2
LDFLAGS	:= -flto

TARGET	:= $(shell basename $(CURDIR))
BUILD	:= build
SOURCE	:= src

CFILES	:= $(wildcard src/*.c)

export OFILES	= $(CFILES:src/%.c=build/%.o)
export OUTPUT	= $(TARGET)

#------------------------------------------------------
build/%.o : src/%.c
	$(CC) $(CFLAGS) -c $< -o $@
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

