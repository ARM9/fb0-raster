#ifndef PLOT_H
#define PLOT_H
#include <linux/fb.h>

typedef struct Screen_t {
    unsigned width, height;
    unsigned *fb_ptr;
    unsigned pitch;
    unsigned size;
} Screen_t;

Screen_t g_Screen;

int g_Fbfd;
char *g_Framebuffer;
long int g_Screensize;

struct fb_var_screeninfo g_Vinfo;
struct fb_fix_screeninfo g_Finfo;

void plot(int x, int y, int color);

void drawLine(int x1, int y1, int x2, int y2, int color);
void drawCircle(int x1, int y1, int radius, int color);

#endif //PLOT_H
