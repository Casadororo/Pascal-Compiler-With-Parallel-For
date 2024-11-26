
# Compiler and flags
CXX := g++ --std=c++14

# Directories
SRCDIR := src
BUILDDIR := build
TARGET := compilador

# Find all CPP files in src directory and its subdirectories
SOURCES := $(shell find $(SRCDIR) -type f -name *.cpp)

# Generate object file names based on source file names
OBJECTS := $(patsubst $(SRCDIR)/%,$(BUILDDIR)/%,$(SOURCES:.cpp=.o))

# Build executable
$(TARGET): $(OBJECTS) flex bison
	$(CXX) $(OBJECTS) $(BUILDDIR)/flex.cpp $(BUILDDIR)/bison.cpp -o $@

# Build object files
$(BUILDDIR)/%.o: $(SRCDIR)/%.cpp
	@mkdir -p $(@D)
	$(CXX) -c $< -o $@

flex: $(SRCDIR)/flex.l
	@mkdir -p $(BUILDDIR)
	flex $< 
	mv flex.cpp $(BUILDDIR)/flex.cpp
	mv flex.hpp $(BUILDDIR)/flex.hpp

bison: $(SRCDIR)/bison.y
	@mkdir -p $(BUILDDIR)
	bison $<
	mv bison.cpp $(BUILDDIR)/bison.cpp
	mv bison.hpp $(BUILDDIR)/bison.hpp

# Phony target to clean the build directory
.PHONY: make p
make p: clean $(TARGET)

# Phony target to clean the build directory
.PHONY: clean
clean:
	-rm -r $(BUILDDIR)
	-rm $(TARGET)
	-rm MEPA

# Phony target to run the program
.PHONY: run
run: $(TARGET)
	./$(TARGET) ./tests/type4.pas

# Phony target to run the program
.PHONY: valgrind
valgrind: $(TARGET)
	valgrind ./$(TARGET) < tests/teste1.pas
