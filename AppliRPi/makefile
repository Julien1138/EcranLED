CC=g++
CFLAGS=-W -Wall -ansi -pedantic -O2 -lm -lpthread -I/usr/local/include/ImageMagick-6
LDFLAGS=-L /usr/local/lib/ -lMagick++-6.Q16
EXEC=EcranLED
SRC= $(wildcard sources/*.cpp)
OBJ= $(SRC:sources/%.cpp=out/%.o)

all: $(EXEC)

$(EXEC): $(OBJ)
	@$(CC) -o $@ $^ $(LDFLAGS)

out/%.o: sources/%.cpp
	@$(CC) -o $@ -c $< $(CFLAGS)

.PHONY: clean mrproper

clean:
	rm -rf out/*.o

mrproper: clean
	rm -rf $(EXEC)