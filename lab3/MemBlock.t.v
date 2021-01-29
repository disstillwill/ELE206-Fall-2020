//==============================================================================
// Testbench for MemBlock
//==============================================================================

module MemBlock_test;

    // Local variables
    reg x, y;
    wire q, nq;

    // VCD Dump
    initial begin
        $dumpfile("MemBlock_test.vcd");
        $dumpvars;
    end

    // MemBlock module
    MemBlock mb(
        .x(x),
        .y(y),
        .q(q),
        .nq(nq)
    );

    // Main test
    initial begin
        x = 0;
        y = 0;

        // (0,0) -> (0,1)
        #1
        y = 1;

        // (0,1) -> (0,0)
        #1
        y = 0;

        // (0,0) -> (1,0)
        #1
        x = 1;

        // (1,0) -> (0,0)
        #1
        x = 0;

        // (0,0) -> (1,0)
        #1
        x = 1;

        // (1,0) -> (1,1)
        #1
        y = 1;

        // (1,1) -> (0,1)
        #1
        x = 0;

        // (0,1) -> (1,1)
        #1
        x = 1;

        // (1,1) -> (1,0)
        #1
        y = 0;

        // (1,0) -> (1,1)
        #1
        y = 1;

        // (1,1) -> (0,0)
        #1
        x = 0;
        y = 0;

        // Test additional sequences

        // Treat x as a clock
        #1
        x = 1;
        #1
        x = 0;
        #1
        x = 1;
        #1
        x = 0;
        #1
        x = 1;
        #1
        x = 0;
        
        // Set x and y to 0
        #1
        x = 0;
        y = 0;
        #1

        // Treat y as a clock
        #1
        y = 1;
        #1
        y = 0;
        #1
        y = 1;
        #1
        y = 0;
        #1
        y = 1;
        #1
        y = 0;

        // Set x and y to 0
        #1
        x = 0;
        y = 0;
        #1

        // Hold y at 1 and treat x as a clock
        #1
        y = 1;
        #1
        x = 1;
        #1
        x = 0;
        #1
        x = 1;
        #1
        x = 0;

        // Set x and y to 0
        #1
        x = 0;
        y = 0;
        #1

        // Hold x at 1 and treat y as a clock
        #1
        x = 1;
        #1
        y = 1;
        #1
        y = 0;
        #1
        y = 1;
        #1
        y = 0;

        // Set x and y to 0
        #1
        x = 0;
        y = 0;
        #1

        $finish;
    end

endmodule
