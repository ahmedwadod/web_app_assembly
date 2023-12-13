# Uncomment to allow debugging
# DEBUG=1
LDFLAGS := -nostdlib --static
src_asm := $(wildcard src/**/*.s) $(wildcard src/*.s)
src := $(patsubst %.s, %.o, $(src_asm))
public := $(filter-out public/README.md, $(wildcard public/*.*))
webfiles := $(filter-out web/README.md, $(wildcard web/*.*))

default: build web
	mkdir -p dist
	mv server dist/server
	
ifdef DEBUG
	cd dist;gdb ./server
endif
ifndef DEBUG
	cd dist;./server
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

web: $(public) $(webfiles)
	mkdir -p dist/web-content
	cp $^ dist/web-content/

clean:
	-rm server.o
	-rm $(src)
	-rm -rf dist


