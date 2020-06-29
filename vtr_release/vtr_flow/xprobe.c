#include <X11/Xlib.h> 
int main()
    { exit(XOpenDisplay(NULL) ? 0 : 1);  } 
