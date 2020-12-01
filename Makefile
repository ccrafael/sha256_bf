CC=/usr/local/cuda/bin/nvcc
LIBS=
CFLAGS=-dc -ccbin g++-7 -arch=sm_61 -Xptxas -O3
LINK_FLAGS=-rdc=true -cudart=shared -std=c++11 -arch=sm_61  -Xptxas -O3
LPATH=-L/usr/local/cuda/lib64
IPATH=-I/usr/local/cuda/include  
SRC=src/main
SRC_TEST=src/test
OBJ=obj

CU_SOURCES=$(wildcard $(SRC)/*.cu)
CU_OBJECTS=$(patsubst $(SRC)/%.cu, $(OBJ)/%.o, $(CU_SOURCES))

CPP_SOURCES=$(wildcard $(SRC)/*.cpp)
CPP_OBJECTS=$(patsubst $(SRC)/%.cpp, $(OBJ)/%.o, $(CPP_SOURCES))

TEST_HEADERS=$(wildcard $(SRC_TEST)/*.h)
TEST_SOURCES=$(wildcard $(SRC_TEST)/*.cpp)


all: $(CU_OBJECTS) $(CPP_OBJECTS) 
	$(CC) $(LINK_FLAGS) $(CU_OBJECTS) $(CPP_OBJECTS) $(LPATH) $(IPATH) $(LIBS) -o bin/sha256_bf

run_tests: clean test
	bin/runner

test: runner.cpp  $(CPP_OBJECTS)
	g++ -o bin/runner  $(CPP_OBJECTS) $(SRC_TEST)/runner.cpp

$(OBJ)/%.o: $(SRC)/%.cu
	$(CC) $(CFLAGS)  -c $< -o $@

$(OBJ)/%.o: $(SRC)/%.cpp
	$(CC) $(CFLAGS)  -c $< -o $@

$(OBJ)/%.o: $(SRC_TEST)/%.cpp
	$(CC) $(CFLAGS)  -c $< -o $@

runner.cpp: $(TEST_HEADERS)
	cxxtestgen --error-printer -o $(SRC_TEST)/runner.cpp $(SRC_TEST)/combinations_test.h

clean:
	rm -f obj/*
	rm -f bin/*
	rm -f src/test/runner.cpp