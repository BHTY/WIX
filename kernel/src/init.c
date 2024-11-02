void _start(){
    *(unsigned char*)(0xB8000) = 'K';
    *(unsigned char*)(0xB8002) = 'R';
    *(unsigned char*)(0xB8004) = 'N';
    *(unsigned char*)(0xB8006) = 'L';
    while(1);
}