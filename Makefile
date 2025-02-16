# Common flags
CXX = g++
MY_CFLAGS := -O2 -fPIC $(CFLAGS)
MY_CXXFLAGS := -std=c++14 -O2 -fPIC $(CXXFLAGS)
MY_CPPFLAGS := -DGRAPHENGINE_IMPL_NAMESPACE=timecube -DNDEBUG -Igraphengine/include -Itimecube -Ivsxx -Ivsxx/vapoursynth $(CPPFLAGS)
MY_LDFLAGS := $(LDFLAGS)
MY_LIBS := $(LIBS)

# Platform detection
UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)

# Detect compiler
COMPILER := $(shell $(CXX) --version | head -n 1)

# Add -fvisibility-hidden only for GCC
ifneq (,$(findstring g++,$(COMPILER)))
    MY_CXXFLAGS += -fvisibility=hidden
endif

# Platform-specific adjustments
ifeq ($(UNAME_S), Darwin)  # macOS
    LIB_EXT := .dylib
    MY_CXXFLAGS += -arch arm64
    MY_LDFLAGS += -arch arm64 -dynamiclib -undefined dynamic_lookup
else ifeq ($(OS), Windows_NT)  # Windows
    LIB_EXT := .dll
    MY_LDFLAGS += -shared
else  # Linux or other Unix-like systems
    LIB_EXT := .so
    MY_LDFLAGS += -shared
endif

# Source files
graphengine_HDRS = \
    graphengine/graphengine/cpuinfo.h \
    graphengine/graphengine/node.h \
    graphengine/graphengine/state.h \
    graphengine/include/graphengine/filter.h \
    graphengine/include/graphengine/graph.h \
    graphengine/include/graphengine/namespace.h \
    graphengine/include/graphengine/types.h

graphengine_OBJS = \
    graphengine/graphengine/cpuinfo.o \
    graphengine/graphengine/graph.o \
    graphengine/graphengine/node.o

timecube_HDRS = \
    timecube/cube.h \
    timecube/lut.h \
    timecube/timecube.h

timecube_OBJS = \
    timecube/cube.o \
    timecube/lut.o \
    timecube/timecube.o

vsxx_HDRS = \
    vsxx/vapoursynth/VapourSynth.h \
    vsxx/vapoursynth/VSConstants4.h \
    vsxx/vapoursynth/VSHelper4.h \
    vsxx/VapourSynth4++.hpp \
    vsxx/vsxx4_pluginmain.h

# X86-specific adjustments
ifeq ($(X86), 1)
    timecube/x86/lut_avx2.o: EXTRA_CXXFLAGS := -mf16c -mavx2 -mfma -march=haswell
    timecube/x86/lut_sse41.o: EXTRA_CXXFLAGS := -msse4.1
    timecube/x86/lut_avx512.o: EXTRA_CXXFLAGS := -mf16c -mfma -mavx512f -mavx512cd -mavx512vl -mavx512bw -mavx512dq -mtune=skylake-avx512
    MY_CPPFLAGS := -DCUBE_X86 $(MY_CPPFLAGS)
endif

# Targets
all: vscube$(LIB_EXT)

benchmark/benchmark: benchmark/main.o $(timecube_OBJS) $(graphengine_OBJS)
	$(CXX) $(MY_LDFLAGS) $^ $(MY_LIBS) -o $@

vscube$(LIB_EXT): vscube/vscube.o vsxx/vsxx4_pluginmain.o $(timecube_OBJS) $(graphengine_OBJS)
	$(CXX) -dynamiclib $(MY_LDFLAGS) $^ $(MY_LIBS) -o $@

clean:
	rm -f *.a *.o *$(LIB_EXT) benchmark/benchmark benchmark/*.o graphengine/graphengine/*.o timecube/*.o vscube/*.o vsxx/*.o

%.o: %.cpp $(graphengine_HDRS) $(timecube_HDRS) $(vsxx_HDRS)
	$(CXX) -c $(EXTRA_CXXFLAGS) $(MY_CXXFLAGS) $(MY_CPPFLAGS) $< -o $@

.PHONY: clean