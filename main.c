#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

void* load_fb()
{
    void* addr;
    int fd;
    struct stat sb;
    off_t offset, pa_offset;
    size_t length;
    int image_fd;

    fd = open("/dev/fb0", O_RDWR);
    if (fd == -1)
    {
        printf("failed to open");
        return NULL;
    }
    if (fstat(fd, &sb) == -1)
    {
        printf("wrong file size");
        return NULL;
    }
    length = 1920*1080*4;
    pa_offset = 0;
    addr = mmap(NULL, length, PROT_WRITE | PROT_READ, MAP_SHARED, fd, pa_offset);
    if (addr == MAP_FAILED)
    {
        printf("failed to map");
        return NULL;
    }
    close(fd);
    return addr;
}

void* load_image(char* name, int* size, int a)
{
    void* addr;
    int fd;
    struct stat sb;
    off_t offset, pa_offset;
    size_t length;
    int image_fd;


    fd = open(name, O_RDWR);
    if (fd == -1)
    {
        printf("failed to open");
        return NULL;
    }
    if (fstat(fd, &sb) == -1)
    {
        printf("wrong file size");
        return NULL;
    }
    offset = 0;
    pa_offset = 0; //offset & ~(sysconf(_SC_PAGE_SIZE) - 1);
    printf("%ld\n", sb.st_size);
    length = sb.st_size - offset;
    *size = length;
    printf("%ld\n", length);

    addr = mmap(NULL, length, PROT_WRITE | PROT_READ, MAP_PRIVATE, fd, pa_offset);
    if (addr == MAP_FAILED)
    {
        printf("failed to map");
        return NULL;
    }
    close(fd);
    return addr;
}

int main(int argc, char* argv[])
{
    char* fb;
    char* mage;
    int size;
    int y_size;
    int x_size;
    int offset;
    char a = 10;
    int posx = 1920/2;
    int posy = 1080/2;

//    printf("%x\n", a);
//    return 0;

    x_size = atoi(argv[2]);
    y_size = atoi(argv[3]);
    offset = atoi(argv[4]);

    fb = load_fb();
    mage = load_image(argv[1], &size, x_size*y_size*4);
    //printf("%s", addr);   
    
    for (int y = 0; y < y_size; y++)
    {
        for (int x = 0; x < x_size; x++)
        {
   //         printf("%x\n", mage[y*x_size+x*4]&255);
  //          printf("%x\n", mage[y*x_size+x*4+1]&255);
 //           printf("%x\n", mage[y*x_size+x*4+2]&255);
//            printf("%x\n", mage[y*x_size+x*4+3]&255);
            fb[posx*4+posy*1920*4+y*1920*4+x*4] = mage[y*x_size*4+x*4+2];
            fb[posx*4+posy*1920*4+y*1920*4+x*4+1] = mage[y*x_size*4+x*4+1];
            fb[posx*4+posy*1920*4+y*1920*4+x*4+2] = mage[y*x_size*4+x*4];
            fb[posx*4+posy*1920*4+y*1920*4+x*4+3] = mage[y*x_size*4+x*4+3];
//            fb[y*1920+x] = 0xffffffff;
  //          mage[y*72+x] = 0xffffffff;
        }
//        fb[i] = 0xffff0000;
//        printf("%c", fb[i]);
    }

    for (int y = 0; y < y_size; y++)
    {
        for (int x = 0; x < x_size; x++)
        {
//            printf("%x\n", mage[y*x_size+x]&255);
            if (mage[y*x_size*4+4*x+3] != (char) 0)
            {
            //    printf("draw");
            fb[64+y*1920*4+x*4] = mage[y*x_size*4+x*4+1];
            fb[64+y*1920*4+x*4+1] = mage[y*x_size*4+x*4+2];
            fb[64+y*1920*4+x*4+2] = mage[y*x_size*4+x*4];
            fb[64+y*1920*4+x*4+3] = mage[y*x_size*4+x*4+3];
            }
            else {
              //  printf("%x\n", mage[y*x_size*4+x*4+3]);
            }
//            fb[y*1920+x] = 0xffffffff;
  //          mage[y*72+x] = 0xffffffff;
        }
//        fb[i] = 0xffff0000;
//        printf("%c", fb[i]);
    }
//    addr[0] = 'B';
//    printf("\n%c\n", addr[0]);

    munmap(fb, size/*length + offset - pa_offset*/);

    return 0;
}
