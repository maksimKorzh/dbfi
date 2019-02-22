[
    Input a brainfuck program and its input,
    separated by an exclamation point.

    Daniel B Cristofani (cristofdathevanetdotcom)
    http://www.hevanet.com/cristofd/brainfuck/

    ASCII:   93  91  62  60  46  45  44  43   33
     char:    ]   [   >   <   .   -   ,   +    !(terminating instruction which also distinguishes
    codes:    1   2   3   4   5   6   7   8      user input from entered progam's source code)
    diffs:    2   29  2   14  1   1   1   10   32

    dbfi model for user input bf code ",[.[-],]!a":
     __________________________________________________________
    |0 |0 |7 |2 |5 |2 |6 |1 |7 |1 |0 |0 |2 |97|0 |0 |0 |0 |0 |0|
     __________________________________________________________
    |7 |2 |0 |0 |5 |2 |6 |1 |7 |1 |0 |0 |2 |97|0 |0 |0 |0 |0 |0|
     __________________________________________________________
    |7 |2 |5 |2 |0 |0 |6 |1 |7 |1 |0 |0 |2 |97|0 |0 |0 |0 |0 |0|
    
]

>>>+
[                                   // user input processing loop
    [-]                             // zero current cell flags end of input
    >>[-]                           // zero 93 minus 92 difference

    The following code sets up the array of differences
    of the ASCII codes used to represent the instructions
    of brainfuck in descending order:

    2   29  2   14  1   1   1   10  32

    ++                              // 93 minus 92 = 2
    >+                              // 91 minus 62 = 29
    >+++++++[<++++>>++<-]++         // 62 minus 60 = 2
    >                               // 60 minus 46 = 14
    >+                              // 46 minus 45 = 1
    >+                              // 45 minus 44 = 1
    >+++++[>++>++++++<<-]+          // 44 minus 43 = 1
    >                               // 43 minus 33 = 10
    >                               // last difference for 33 is temporary 30
    >,                              // get user input

    <++                             // difference for 33 is now 32

    The following loop compares user input with commands
    via substracting ASCII code differences from the user
    input until 
     

    [                               
        [                           // this loop is executed (n = difference) n times
            >[->>]<                 // decrement user input if it doesn't equal to 0
            [>>]<<                  // resynchronize pointer location
            -                       // difference is decremented until equals to 0
        ]

        <[<]<                       // go to the cell storing instruction cell
        +                           // increment it
        >>[>]>                      // go back to user input cell
        
        [                           // user input must be at least 1 to enter loop
            <+>-                    // set the flag one cell before user input
            [                       // if user input is greater than 0
                [<+>-]              // add user input to flag before it
                >                   // if user input is 2 or more then skip next loop
            ]
            
            <                       // go back to user input
            
            [                       // enters this loop on exact instruction match
                [[-]<]              // clear the rest of array of differences
                ++                  // cell next to instruction cell is set to 2(marker)
                <-                  // instruction cell is decreased by one

                [                   // enters this loop if not terminating instruction 
                    <+++++++++      // set cell before instruction cell to 9
                    >[<->-]         // 9 minus instruction cell value = instruction code
                    >>              // skip to cells after instruction code
                ]

                >>                  // gets here on terminating instruction
            ]
        ]<<
    ]<

    At this point we could match the terminating instruction
    and in this case user input processing loop is terminated
    but in cases either matching the instruction or comment the
    loop is repeated
]

<

[                                   // command processing loop

    The map of array after terminating user input processing loop:

    simulated instruction pointer   // represented by two zeros
    encoded instructions            // represented by numbers from 1 to 8
    gap between source and data     // represented by two zeros
    simulated data pointer          // represented by 2
    simulated data cell

    after this point each element in following simulated data array is
    represented by two cells; the first one is a simulated data pointer
    marker(set to 2 to represent the position of simulated data pointer)
    while the second one is the simulated data cell itself

    [<]>                            // go to the first encoded instruction

    [
        [>]>>[>>]                   // go through the simulated code and data
        
        +                           // make a copy of the instruction code as a string
                                    // of ones in the marker cells to the right of the
                                    // simulated pointer
                                    
        [<<]<[<]                    // go back to simulated instruction pointer 
        <+>>                        // move next instruction code two cells to the left
        -                           // decrement the encoded instruction
    ]

    >[>]                            // go to the gap between simulated code and simulated data
    +[->>]                          // go through the marker cells of the simulated data array
    <<<<                            // go two marker cells right
    [                               // case for close loop instruction (instruction code 1)
        [<<]<[<]                    // go to simulated instruction pointer
        +                           // set marker cell to 1 for closing loop bracket
        <<                          // go back to put the simulated instruction pointer inside the loop

        This is the main instruction moving loop which continues until the depth counter becomes 0
        Instruction codes are moved two cells right; the depth counter is incremented for each
        close loop bracket and decremented for each open loop bracket
        We use nested loops to adjust the depth based on the instruction code

        [                           
            +                       // increment depth counter on closing loop bracket
            >+<<-                   // one unit of the instruction code is moved right

            If that zeroes the instruction code it was indeed closing loop bracket
            so we skip past the rest of the processing
            
            [
                >--                 // the depth counter is decremented twice
                >+<<-               // second unit of the instruction code is moved right
                [                   // case of non bracket instruction
                    >+<             // increment the depth counter to undo the previous decrement
                    [>>+<<-]        // move the rest of the instruction code right
                ]
            ]

            >[<+>-]<                // move the depth counter to the left and test whether it's zero yet
        ]

        ++>>-->[>]>>[>>]            // continue the instruction moving loop
    ]
    
    <<
    
    [                               // case for the open loop instruction (instruction code 2)
        >>+<                        // move the simulated pointer right by setting an extra marker cell to 1
        [[<]<]>                     // go to the value cell at the simulated pointer's previous location
        [[<<]<[<]                   // go to simulated instruction pointer
        +                           // set depth to 1 for loop brackets to find matching one

        [                           // instruction moving loop
            -<+>>-
            [
                <<+>++>-
                [<->[<<+>>-]]
            ]
            <[>+<-]>
        ]
        
        >[>]>]                      // go to the second 0 separating the simulated code from the simulated data
        >[>>]>>                     // leave the pointer two marker cells right of the new temp nonzero marker cell
    ]
    
    <<

    [>>+>>+>>]                      // case move simulated data pointer right (instruction code 3)

    <<

    [->>>>>>>>]                     // case move simulated data pointer left (instruction code 4)

    <<

    [>.>>>>>>>]                     // case print char at simulated data pointer (instruction code 5)

    <<

    [>->>>>>]                       // case decrement value at simulated data pointer (instruction code 6)

    <<

    [>,>>>]                         // case store char at simulated data pointer (instruction code 7)

    <<

    [>+>]                           // case increment value at simulated data pointer (instruction code 8)

    <<

    [+<<]<                          // go back to the simulated instruction pointer
]

