/*
 * Copyright (c) 2014 Alec Moskvin
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#include <err.h>
#include <fcntl.h>
#include <stdio.h>
#include <getopt.h>
#include <string.h>
#include <unistd.h>
#include <stdbool.h>

#ifndef VERSION
# define VERSION "(git)"
#endif

#define STATE_FILE "/etc/pandora/conf/nubs.state"

const char* KNOBS[] = {
    "/proc/pandora/nub0/mode",
    "/proc/pandora/nub0/mouse_sensitivity",
    "/proc/pandora/nub0/scrollx_sensitivity",
    "/proc/pandora/nub0/scrolly_sensitivity",
    "/proc/pandora/nub0/scroll_rate",
    "/proc/pandora/nub0/mbutton_threshold",

    "/proc/pandora/nub1/mode",
    "/proc/pandora/nub1/mouse_sensitivity",
    "/proc/pandora/nub1/scrollx_sensitivity",
    "/proc/pandora/nub1/scrolly_sensitivity",
    "/proc/pandora/nub1/scroll_rate",
    "/proc/pandora/nub1/mbutton_threshold",

    "/proc/pandora/nub0/mbutton_delay",
    "/proc/pandora/nub1/mbutton_delay",
};

const int KNOB_COUNT = sizeof(KNOBS) / sizeof(char*);
const int MAX_LEN = 16;

void help(void)
{
    puts("nub-state " VERSION "\n"
         "Usage: nub-state [-s|-r]\n"
         "  -s   Save nub state to " STATE_FILE "\n"
         "  -r   Restore nub state from file"
        );
}

void read_knobs(char** values)
{
    int fd;
    int len;
    char buf[MAX_LEN];
    for (int ix = 0; ix < KNOB_COUNT; ix++)
    {
        if ((fd = open(KNOBS[ix], O_RDONLY)) == -1
            || (len = read(fd, buf, MAX_LEN)) == -1)
        {
            err(1, "Error: %s", KNOBS[ix]);
        }
        close(fd);
        values[ix] = strndup(buf, len - 1);
    }
}

void write_knobs(char** values)
{
    int fd;
    char* val;
    for (int ix = 0; ix < KNOB_COUNT; ix++)
    {
        if ((val = values[ix]) == NULL)
                break;

        if ((fd = open(KNOBS[ix], O_WRONLY)) == -1 
            || write(fd, val, strlen(val)) == -1)
        {
            err(1, "Error: Failed to write '%s' to %s", values[ix], KNOBS[ix]);
        }
        close(fd);
    }
}

bool read_file(const char* file, char** values)
{
    FILE* fp;
    char buf[MAX_LEN];
    bool ret = true;
    if ((fp = fopen(file, "r")) == NULL)
    {
        warn("Warning: %s", file);
        return false;
    }
    
    for (int ix = 0; ret && ix < KNOB_COUNT; ix++)
    {
        if (!fgets(buf, MAX_LEN, fp))
        {
            if (!feof(fp))
            {
                warn("Warning: %s", file);
                ret = false;
            }
            values[ix] = NULL;
            break;
        }
        values[ix] = strndup(buf, strlen(buf) - 1);
    }

    fclose(fp);
    return ret;
}

void write_file(const char* file, char** values)
{ 
    FILE* fp;
    if ((fp = fopen(file, "w")) == NULL)
        err(1, "Error: %s", file);
    for (int ix = 0; ix < KNOB_COUNT; ix++)
        fprintf(fp, "%s\n", values[ix]);
    fclose(fp);
}

bool values_equal(char** val1, char** val2)
{
    for (int ix = 0; ix < KNOB_COUNT; ix++)
        if (!val1[ix] || !val2[ix] || strncmp(val1[ix], val2[ix], MAX_LEN))
            return false;
    return true;
}

int main(int argc, char** argv)
{
    bool restore;
    switch (getopt(argc, argv, "rs"))
    {
        case 'r':
            restore = true;
            break;
        case 's':
            restore = false;
            break;
        default:
            help();
            return 2;
    }

    char* file_values[KNOB_COUNT];
    bool valid_file = read_file(STATE_FILE, file_values);
    
    if (restore)
    {
        if (!valid_file)
            errx(1, "Error: Failed to load state file");
        write_knobs(file_values);
    }
    else
    {
        char* knob_values[KNOB_COUNT];
        read_knobs(knob_values);
        if (!valid_file || !values_equal(file_values, knob_values))
            write_file(STATE_FILE, knob_values);

#if DEBUG
        for (int ix = 0; ix < KNOB_COUNT; ix++)
            free(knob_values[ix]);
#endif
    }

#if DEBUG
    for (int ix = 0; ix < KNOB_COUNT && file_values[ix]; ix++)
        free(file_values[ix]);
#endif

    return 0;
}
