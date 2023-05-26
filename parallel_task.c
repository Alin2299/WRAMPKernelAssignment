// Program that continually reads switches' value, and writes to the SSDs as a 4-digit number
// and allows the user to change the format of that number

// Include the necessary header files
#include "wramp.h"

// Int representing the value of the switches
int switches = 0;

// Int variables that represent whether to display numbers in base 10 or 16 (1 is true, 0 is false)
int displayBase10 = 1;
int displayBase16 = 0;

/**
 * Main subroutine
 * */ 
void main()
{

    // Infinite (while) loop
    while(1)
    {
        // Get current switch value from parallel switches register
        switches = WrampParallel->Switches;

        // If button 0 pushed, display numbers in base 10 
        if (WrampParallel->Buttons == 1)
        {
            displayBase10 = 1;
            displayBase16 = 0;
        }

        // Else if button 1 pushed, display numbers in base 16
        else if (WrampParallel->Buttons == 2)
        {
            displayBase10 = 0;
            displayBase16 = 1;
        }

        // Else if button 2 pushed, exit program by returning 
        else if (WrampParallel->Buttons == 4)
            return;

        displayChar();
    }
}

/**
 * Subroutine that displays a character to the SSD
 * */ 
void displayChar()
{
    if (displayBase10 == 1)
    {
        
    }

    else if (displayBase16 == 1)
    {
        char hexSwitchesValue[5];
        sprintf(hexSwitchesValue, "%04X", switches);

        WrampParallel->LowerRightSSD = hexSwitchesValue[1];
        WrampParallel->LowerLeftSSD = hexSwitchesValue[2];
        WrampParallel->UpperRightSSD = hexSwitchesValue[3];
        WrampParallel->UpperLeftSSD = hexSwitchesValue[4];
    }
}
