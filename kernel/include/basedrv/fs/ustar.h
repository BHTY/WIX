#pragma once

typedef struct tar_header{
    char filename[100];
    char mode[8];
    char owner_user_id[8];
    char group_user_id[8];
    char file_size[12];
    char mod_time[12];
    char checksum[8];
    char type;
    char linked[100];
    char ustar[6];
    char zeroes[2];
    char owner_user_name[32];
    char owner_group_name[32];
    char major[8];
    char minor[8];
    char prefix[155];
} tar_header_t;
