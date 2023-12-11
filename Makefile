# Uncomment to allow debugging
# DEBUG=1
LDFLAGS := -nostdlib --static
src_asm := $(wildcard src/*.s)
src := $(patsubst %.s, %.o, $(src_asm))

default: build
ifdef DEBUG
	gdb ./server
endif
		

build: server.o $(src)
ifdef DEBUG
	gcc -g $(src) server.o -o server $(LDFLAGS)
endif
ifndef DEBUG
	gcc $(src) server.o -o server $(LDFLAGS)
endif

%.o: %.s
ifdef DEBUG
	as -g $< -o $@
endif
ifndef DEBUG
	as $< -o $@
endif

clean:
	rm server.o
	rm $(src)


