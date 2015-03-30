#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <linux/fb.h>
#include <sys/mman.h>

#include "plot.h"

int main(int argc, char *argv[])
{

    g_Fbfd = open ("/dev/fb0", O_RDWR);

    if(g_Fbfd == -1) {
        printf("Error opening framebuffer\n");
        return 1;
    }
    printf ("opened framebuffer\n");

    if(ioctl(g_Fbfd, FBIOGET_FSCREENINFO, &g_Finfo)){
        printf("Error reading fixed information\n");
    }

    if(ioctl(g_Fbfd, FBIOGET_VSCREENINFO, &g_Vinfo)) {
        printf("Error reading screen info\n");
    }

    printf("Display info %dx%d, %d bpp\n",
            g_Vinfo.xres, g_Vinfo.yres,
            g_Vinfo.bits_per_pixel);

    g_Screensize = g_Finfo.smem_len;

    g_Framebuffer = (char*)mmap(0,
                        g_Screensize,
                        PROT_READ | PROT_WRITE,
                        MAP_SHARED,
                        g_Fbfd, 0);

    if((int)g_Framebuffer == -1) {
        printf("mmap fail\n");
        exit(EXIT_FAILURE);
    }

    g_Screen.width = g_Vinfo.xres;
    g_Screen.height = g_Vinfo.yres;
    g_Screen.fb_ptr = g_Framebuffer;
    g_Screen.pitch  = g_Vinfo.xres * (g_Vinfo.bits_per_pixel>>3);
    g_Screen.size = g_Screensize;

    int x = 0, y = 0x0f00;

    for(int t = 240; t--; ) {

        /*for(int y = 0; y < 120; y++){
            for(int x = 0; x < g_Vinfo.xres; x++){
                plot(x, y, (t<<5)+x|0x00ff);
            }
        }*/

        x++;
        y+=45;
        for(int i = 0; i < 20; i++) {
            drawCircle(600, 450, i+x, 0x00ff|y);//0x7ffe);
        }

        usleep(8000);
        /*usleep(15000);*/
        //memset(fbp, 0, screensize);
    }

    munmap(g_Framebuffer, g_Screensize);
    close(g_Fbfd);

    return 0;
}
