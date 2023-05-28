// Program that continually reads the switches' value, and writes it to the SSDs as a 4-digit number
// It allows the user to change the format of that number

// Include the necessary header file(s)
#include "wramp.h"

// Int representing the value of the switches
int switches = 0;

// Int variables that represent whether to display numbers in base 10 or 16 (1 is true, 0 is false)
// It is set so that numbers are displayed in base 10 format by default
int displayBase10 = 1;
int displayBase16 = 0;


/**
 * Subroutine that displays the switch value to the SSD (in either base 10 or 16 format)
 * */ 
void displayChar()
{
    // Int variables that stores the digits of the switch value
    int digit1;
    int digit2;
    int digit3;
    int digit4;

    // If the value should be displayed in base 10 format, get each digit in the correct format
    if (displayBase10 == 1)
    {   
        digit4 = switches % 10;
        switches /= 10;

        digit3 = switches % 10;
        switches /= 10;

        digit2 = switches % 10;
        switches /= 10;

        digit1 = switches % 10;
    }

    // If the value should be displayed in base 16 format, get each digit in the correct format
    if (displayBase16 == 1)
    {
        digit4 = switches % 16;
        switches /= 16;

        digit3 = switches % 16;
        switches /= 16;

        digit2 = switches % 16;
        switches /= 16;

        digit1 = switches % 16;
    }

    // Write each of the digits to the respective SSD register
    WrampParallel->LowerRightSSD = digit4;
    WrampParallel->LowerLeftSSD = digit3;
    WrampParallel->UpperRightSSD = digit2;
    WrampParallel->UpperLeftSSD = digit1;
}


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

        // Call displayChar() to display the switch value to the SSDs
        displayChar(); 
    }
}

