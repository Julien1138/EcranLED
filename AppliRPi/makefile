CC=g++
CFLAGS=-W -Wall -ansi -pedantic
LDFLAGS=
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