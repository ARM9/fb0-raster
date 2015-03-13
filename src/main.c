#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <linux/fb.h>
#include <sys/mman.h>

int main(int argc, char *argv[])
{
    int fbfd = 0;
    struct fb_var_screeninfo var_info;
    struct fb_fix_screeninfo finfo;
    long int screensize = 0;
    char *fbp = 0;

    fbfd = open ("/dev/fb0", O_RDWR);
    if(fbfd == -1) {
        printf("Error opening framebuffer\n");
        return 1;
    }
    printf ("opened framebuffer\n");

    if(ioctl(fbfd, FBIOGET_FSCREENINFO, &finfo)){
        printf("Error reading fixed information\n");
    }

    if(ioctl(fbfd, FBIOGET_VSCREENINFO, &var_info)) {
        printf("Error reading screen info\n");
    }

    printf("Display info %dx%d, %d bpp\n",
            var_info.xres, var_info.yres,
            var_info.bits_per_pixel);

    screensize = finfo.smem_len;

    fbp = (char*)mmap(0,
                        screensize,
                        PROT_READ | PROT_WRITE,
                        MAP_SHARED,
                        fbfd, 0);

    if((int)fbp == -1) {
        printf("mmap fail\n");
    } else {
        memset(fbp, 0x18, screensize);
        for(int i = 0; i < screensize/8; i++){
            *(int*)(fbp+i*4) = i|0x0000ff;
        }
    }

    munmap(fbp, screensize);
    close(fbfd);

    return 0;
}
