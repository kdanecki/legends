#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <signal.h>
#include <string.h>

typedef struct image
{
    char* buf;
    int size_x;
    int size_y;
} image;

typedef struct creature
{
    image images[4];
} creature;

char* fb;
char* bg[4];
creature creatures[5];

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

void* load_image(char* name)
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
//    printf("%ld\n", sb.st_size);
    length = sb.st_size - offset;
//    printf("%ld\n", length);

    addr = mmap(NULL, length, PROT_WRITE | PROT_READ, MAP_PRIVATE, fd, pa_offset);
    if (addr == MAP_FAILED)
    {
        printf("failed to map");
        return NULL;
    }
    close(fd);
    return addr;
}

void* load_world()
{
    void* addr;
    int fd;
    struct stat sb;
    off_t offset, pa_offset;
    size_t length;

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

void redraw(int sig)
{
    FILE* world;
    int pos_x;
    int pos_y;
    int creature;
    int state;
    int type;

    //memset(fb, 0, 1920*1080*4);
    //printf("\x1b[2J");

    world = fopen("world", "r");
    fscanf(world, "%d\n", &type);
    memcpy(fb, bg[type], 1920*1080*4);
    while(fscanf(world, "%d %d %d %d\n", &creature, &state, &pos_x, &pos_y) == 4)
    {
        for (int y = 0; y < creatures[creature].images[state].size_y; y++)
        {
            for (int x = 0; x < creatures[creature].images[state].size_x; x++)
            {
                if (pos_x*4+pos_y*1920*4+y*1920*4+x*4+3 < 1920*1080*4 && creatures[creature].images[state].buf[y*creatures[creature].images[state].size_x*4+x*4+3] != 0)
                {
                    fb[pos_x*4+pos_y*1920*4+y*1920*4+x*4] = creatures[creature].images[state].buf[y*creatures[creature].images[state].size_x*4+x*4+2];
                    fb[pos_x*4+pos_y*1920*4+y*1920*4+x*4+1] = creatures[creature].images[state].buf[y*creatures[creature].images[state].size_x*4+x*4+1];
                    fb[pos_x*4+pos_y*1920*4+y*1920*4+x*4+2] = creatures[creature].images[state].buf[y*creatures[creature].images[state].size_x*4+x*4];
                    fb[pos_x*4+pos_y*1920*4+y*1920*4+x*4+3] = creatures[creature].images[state].buf[y*creatures[creature].images[state].size_x*4+x*4+3];
                }
            }
        }
    }
    fclose(world);
    printf("\n");

}

int main(int argc, char* argv[])
{

    char* mage;
    int size;
    int y_size;
    int x_size;
    int offset;
    char a = 10;

//    printf("%x\n", a);
//    return 0;

    x_size = atoi(argv[2]);
    y_size = atoi(argv[3]);
    offset = atoi(argv[4]);

    fb = load_fb();
    bg[0] = load_image("images/grass.data");
    bg[1] = load_image("images/forest.data");
    bg[2] = load_image("images/mountains.data");
    // mage
    creatures[0].images[1].size_x = 72;
    creatures[0].images[1].size_y = 72;
    creatures[0].images[1].buf = load_image("images/mag.data");
    // fireball
    creatures[1].images[0].size_x = 73;
    creatures[1].images[0].size_y = 31;
    creatures[1].images[0].buf = load_image("images/fireball_left.data");
    creatures[1].images[1].size_x = 29;
    creatures[1].images[1].size_y = 71;
    creatures[1].images[1].buf = load_image("images/fireball_down.data");
    creatures[1].images[2].size_x = 27;
    creatures[1].images[2].size_y = 70;
    creatures[1].images[2].buf = load_image("images/fireball_up.data");
    creatures[1].images[3].size_x = 71;
    creatures[1].images[3].size_y = 29;
    creatures[1].images[3].buf = load_image("images/fireball_right.data");
    // orc
    creatures[2].images[1].size_x = 72;
    creatures[2].images[1].size_y = 72;
    creatures[2].images[1].buf = load_image("images/orc.data");
    creatures[2].images[0].size_x = 72;
    creatures[2].images[0].size_y = 72;
    creatures[2].images[0].buf = load_image("images/orc_dead.data");
    // goblin
    creatures[3].images[1].size_x = 72;
    creatures[3].images[1].size_y = 72;
    creatures[3].images[1].buf = load_image("images/goblin.data");
    creatures[3].images[0].size_x = 72;
    creatures[3].images[0].size_y = 72;
    creatures[3].images[0].buf = load_image("images/goblin_dead.data");
    // wolf
    creatures[4].images[1].size_x = 72;
    creatures[4].images[1].size_y = 72;
    creatures[4].images[1].buf = load_image("images/wolf.data");
    creatures[4].images[0].size_x = 72;
    creatures[4].images[0].size_y = 72;
    creatures[4].images[0].buf = load_image("images/wolf_dead.data");


    signal(SIGUSR1, redraw);
//    redraw(1);
    while (1)
    {
        sleep(10);
    }
   
    munmap(fb, 1920*1080*4/*size*//*length + offset - pa_offset*/);

    return 0;
}



   //         printf("%x\n", images[0].buf[y*x_size+x*4]&255);
  //          printf("%x\n", images[0].buf[y*x_size+x*4+1]&255);
 //           printf("%x\n", images[0].buf[y*x_size+x*4+2]&255);
//            printf("%x\n", images[0].buf[y*x_size+x*4+3]&255);
