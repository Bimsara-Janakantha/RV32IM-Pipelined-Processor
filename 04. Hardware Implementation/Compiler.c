/*
Create by BG
Created on Sun, 26 Jan 2025 at 11:37 AM
Last modified on Sun, 26 Jan 2025 at 11:37 AM
This is the compiler for RMV-32IM Pipelined processor

Description:

This program can be used to convert manually-written textual assembly programs into machine code for CO502 laboratory experiment (RV32IM Piplined processor).

This simple assembler assumes an ISA containing the RV32IM instruction set. All instructions are encoded into 32-bit words based on the RV32IM format.
(See the documentation for more information)

This assembler will perform some basic error checks on your program. A valid instruction should contain two to four tokens separated by space character (e.g. "add x3 x2 x1", "lw x5 1(x2)"), corresponding to the details given above. In addition, empty lines and comments are permitted. A valid comment should start with "//".
DO NOT depend on this assembler to check errors in your assembly programs. You must make sure that your code is correct.

Compiling the program	: gcc Compiler.c -o Compiler
Use the assembler		: ./Compiler
Generated output file	: instr_mem.mem
*/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <ctype.h>

#define MAX_LINE_LENGTH 256

// Instruction catagories
char *R_TYPE[] = {"add", "sub", "sll", "slt", "sltu", "xor", "srl", "sra", "or", "and", "mul", "mulh", "mulhsu", "mulhu", "div", "divu", "rem", "remu"};
char *S_TYPE[] = {"sb", "sh", "sw"};
char *B_TYPE[] = {"beq", "bne", "blt", "bge", "bltu", "bequ"};
char *J_TYPE[] = {"jal"};
char *U_TYPE1[] = {"auipc"};
char *U_TYPE2[] = {"lui"};
char *I_TYPE1[] = {"lb", "lh", "lw", "lbu", "lhu"};
char *I_TYPE2[] = {"addi", "slli", "slti", "sltiu", "xori", "srli", "srai", "ori", "andi"};
char *I_TYPE3[] = {"jalr"};

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

    /// Allocate memory for chunks
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
        }

        // Handling the edge case;
        if (i + 1 == len)
            chunks[current_chunk++][current_position] = '\0';
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

    printf("Decimal: %d", number);

    // Fill the binary string with 0's
    memset(binary, '0', padding);

    // Convert the number to binary from the least significant bit
    for (int i = padding - 1; i >= 0 && number > 0; i--)
    {
        binary[i] = (number & 1) ? '1' : '0';
        number = number >> 1;
    }

    printf(" \t\t Binary: %s\n", binary);

    return binary;
}

// This function is to use check a given instruction is available in a instruction set
bool is_in_list(char *instr, char *list[], int list_size)
{
    // Check if the given instruction is available in the given list
    for (int i = 0; i < list_size; i++)
    {
        if (strcmp(instr, list[i]) == 0)
        {
            return true; // Found the instruction
        }
    }
    return false; // Instruction not found
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
    if (strcmp(instr, "add") == 0)
    {
        copy_string("0110011", instruction_32_bit, 6, 7);  // OPCODE
        copy_string("111", instruction_32_bit, 14, 3);     // FUNC3
        copy_string("0000000", instruction_32_bit, 31, 7); // FUNC7
    }

    else
    {
        copy_string("0000000", instruction_32_bit, 6, 7);
    }

    // printf("Instruction: %s \t OPCODE: %s\n", instr, opcode);

    // copy_string(opcode, instruction_32_bit, 25);

    instruction_32_bit[32] = '\n';
}

// This function use to get the opcode for the given instruction
/* char complete_instruction(char *instr, char *instruction_32_bit)
{
    // Define the size of the opcode (7 characters)
    char *opcode = malloc(sizeof(char) * 7);

    if (is_in_list(instr, R_TYPE, sizeof(R_TYPE) / sizeof(R_TYPE[0])))
        opcode = "0110011";

    else if (is_in_list(instr, I_TYPE1, sizeof(I_TYPE1) / sizeof(I_TYPE1[0])))
        opcode = "0000011";

    else if (is_in_list(instr, I_TYPE2, sizeof(I_TYPE2) / sizeof(I_TYPE2[0])))
        opcode = "0010011";

    else if (is_in_list(instr, I_TYPE3, sizeof(I_TYPE3) / sizeof(I_TYPE3[0])))
        opcode = "1100111";

    else if (is_in_list(instr, S_TYPE, sizeof(S_TYPE) / sizeof(S_TYPE[0])))
        opcode = "0100011";

    else if (is_in_list(instr, B_TYPE, sizeof(B_TYPE) / sizeof(B_TYPE[0])))
        opcode = "1100011";

    else if (is_in_list(instr, U_TYPE1, sizeof(U_TYPE1) / sizeof(U_TYPE1[0])))
        opcode = "0010111";

    else if (is_in_list(instr, U_TYPE2, sizeof(U_TYPE2) / sizeof(U_TYPE2[0])))
        opcode = "0110111";

    else if (is_in_list(instr, J_TYPE, sizeof(J_TYPE) / sizeof(J_TYPE[0])))
        opcode = "1110111";

    else
        opcode = "0000000";

    printf("Instruction: %s \t OPCODE: %s\n", instr, opcode);

    for (int i = 0; i < 7; i++)
    {
        instruction_32_bit[25 + i] = opcode[i];
    }
    instruction_32_bit[32] = '\n';
} */

// This function is use to generate the instruction
char *generate_instruction(char *line)
{
    printf("%s", line);

    // Find the length
    int length = strlen(line);
    // printf("Length: %d\n", length);

    // Remove leading spaces
    char *cleaned_line = clean_line(line, length);
    // printf("%s", cleaned_line);

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
    printf("Instruction: '%s'\n", inst);

    // Chunking
    char **chunks = generate_chunks(cleaned_line + idx);
    for (int i = 0; i < 3; i++)
    {
        printf("Chunk %d: '%s'\n", i, chunks[i]);
    }

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
        printf("32 Ins: %s\n", inst);

        // Write the modified line to the output file
        fputs(inst, output_file);
    }

    // Close the files
    fclose(input_file);
    fclose(output_file);

    printf("Compilation is successfull.\n");
    return 0;
}
