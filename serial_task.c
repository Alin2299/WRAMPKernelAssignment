// Program that has a global system uptime variable called counter
// that is continually read and printed to Serial Port 2 (can be in different formats)

// Include the necessary header file(s)
#include "wramp.h"

// Global int variable that represents the system uptime
int counter = 0;

// (Global) char variable that specifies what format to display counter in - By default display in seconds to 2dp
char receivedChar = '1';


/**
 * Subroutine that displays a character to the second serial port
 * Parameters: char c - The character to be displayed
*/
void printChar(char c) {
	// Loop while the TDS bit is not set yet
	while(!(WrampSp2->Stat & 2));
	
	// Write the character to the serial port
	WrampSp2->Tx = c;
}

/**
 * Subroutine that handles characters receiving by the second serial port
 * Returns: A char representing the received character
*/
char receiveChar()
{
    // If the RDR bit is not set yet, simply return the unchanged current received character
    if(!(WrampSp2->Stat & 1))
        return receivedChar;

    // Return the current character in the serial port
    return WrampSp2->Rx;
}

/**
 * Main subroutine
*/
void serial_main()
{
    // Infinite (while) loop
    while(1)
    {
        // Int variable that is a copy of the global counter for local calculations
        int tempCounter = counter;

        // Char variable that stores the previous format
        char previousChar = receivedChar;

        // Continuously check/get new characters from the second serial port (Checking for format updates)
        receivedChar = receiveChar();

        // Print the carriage return character
        printChar('\r');

        // If the format is seconds printed to two decimal places (I.e 1 is pressed), get the appropriate digits/chars to display
        // and display them
        if (receivedChar == '1')
        {
            int digit6;
            int digit5;
            int digit4;
            int digit3;
            int digit2;
            int digit1;

            digit6 = tempCounter % 10;
            tempCounter /= 10;
            digit6 += '0';

            digit5 = tempCounter % 10;
            tempCounter /= 10;
            digit5 += '0';

            digit4 = tempCounter % 10;
            tempCounter /= 10;
            digit4 += '0';

            digit3 = tempCounter % 10;
            tempCounter /= 10;
            digit3 += '0';

            digit2 = tempCounter % 10;
            tempCounter /= 10;
            digit2+= '0';

            digit1 = tempCounter % 10;
            digit1 += '0';

            printChar(digit1);
            printChar(digit2);
            printChar(digit3);
            printChar(digit4);
            printChar('.');
            printChar(digit5);
            printChar(digit6);

            previousChar = '1';
        }

        // If the format is minutes and seconds (I.e 2 is pressed), get the appropriate digits/chars to display
        // and display them
        else if (receivedChar == '2')
        {
            int digit4;
            int digit3;
            int digit2;
            int digit1;

            int minutes = tempCounter / 100 / 60;
            int seconds = (tempCounter / 100) % 60;

            digit2 = minutes % 10;
            minutes /= 10;
            digit2 += '0';

            digit1 = minutes % 10;
            digit1 += '0';

            digit4 = seconds % 10;
            seconds /= 10;
            digit4 += '0';

            digit3 = seconds % 10;
            digit3 += '0';

            printChar(digit1);
            printChar(digit2);
            printChar(':');
            printChar(digit3);
            printChar(digit4);
            printChar(' ');
            printChar(' ');

            previousChar = '2';
        }

        // If the format is the number of timer interrupts (I.e 3 is pressed), get the appropriate digits/chars to display
        // and display them
        else if (receivedChar == '3')
        {
            int digit6;
            int digit5;
            int digit4;
            int digit3;
            int digit2;
            int digit1;

            digit6 = tempCounter % 10;
            tempCounter /= 10;
            digit6 += '0';

            digit5 = tempCounter % 10;
            tempCounter /= 10;
            digit5 += '0';

            digit4 = tempCounter % 10;
            tempCounter /= 10;
            digit4 += '0';

            digit3 = tempCounter % 10;
            tempCounter /= 10;
            digit3 += '0';

            digit2 = tempCounter % 10;
            tempCounter /= 10;
            digit2+= '0';

            digit1 = tempCounter % 10;
            digit1 += '0';

            printChar(digit1);
            printChar(digit2);
            printChar(digit3);
            printChar(digit4);
            printChar(digit5);
            printChar(digit6);
            printChar(' ');

            previousChar = '3';
        }

        // If q is pressed, exit the program by returning
        else if (receivedChar == 'q')
            return;
        
        // Else if a different character is received/input, simply display in the previous format
        else 
            receivedChar = previousChar;
        
    }
}
