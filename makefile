CC       := $(CROSS_COMPILE)gcc
LD       := $(CROSS_COMPILE)ld
AR       := $(CROSS_COMPILE)ar
OBJCOPY  := $(CROSS_COMPILE)objcopy
OBJDUMP  := $(CROSS_COMPILE)objdump
CFLAGS   := -Wall -O2
CPPFLAGS := -nostdinc

objs := start.o
boot.bin:$(objs)
	$(LD) -o boot.elf -T simboot.lds $^
	$(OBJCOPY) -O binary -S boot.elf $@
	$(OBJDUMP) -D -m arm boot.elf > boot.dis
  
%.o:%.s
	$(CC) -o $@ -c $< $(CFLAGS)

clean:
	rm -r *.o *.elf *.bin *.dis
