/*
Create by BG
Created on Sun, 26 Jan 2025 at 11:37 AM
Last modified on Tue, 28 Jan 2025 at 07:10 PM
This is the assembler for RMV-32IM Pipelined processor

Description:

This program can be used to convert manually-written textual assembly programs into machine code for CO502 laboratory experiment (RV32IM Piplined processor).

This simple assembler assumes an ISA containing the RV32IM instruction set. All instructions are encoded into 32-bit words based on the RV32IM format.
(See the documentation for more information)

This assembler will perform some basic error checks on your program. A valid instruction should contain two to four tokens separated by space character (e.g. "add x3 x2 x1", "lw x5 1(x2)"), corresponding to the details given above. In addition, empty lines and comments are permitted. A valid comment should start with "//".
DO NOT depend on this assembler to check errors in your assembly programs. You must make sure that your code is correct.

Compiling the program	: gcc Assembler.c -o Assembler
Use the assembler		: ./Assembler
Generated output file	: instr_mem.mem
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <ctype.h>

#define MAX_LINE_LENGTH 256

// OPCODES
char *OPCODE_R = "0110011";
char *OPCODE_S = "0100011";
char *OPCODE_B = "1100011";
char *OPCODE_J = "1101111";
char *OPCODE_I1 = "0000011";
char *OPCODE_I2 = "0010011";
char *OPCODE_I3 = "1100111";
char *OPCODE_U1 = "0010111";
char *OPCODE_U2 = "0110111";

// This function is used to trim leading and trailing whitespaces
char *clean_line(char *line, int length)
{
    // printf("Original line: '%s' \n", line);

    int start = 0;
    while (start < length && isspace((unsigned char)line[start]))
        start++;

    // Check if the entire line was whitespace
    if (start == length)
        return NULL;

    // Check if the entire line was an comment
    if (line[start] == '#')
        return NULL;

    char *output = line + start;

    // printf("Trimmed line: '%s'\n", output);
    return output;
}

// This function is use to generate the instruction chunks and convert it into binary image
char **generate_chunks(char *str)
{
    // Printing the instruction
    // printf("Line: '%s'\n", str);

    // Get the length of the line
    int len = strlen(str);
    // printf("number of elements: %d \n", len);

    // Allocate memory for chunks
    char **chunks = malloc(3 * sizeof(char *));
    for (int i = 0; i < 3; i++)
        chunks[i] = malloc(8 * sizeof(char));

    int current_chunk = 0;
    int current_position = 0;

    for (int i = 0; i < len; i++)
    {
        // Neglect whitespaces and 'x' register symbol
        if (isspace((unsigned)str[i]) || tolower(str[i]) == 'x')
            continue;

        // Stop chunking if a comment starts
        if (str[i] == '#')
        {
            chunks[current_chunk][current_position] = '\0';
            break;
        }

        // Break the chunk by a special character , or ( or )
        if (str[i] == ',' || str[i] == '(' || str[i] == ')')
        {
            chunks[current_chunk++][current_position] = '\0';
            current_position = 0;
        }

        else
        {
            // Otherwise insert the word into chunks
            chunks[current_chunk][current_position++] = tolower(str[i]);

            // Handling the edge case;
            if (i + 1 == len)
                chunks[current_chunk++][current_position] = '\0';
        }
    }

    return chunks;
};

// This function use to convert given integer to binary value with given padding size
char *convert_to_binary(int number, int padding)
{
    // Allocate memory
    char *binary = malloc(sizeof(char) * padding);
    if (!binary)
    {
        perror("Memory allocation failed");
        exit(1);
    }

    // printf("Decimal: %d", number);

    // Fill the binary string with 0's
    memset(binary, '0', padding);

    // Convert the number to binary from the least significant bit
    for (int i = padding - 1; i >= 0 && number > 0; i--)
    {
        binary[i] = (number & 1) ? '1' : '0';
        number = number >> 1;
    }

    // printf(" \t\t Binary: %s\n", binary);

    return binary;
}

// This is the function to copy string to the 32 bit instruction
void copy_string(char *string, char *instruction, int start, int size)
{
    for (int i = 0; i < size; i++)
    {
        instruction[(31 - start) + i] = string[i];
    }
}

// This function use to complete the instruction
void complete_instruction(char *instr, char **chunks, char *instruction_32_bit)
{
    /* ---------------------------------- R - Type ---------------------------------- */
    if (strcmp(instr, "add") == 0)
    {
        int rd = atoi(chunks[0]);
        int rs1 = atoi(chunks[1]);
        int rs2 = atoi(chunks[2]);
        copy_string(OPCODE_R, instruction_32_bit, 6, 7);                   // OPCODE
        copy_string(convert_to_binary(rd, 5), instruction_32_bit, 11, 5);  // RD
        copy_string("000", instruction_32_bit, 14, 3);                     // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5); // RS1
        copy_string(convert_to_binary(rs2, 5), instruction_32_bit, 24, 5); // RS2
        copy_string("0000000", instruction_32_bit, 31, 7);                 // FUNC7
    }

    else if (strcmp(instr, "sub") == 0)
    {
        int rd = atoi(chunks[0]);
        int rs1 = atoi(chunks[1]);
        int rs2 = atoi(chunks[2]);
        copy_string(OPCODE_R, instruction_32_bit, 6, 7);                   // OPCODE
        copy_string(convert_to_binary(rd, 5), instruction_32_bit, 11, 5);  // RD
        copy_string("000", instruction_32_bit, 14, 3);                     // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5); // RS1
        copy_string(convert_to_binary(rs2, 5), instruction_32_bit, 24, 5); // RS2
        copy_string("0100000", instruction_32_bit, 31, 7);                 // FUNC7
    }

    else if (strcmp(instr, "sll") == 0)
    {
        int rd = atoi(chunks[0]);
        int rs1 = atoi(chunks[1]);
        int rs2 = atoi(chunks[2]);
        copy_string(OPCODE_R, instruction_32_bit, 6, 7);                   // OPCODE
        copy_string(convert_to_binary(rd, 5), instruction_32_bit, 11, 5);  // RD
        copy_string("001", instruction_32_bit, 14, 3);                     // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5); // RS1
        copy_string(convert_to_binary(rs2, 5), instruction_32_bit, 24, 5); // RS2
        copy_string("0000000", instruction_32_bit, 31, 7);                 // FUNC7
    }

    else if (strcmp(instr, "slt") == 0)
    {
        int rd = atoi(chunks[0]);
        int rs1 = atoi(chunks[1]);
        int rs2 = atoi(chunks[2]);
        copy_string(OPCODE_R, instruction_32_bit, 6, 7);                   // OPCODE
        copy_string(convert_to_binary(rd, 5), instruction_32_bit, 11, 5);  // RD
        copy_string("010", instruction_32_bit, 14, 3);                     // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5); // RS1
        copy_string(convert_to_binary(rs2, 5), instruction_32_bit, 24, 5); // RS2
        copy_string("0000000", instruction_32_bit, 31, 7);                 // FUNC7
    }

    else if (strcmp(instr, "sltu") == 0)
    {
        int rd = atoi(chunks[0]);
        int rs1 = atoi(chunks[1]);
        int rs2 = atoi(chunks[2]);
        copy_string(OPCODE_R, instruction_32_bit, 6, 7);                   // OPCODE
        copy_string(convert_to_binary(rd, 5), instruction_32_bit, 11, 5);  // RD
        copy_string("011", instruction_32_bit, 14, 3);                     // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5); // RS1
        copy_string(convert_to_binary(rs2, 5), instruction_32_bit, 24, 5); // RS2
        copy_string("0000000", instruction_32_bit, 31, 7);                 // FUNC7
    }

    else if (strcmp(instr, "xor") == 0)
    {
        int rd = atoi(chunks[0]);
        int rs1 = atoi(chunks[1]);
        int rs2 = atoi(chunks[2]);
        copy_string(OPCODE_R, instruction_32_bit, 6, 7);                   // OPCODE
        copy_string(convert_to_binary(rd, 5), instruction_32_bit, 11, 5);  // RD
        copy_string("100", instruction_32_bit, 14, 3);                     // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5); // RS1
        copy_string(convert_to_binary(rs2, 5), instruction_32_bit, 24, 5); // RS2
        copy_string("0000000", instruction_32_bit, 31, 7);                 // FUNC7
    }

    else if (strcmp(instr, "srl") == 0)
    {
        int rd = atoi(chunks[0]);
        int rs1 = atoi(chunks[1]);
        int rs2 = atoi(chunks[2]);
        copy_string(OPCODE_R, instruction_32_bit, 6, 7);                   // OPCODE
        copy_string(convert_to_binary(rd, 5), instruction_32_bit, 11, 5);  // RD
        copy_string("101", instruction_32_bit, 14, 3);                     // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5); // RS1
        copy_string(convert_to_binary(rs2, 5), instruction_32_bit, 24, 5); // RS2
        copy_string("0000000", instruction_32_bit, 31, 7);                 // FUNC7
    }

    else if (strcmp(instr, "sra") == 0)
    {
        int rd = atoi(chunks[0]);
        int rs1 = atoi(chunks[1]);
        int rs2 = atoi(chunks[2]);
        copy_string(OPCODE_R, instruction_32_bit, 6, 7);                   // OPCODE
        copy_string(convert_to_binary(rd, 5), instruction_32_bit, 11, 5);  // RD
        copy_string("101", instruction_32_bit, 14, 3);                     // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5); // RS1
        copy_string(convert_to_binary(rs2, 5), instruction_32_bit, 24, 5); // RS2
        copy_string("0100000", instruction_32_bit, 31, 7);                 // FUNC7
    }

    else if (strcmp(instr, "or") == 0)
    {
        int rd = atoi(chunks[0]);
        int rs1 = atoi(chunks[1]);
        int rs2 = atoi(chunks[2]);
        copy_string(OPCODE_R, instruction_32_bit, 6, 7);                   // OPCODE
        copy_string(convert_to_binary(rd, 5), instruction_32_bit, 11, 5);  // RD
        copy_string("110", instruction_32_bit, 14, 3);                     // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5); // RS1
        copy_string(convert_to_binary(rs2, 5), instruction_32_bit, 24, 5); // RS2
        copy_string("0000000", instruction_32_bit, 31, 7);                 // FUNC7
    }

    else if (strcmp(instr, "and") == 0)
    {
        int rd = atoi(chunks[0]);
        int rs1 = atoi(chunks[1]);
        int rs2 = atoi(chunks[2]);
        copy_string(OPCODE_R, instruction_32_bit, 6, 7);                   // OPCODE
        copy_string(convert_to_binary(rd, 5), instruction_32_bit, 11, 5);  // RD
        copy_string("111", instruction_32_bit, 14, 3);                     // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5); // RS1
        copy_string(convert_to_binary(rs2, 5), instruction_32_bit, 24, 5); // RS2
        copy_string("0000000", instruction_32_bit, 31, 7);                 // FUNC7
    }

    else if (strcmp(instr, "mul") == 0)
    {
        int rd = atoi(chunks[0]);
        int rs1 = atoi(chunks[1]);
        int rs2 = atoi(chunks[2]);
        copy_string(OPCODE_R, instruction_32_bit, 6, 7);                   // OPCODE
        copy_string(convert_to_binary(rd, 5), instruction_32_bit, 11, 5);  // RD
        copy_string("000", instruction_32_bit, 14, 3);                     // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5); // RS1
        copy_string(convert_to_binary(rs2, 5), instruction_32_bit, 24, 5); // RS2
        copy_string("0000001", instruction_32_bit, 31, 7);                 // FUNC7
    }

    else if (strcmp(instr, "mulh") == 0)
    {
        int rd = atoi(chunks[0]);
        int rs1 = atoi(chunks[1]);
        int rs2 = atoi(chunks[2]);
        copy_string(OPCODE_R, instruction_32_bit, 6, 7);                   // OPCODE
        copy_string(convert_to_binary(rd, 5), instruction_32_bit, 11, 5);  // RD
        copy_string("001", instruction_32_bit, 14, 3);                     // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5); // RS1
        copy_string(convert_to_binary(rs2, 5), instruction_32_bit, 24, 5); // RS2
        copy_string("0000001", instruction_32_bit, 31, 7);                 // FUNC7
    }

    else if (strcmp(instr, "mulhsu") == 0)
    {
        int rd = atoi(chunks[0]);
        int rs1 = atoi(chunks[1]);
        int rs2 = atoi(chunks[2]);
        copy_string(OPCODE_R, instruction_32_bit, 6, 7);                   // OPCODE
        copy_string(convert_to_binary(rd, 5), instruction_32_bit, 11, 5);  // RD
        copy_string("010", instruction_32_bit, 14, 3);                     // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5); // RS1
        copy_string(convert_to_binary(rs2, 5), instruction_32_bit, 24, 5); // RS2
        copy_string("0000001", instruction_32_bit, 31, 7);                 // FUNC7
    }

    else if (strcmp(instr, "mulhu") == 0)
    {
        int rd = atoi(chunks[0]);
        int rs1 = atoi(chunks[1]);
        int rs2 = atoi(chunks[2]);
        copy_string(OPCODE_R, instruction_32_bit, 6, 7);                   // OPCODE
        copy_string(convert_to_binary(rd, 5), instruction_32_bit, 11, 5);  // RD
        copy_string("011", instruction_32_bit, 14, 3);                     // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5); // RS1
        copy_string(convert_to_binary(rs2, 5), instruction_32_bit, 24, 5); // RS2
        copy_string("0000001", instruction_32_bit, 31, 7);                 // FUNC7
    }

    else if (strcmp(instr, "div") == 0)
    {
        int rd = atoi(chunks[0]);
        int rs1 = atoi(chunks[1]);
        int rs2 = atoi(chunks[2]);
        copy_string(OPCODE_R, instruction_32_bit, 6, 7);                   // OPCODE
        copy_string(convert_to_binary(rd, 5), instruction_32_bit, 11, 5);  // RD
        copy_string("100", instruction_32_bit, 14, 3);                     // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5); // RS1
        copy_string(convert_to_binary(rs2, 5), instruction_32_bit, 24, 5); // RS2
        copy_string("0000001", instruction_32_bit, 31, 7);                 // FUNC7
    }

    else if (strcmp(instr, "divu") == 0)
    {
        int rd = atoi(chunks[0]);
        int rs1 = atoi(chunks[1]);
        int rs2 = atoi(chunks[2]);
        copy_string(OPCODE_R, instruction_32_bit, 6, 7);                   // OPCODE
        copy_string(convert_to_binary(rd, 5), instruction_32_bit, 11, 5);  // RD
        copy_string("101", instruction_32_bit, 14, 3);                     // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5); // RS1
        copy_string(convert_to_binary(rs2, 5), instruction_32_bit, 24, 5); // RS2
        copy_string("0000001", instruction_32_bit, 31, 7);                 // FUNC7
    }

    else if (strcmp(instr, "rem") == 0)
    {
        int rd = atoi(chunks[0]);
        int rs1 = atoi(chunks[1]);
        int rs2 = atoi(chunks[2]);
        copy_string(OPCODE_R, instruction_32_bit, 6, 7);                   // OPCODE
        copy_string(convert_to_binary(rd, 5), instruction_32_bit, 11, 5);  // RD
        copy_string("110", instruction_32_bit, 14, 3);                     // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5); // RS1
        copy_string(convert_to_binary(rs2, 5), instruction_32_bit, 24, 5); // RS2
        copy_string("0000001", instruction_32_bit, 31, 7);                 // FUNC7
    }

    else if (strcmp(instr, "remu") == 0)
    {
        int rd = atoi(chunks[0]);
        int rs1 = atoi(chunks[1]);
        int rs2 = atoi(chunks[2]);
        copy_string(OPCODE_R, instruction_32_bit, 6, 7);                   // OPCODE
        copy_string(convert_to_binary(rd, 5), instruction_32_bit, 11, 5);  // RD
        copy_string("111", instruction_32_bit, 14, 3);                     // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5); // RS1
        copy_string(convert_to_binary(rs2, 5), instruction_32_bit, 24, 5); // RS2
        copy_string("0000001", instruction_32_bit, 31, 7);                 // FUNC7
    }

    /* ---------------------------------- I - Type ---------------------------------- */
    else if (strcmp(instr, "lb") == 0)
    {
        int rd = atoi(chunks[0]);
        int imm = atoi(chunks[1]);
        int rs1 = atoi(chunks[2]);
        copy_string(OPCODE_I1, instruction_32_bit, 6, 7);                    // OPCODE
        copy_string(convert_to_binary(rd, 5), instruction_32_bit, 11, 5);    // RD
        copy_string("000", instruction_32_bit, 14, 3);                       // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5);   // RS1
        copy_string(convert_to_binary(imm, 12), instruction_32_bit, 31, 12); // IMM
    }

    else if (strcmp(instr, "lh") == 0)
    {
        int rd = atoi(chunks[0]);
        int imm = atoi(chunks[1]);
        int rs1 = atoi(chunks[2]);
        copy_string(OPCODE_I1, instruction_32_bit, 6, 7);                    // OPCODE
        copy_string(convert_to_binary(rd, 5), instruction_32_bit, 11, 5);    // RD
        copy_string("001", instruction_32_bit, 14, 3);                       // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5);   // RS1
        copy_string(convert_to_binary(imm, 12), instruction_32_bit, 31, 12); // IMM
    }

    else if (strcmp(instr, "lw") == 0)
    {
        int rd = atoi(chunks[0]);
        int imm = atoi(chunks[1]);
        int rs1 = atoi(chunks[2]);
        copy_string(OPCODE_I1, instruction_32_bit, 6, 7);                    // OPCODE
        copy_string(convert_to_binary(rd, 5), instruction_32_bit, 11, 5);    // RD
        copy_string("010", instruction_32_bit, 14, 3);                       // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5);   // RS1
        copy_string(convert_to_binary(imm, 12), instruction_32_bit, 31, 12); // IMM
    }

    else if (strcmp(instr, "lbu") == 0)
    {
        int rd = atoi(chunks[0]);
        int imm = atoi(chunks[1]);
        int rs1 = atoi(chunks[2]);
        copy_string(OPCODE_I1, instruction_32_bit, 6, 7);                    // OPCODE
        copy_string(convert_to_binary(rd, 5), instruction_32_bit, 11, 5);    // RD
        copy_string("100", instruction_32_bit, 14, 3);                       // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5);   // RS1
        copy_string(convert_to_binary(imm, 12), instruction_32_bit, 31, 12); // IMM
    }

    else if (strcmp(instr, "lhu") == 0)
    {
        int rd = atoi(chunks[0]);
        int imm = atoi(chunks[1]);
        int rs1 = atoi(chunks[2]);
        copy_string(OPCODE_I1, instruction_32_bit, 6, 7);                    // OPCODE
        copy_string(convert_to_binary(rd, 5), instruction_32_bit, 11, 5);    // RD
        copy_string("101", instruction_32_bit, 14, 3);                       // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5);   // RS1
        copy_string(convert_to_binary(imm, 12), instruction_32_bit, 31, 12); // IMM
    }

    else if (strcmp(instr, "addi") == 0)
    {
        int rd = atoi(chunks[0]);
        int rs1 = atoi(chunks[1]);
        int imm = atoi(chunks[2]);
        copy_string(OPCODE_I2, instruction_32_bit, 6, 7);                    // OPCODE
        copy_string(convert_to_binary(rd, 5), instruction_32_bit, 11, 5);    // RD
        copy_string("000", instruction_32_bit, 14, 3);                       // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5);   // RS1
        copy_string(convert_to_binary(imm, 12), instruction_32_bit, 31, 12); // IMM
    }

    else if (strcmp(instr, "slli") == 0)
    {
        int rd = atoi(chunks[0]);
        int rs1 = atoi(chunks[1]);
        int shamnt_i = atoi(chunks[2]);
        copy_string(OPCODE_I2, instruction_32_bit, 6, 7);                       // OPCODE
        copy_string(convert_to_binary(rd, 5), instruction_32_bit, 11, 5);       // RD
        copy_string("001", instruction_32_bit, 14, 3);                          // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5);      // RS1
        copy_string(convert_to_binary(shamnt_i, 5), instruction_32_bit, 24, 5); // SHAMNT_I
        copy_string("0000000", instruction_32_bit, 31, 7);                      // FUNC7
    }

    else if (strcmp(instr, "slti") == 0)
    {
        int rd = atoi(chunks[0]);
        int rs1 = atoi(chunks[1]);
        int imm = atoi(chunks[2]);
        copy_string(OPCODE_I2, instruction_32_bit, 6, 7);                    // OPCODE
        copy_string(convert_to_binary(rd, 5), instruction_32_bit, 11, 5);    // RD
        copy_string("010", instruction_32_bit, 14, 3);                       // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5);   // RS1
        copy_string(convert_to_binary(imm, 12), instruction_32_bit, 31, 12); // IMM
    }

    else if (strcmp(instr, "sltiu") == 0)
    {
        int rd = atoi(chunks[0]);
        int rs1 = atoi(chunks[1]);
        int imm = atoi(chunks[2]);
        copy_string(OPCODE_I2, instruction_32_bit, 6, 7);                    // OPCODE
        copy_string(convert_to_binary(rd, 5), instruction_32_bit, 11, 5);    // RD
        copy_string("011", instruction_32_bit, 14, 3);                       // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5);   // RS1
        copy_string(convert_to_binary(imm, 12), instruction_32_bit, 31, 12); // IMM
    }

    else if (strcmp(instr, "xori") == 0)
    {
        int rd = atoi(chunks[0]);
        int rs1 = atoi(chunks[1]);
        int imm = atoi(chunks[2]);
        copy_string(OPCODE_I2, instruction_32_bit, 6, 7);                    // OPCODE
        copy_string(convert_to_binary(rd, 5), instruction_32_bit, 11, 5);    // RD
        copy_string("100", instruction_32_bit, 14, 3);                       // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5);   // RS1
        copy_string(convert_to_binary(imm, 12), instruction_32_bit, 31, 12); // IMM
    }

    else if (strcmp(instr, "srli") == 0)
    {
        int rd = atoi(chunks[0]);
        int rs1 = atoi(chunks[1]);
        int shamnt_i = atoi(chunks[2]);
        copy_string(OPCODE_I2, instruction_32_bit, 6, 7);                       // OPCODE
        copy_string(convert_to_binary(rd, 5), instruction_32_bit, 11, 5);       // RD
        copy_string("101", instruction_32_bit, 14, 3);                          // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5);      // RS1
        copy_string(convert_to_binary(shamnt_i, 5), instruction_32_bit, 24, 5); // SHAMNT_I
        copy_string("0000000", instruction_32_bit, 31, 7);                      // FUNC7
    }

    else if (strcmp(instr, "srai") == 0)
    {
        int rd = atoi(chunks[0]);
        int rs1 = atoi(chunks[1]);
        int shamnt_i = atoi(chunks[2]);
        copy_string(OPCODE_I2, instruction_32_bit, 6, 7);                       // OPCODE
        copy_string(convert_to_binary(rd, 5), instruction_32_bit, 11, 5);       // RD
        copy_string("101", instruction_32_bit, 14, 3);                          // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5);      // RS1
        copy_string(convert_to_binary(shamnt_i, 5), instruction_32_bit, 24, 5); // SHAMNT_I
        copy_string("0100000", instruction_32_bit, 31, 7);                      // FUNC7
    }

    else if (strcmp(instr, "ori") == 0)
    {
        int rd = atoi(chunks[0]);
        int rs1 = atoi(chunks[1]);
        int imm = atoi(chunks[2]);
        copy_string(OPCODE_I2, instruction_32_bit, 6, 7);                    // OPCODE
        copy_string(convert_to_binary(rd, 5), instruction_32_bit, 11, 5);    // RD
        copy_string("110", instruction_32_bit, 14, 3);                       // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5);   // RS1
        copy_string(convert_to_binary(imm, 12), instruction_32_bit, 31, 12); // IMM
    }

    else if (strcmp(instr, "andi") == 0)
    {
        int rd = atoi(chunks[0]);
        int rs1 = atoi(chunks[1]);
        int imm = atoi(chunks[2]);
        copy_string(OPCODE_I2, instruction_32_bit, 6, 7);                    // OPCODE
        copy_string(convert_to_binary(rd, 5), instruction_32_bit, 11, 5);    // RD
        copy_string("111", instruction_32_bit, 14, 3);                       // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5);   // RS1
        copy_string(convert_to_binary(imm, 12), instruction_32_bit, 31, 12); // IMM
    }

    else if (strcmp(instr, "jalr") == 0)
    {
        int rd = atoi(chunks[0]);
        int imm = atoi(chunks[1]);
        int rs1 = atoi(chunks[2]);
        copy_string(OPCODE_I3, instruction_32_bit, 6, 7);                    // OPCODE
        copy_string(convert_to_binary(rd, 5), instruction_32_bit, 11, 5);    // RD
        copy_string("000", instruction_32_bit, 14, 3);                       // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5);   // RS1
        copy_string(convert_to_binary(imm, 12), instruction_32_bit, 31, 12); // IMM
    }

    /* ---------------------------------- S - Type ---------------------------------- */
    else if (strcmp(instr, "sb") == 0)
    {
        int rs2 = atoi(chunks[0]);
        int imm_s = atoi(chunks[1]);
        int rs1 = atoi(chunks[2]);

        char *imm12 = convert_to_binary(imm_s, 12);
        char imm5[6], imm7[8];

        strncpy(imm5, imm12 + 7, 5);
        strncpy(imm7, imm12, 7);
        imm5[5] = '\0';
        imm7[7] = '\0';

        copy_string(OPCODE_S, instruction_32_bit, 6, 7);                   // OPCODE
        copy_string(imm5, instruction_32_bit, 11, 5);                      // IMM5
        copy_string("000", instruction_32_bit, 14, 3);                     // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5); // RS1
        copy_string(convert_to_binary(rs2, 5), instruction_32_bit, 24, 5); // RS2
        copy_string(imm7, instruction_32_bit, 31, 7);                      // IMM7
    }

    else if (strcmp(instr, "sh") == 0)
    {
        int rs2 = atoi(chunks[0]);
        int imm_s = atoi(chunks[1]);
        int rs1 = atoi(chunks[2]);

        char *imm12 = convert_to_binary(imm_s, 12);
        char imm5[6], imm7[8];

        strncpy(imm5, imm12 + 7, 5);
        strncpy(imm7, imm12, 7);
        imm5[5] = '\0';
        imm7[7] = '\0';

        copy_string(OPCODE_S, instruction_32_bit, 6, 7);                   // OPCODE
        copy_string(imm5, instruction_32_bit, 11, 5);                      // IMM5
        copy_string("001", instruction_32_bit, 14, 3);                     // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5); // RS1
        copy_string(convert_to_binary(rs2, 5), instruction_32_bit, 24, 5); // RS2
        copy_string(imm7, instruction_32_bit, 31, 7);                      // IMM7
    }

    else if (strcmp(instr, "sw") == 0)
    {
        int rs2 = atoi(chunks[0]);
        int imm_s = atoi(chunks[1]);
        int rs1 = atoi(chunks[2]);

        char *imm12 = convert_to_binary(imm_s, 12);
        char imm5[6], imm7[8];

        strncpy(imm5, imm12 + 7, 5);
        strncpy(imm7, imm12, 7);
        imm5[5] = '\0';
        imm7[7] = '\0';

        copy_string(OPCODE_S, instruction_32_bit, 6, 7);                   // OPCODE
        copy_string(imm5, instruction_32_bit, 11, 5);                      // IMM5
        copy_string("111", instruction_32_bit, 14, 3);                     // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5); // RS1
        copy_string(convert_to_binary(rs2, 5), instruction_32_bit, 24, 5); // RS2
        copy_string(imm7, instruction_32_bit, 31, 7);                      // IMM7
    }

    /* ---------------------------------- B - Type ---------------------------------- */
    else if (strcmp(instr, "beq") == 0)
    {
        int rs1 = atoi(chunks[0]);
        int rs2 = atoi(chunks[1]);
        int imm_b = atoi(chunks[2]);

        char *imm12 = convert_to_binary(imm_b, 12);
        char imm4[5], imm6[7];

        strncpy(imm4, imm12 + 8, 4);
        strncpy(imm6, imm12 + 2, 6);
        imm4[4] = '\0';
        imm6[6] = '\0';

        copy_string(OPCODE_B, instruction_32_bit, 6, 7);                   // OPCODE
        copy_string(imm12 + 1, instruction_32_bit, 7, 1);                  // IMM[11]
        copy_string(imm4, instruction_32_bit, 11, 4);                      // IMM[4:1]
        copy_string("000", instruction_32_bit, 14, 3);                     // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5); // RS1
        copy_string(convert_to_binary(rs2, 5), instruction_32_bit, 24, 5); // RS2
        copy_string(imm6, instruction_32_bit, 30, 6);                      // IMM[10:5]
        copy_string(imm12, instruction_32_bit, 31, 1);                     // IMM[12]
    }

    else if (strcmp(instr, "bne") == 0)
    {
        int rs1 = atoi(chunks[0]);
        int rs2 = atoi(chunks[1]);
        int imm_b = atoi(chunks[2]);

        char *imm12 = convert_to_binary(imm_b, 12);
        char imm4[5], imm6[7];

        strncpy(imm4, imm12 + 8, 4);
        strncpy(imm6, imm12 + 2, 6);
        imm4[4] = '\0';
        imm6[6] = '\0';

        copy_string(OPCODE_B, instruction_32_bit, 6, 7);                   // OPCODE
        copy_string(imm12 + 1, instruction_32_bit, 7, 1);                  // IMM[11]
        copy_string(imm4, instruction_32_bit, 11, 4);                      // IMM[4:1]
        copy_string("001", instruction_32_bit, 14, 3);                     // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5); // RS1
        copy_string(convert_to_binary(rs2, 5), instruction_32_bit, 24, 5); // RS2
        copy_string(imm6, instruction_32_bit, 30, 6);                      // IMM[10:5]
        copy_string(imm12, instruction_32_bit, 31, 1);                     // IMM[12]
    }

    else if (strcmp(instr, "blt") == 0)
    {
        int rs1 = atoi(chunks[0]);
        int rs2 = atoi(chunks[1]);
        int imm_b = atoi(chunks[2]);

        char *imm12 = convert_to_binary(imm_b, 12);
        char imm4[5], imm6[7];

        strncpy(imm4, imm12 + 8, 4);
        strncpy(imm6, imm12 + 2, 6);
        imm4[4] = '\0';
        imm6[6] = '\0';

        copy_string(OPCODE_B, instruction_32_bit, 6, 7);                   // OPCODE
        copy_string(imm12 + 1, instruction_32_bit, 7, 1);                  // IMM[11]
        copy_string(imm4, instruction_32_bit, 11, 4);                      // IMM[4:1]
        copy_string("100", instruction_32_bit, 14, 3);                     // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5); // RS1
        copy_string(convert_to_binary(rs2, 5), instruction_32_bit, 24, 5); // RS2
        copy_string(imm6, instruction_32_bit, 30, 6);                      // IMM[10:5]
        copy_string(imm12, instruction_32_bit, 31, 1);                     // IMM[12]
    }

    else if (strcmp(instr, "bge") == 0)
    {
        int rs1 = atoi(chunks[0]);
        int rs2 = atoi(chunks[1]);
        int imm_b = atoi(chunks[2]);

        char *imm12 = convert_to_binary(imm_b, 12);
        char imm4[5], imm6[7];

        strncpy(imm4, imm12 + 8, 4);
        strncpy(imm6, imm12 + 2, 6);
        imm4[4] = '\0';
        imm6[6] = '\0';

        copy_string(OPCODE_B, instruction_32_bit, 6, 7);                   // OPCODE
        copy_string(imm12 + 1, instruction_32_bit, 7, 1);                  // IMM[11]
        copy_string(imm4, instruction_32_bit, 11, 4);                      // IMM[4:1]
        copy_string("101", instruction_32_bit, 14, 3);                     // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5); // RS1
        copy_string(convert_to_binary(rs2, 5), instruction_32_bit, 24, 5); // RS2
        copy_string(imm6, instruction_32_bit, 30, 6);                      // IMM[10:5]
        copy_string(imm12, instruction_32_bit, 31, 1);                     // IMM[12]
    }

    else if (strcmp(instr, "bltu") == 0)
    {
        int rs1 = atoi(chunks[0]);
        int rs2 = atoi(chunks[1]);
        int imm_b = atoi(chunks[2]);

        char *imm12 = convert_to_binary(imm_b, 12);
        char imm4[5], imm6[7];

        strncpy(imm4, imm12 + 8, 4);
        strncpy(imm6, imm12 + 2, 6);
        imm4[4] = '\0';
        imm6[6] = '\0';

        copy_string(OPCODE_B, instruction_32_bit, 6, 7);                   // OPCODE
        copy_string(imm12 + 1, instruction_32_bit, 7, 1);                  // IMM[11]
        copy_string(imm4, instruction_32_bit, 11, 4);                      // IMM[4:1]
        copy_string("110", instruction_32_bit, 14, 3);                     // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5); // RS1
        copy_string(convert_to_binary(rs2, 5), instruction_32_bit, 24, 5); // RS2
        copy_string(imm6, instruction_32_bit, 30, 6);                      // IMM[10:5]
        copy_string(imm12, instruction_32_bit, 31, 1);                     // IMM[12]
    }

    else if (strcmp(instr, "bequ") == 0)
    {
        int rs1 = atoi(chunks[0]);
        int rs2 = atoi(chunks[1]);
        int imm_b = atoi(chunks[2]);

        char *imm12 = convert_to_binary(imm_b, 12);
        char imm4[5], imm6[7];

        strncpy(imm4, imm12 + 8, 4);
        strncpy(imm6, imm12 + 2, 6);
        imm4[4] = '\0';
        imm6[6] = '\0';

        copy_string(OPCODE_B, instruction_32_bit, 6, 7);                   // OPCODE
        copy_string(imm12 + 1, instruction_32_bit, 7, 1);                  // IMM[11]
        copy_string(imm4, instruction_32_bit, 11, 4);                      // IMM[4:1]
        copy_string("111", instruction_32_bit, 14, 3);                     // FUNC3
        copy_string(convert_to_binary(rs1, 5), instruction_32_bit, 19, 5); // RS1
        copy_string(convert_to_binary(rs2, 5), instruction_32_bit, 24, 5); // RS2
        copy_string(imm6, instruction_32_bit, 30, 6);                      // IMM[10:5]
        copy_string(imm12, instruction_32_bit, 31, 1);                     // IMM[12]
    }

    /* ---------------------------------- U - Type ---------------------------------- */
    else if (strcmp(instr, "auipc") == 0)
    {
        int rd = atoi(chunks[0]);
        int imm_u = atoi(chunks[1]);

        copy_string(OPCODE_U1, instruction_32_bit, 6, 7);                      // OPCODE
        copy_string(convert_to_binary(rd, 5), instruction_32_bit, 11, 5);      // RD
        copy_string(convert_to_binary(imm_u, 20), instruction_32_bit, 31, 20); // IMM_U
    }

    else if (strcmp(instr, "lui") == 0)
    {
        int rd = atoi(chunks[0]);
        int imm_u = atoi(chunks[1]);

        copy_string(OPCODE_U2, instruction_32_bit, 6, 7);                      // OPCODE
        copy_string(convert_to_binary(rd, 5), instruction_32_bit, 11, 5);      // RD
        copy_string(convert_to_binary(imm_u, 20), instruction_32_bit, 31, 20); // IMM_U
    }

    /* ---------------------------------- J - Type ---------------------------------- */
    else if (strcmp(instr, "jal") == 0)
    {
        int rd = atoi(chunks[0]);
        int imm_j = atoi(chunks[1]);

        copy_string(OPCODE_J, instruction_32_bit, 6, 7);                       // OPCODE
        copy_string(convert_to_binary(rd, 5), instruction_32_bit, 11, 5);      // RD
        copy_string(convert_to_binary(imm_j, 20), instruction_32_bit, 31, 20); // IMM_J
    }

    /* -------------------------------- Invalid Types -------------------------------- */
    else
        copy_string("0000000", instruction_32_bit, 6, 7);

    instruction_32_bit[32] = '\n';
}

// This function is use to generate the instruction
char *generate_instruction(char *line)
{
    // printf("\n%s\n", line);

    // Find the length
    int length = strlen(line);
    // printf("Length: %d\n", length);

    // Remove leading spaces
    char *cleaned_line = clean_line(line, length);
    // printf("'%s'\n", cleaned_line);

    // If null line drop it
    if (cleaned_line == NULL)
        return "\0";

    // Allocate memory to store the instruction
    char *instruction_32_bit = (char *)malloc(sizeof(char) * 33);

    // Initialize all bytes with '0' (character zero)
    memset(instruction_32_bit, '0', 33);

    // Get the instruction
    char *inst = (char *)malloc(sizeof(char) * 7);

    int idx = 0;
    while (idx < 6 && !isspace((unsigned char)cleaned_line[idx]) && cleaned_line[idx] != '\0')
    {
        inst[idx] = tolower((unsigned char)cleaned_line[idx]);
        idx++;
    }
    inst[idx++] = '\0'; // Null-terminate the extracted opcode
    // printf("Instruction: '%s'\n", inst);

    // Chunking
    char **chunks = generate_chunks(cleaned_line + idx);
    /* for (int i = 0; i < 3; i++)
    {
        printf("Chunk %d: '%d'\n", i, atoi(chunks[i]));
    } */

    // Update the opcode in the instruction set
    complete_instruction(inst, chunks, instruction_32_bit);

    return instruction_32_bit;
}

int main()
{
    FILE *input_file, *output_file;
    char line[MAX_LINE_LENGTH];

    // Open the input file
    input_file = fopen("program.s", "r");
    if (input_file == NULL)
    {
        printf("Error opening input file\n");
        return 1;
    }

    // Open the output file
    output_file = fopen("instr_mem.mem", "w");
    if (output_file == NULL)
    {
        printf("Error opening output file");
        fclose(input_file);
        return 1;
    }

    // Read the input file line by line
    while (fgets(line, sizeof(line), input_file))
    {
        // Processing line
        char *inst = generate_instruction(line);
        // printf("32 Ins: %s\n", inst);

        // Write the modified line to the output file
        fputs(inst, output_file);
    }

    // Close the files
    fclose(input_file);
    fclose(output_file);

    printf("\nCompilation is successfull.\n\n");
    return 0;
}
