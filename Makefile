CFLAGS = -march=native -O3 -Wall -Wextra -std=c99 -Wimplicit-function-declaration -Wunused-parameter -Wshadow -Wdouble-promotion -Wundef -fno-common -fstack-usage -Wconversion -ffunction-sections -Wpadded -fshort-enums -ffast-math
CXXFLAGS = -march=native -O3 -Wall -Wextra -std=c++17 -Wno-unused-parameter -Wshadow -Wdouble-promotion -Wundef -fno-common -fstack-usage -Wconversion -ffunction-sections -Wpadded -fshort-enums -ffast-math

PREFIX = /usr/local
INSTALLDIR = $(PREFIX)/bin
TARGET = aerial
CC = cc
CXX = c++
RM = rm -rf
SRCDIR = src
OBJDIR = obj
SRC := $(wildcard $(SRCDIR)/*.c)
CXXSRC := $(wildcard $(SRCDIR)/*.cpp)
INC := $(wildcard $(INCDIR)/*.h)
OBJS := $(SRC:$(SRCDIR)/%.c=$(OBJDIR)/%.o)
CXXOBJS += $(CXXSRC:$(SRCDIR)/%.cpp=$(OBJDIR)/%.o)



$(TARGET): ${OBJS} ${CXXOBJS}
	$(CXX) $(CXXFLAGS) $(CFLAGS) $(CXXOBJS) $(OBJS) -o $@

all: ${OBJS} ${CXXOBJS}

$(OBJS): $(OBJDIR)/%.o : $(SRCDIR)/%.c
	mkdir -p $(INCDIR) $(OBJDIR)
	$(CC) $(CFLAGS) -c $< -o $@
	@echo "Compiliation complete."


$(CXXOBJS): $(OBJDIR)/%.o : $(SRCDIR)/%.cpp
	mkdir -p $(INCDIR) $(OBJDIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@
	@echo "Compiliation complete."



.PHONY: install
install:
	mkdir -p ${DESTDIR}/${PREFIX}/bin
	cp -f $(TARGET) ${DESTDIR}${PREFIX}/bin
	@echo "Installation complete."
.PHONY: clean
clean:
	$(RM) $(OBJS) $(CXXOBJS)
	@echo "Clean complete."
.PHONY: fullclean
fc:
	$(RM) $(OBJDIR)/*
	$(RM) $(TARGET)
	@echo "Clean complete."
.PHONY: uninstall
uninstall:
	$(RM) ${DESTDIR}${PREFIX}/bin/$(TARGET)
	@echo "Uninstallation complete."
