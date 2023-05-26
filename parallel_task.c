// Program that continually reads switches' value, and writes to the SSDs as a 4-digit number
// and allows the user to change the format of that number

// Include the necessary WRAMP header file
#include "wramp.h"

/**
 * Main subroutine
 * */ 
void main()
{
    // Int representing the value of the switches
    int switches = 0;

    // Infinite (while) loop
    while(1)
    {
        // Get current switch value from parallel switches register
        switches = WrampParallel->Switches;
    }
}

/**
 * Subroutine that displays a character to the SSD
 * */ 
void displayChar()
{

}