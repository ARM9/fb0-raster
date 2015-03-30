#include "plot.h"

inline void plot(int x, int y, int color) {
    *(short*)(g_Framebuffer + (y * g_Vinfo.xres + x) * 2) = color;
}

