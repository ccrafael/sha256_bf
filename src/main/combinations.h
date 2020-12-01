#ifndef COMBINATIONS_H
#define COMBINATIONS_H

#include <string>

using namespace std;

class Combinations {
    private:
        string charset;
        int num_chars;
        int len;
        int char_limit;
        int * actual_char_count;
        int * current_combination;
        
        unsigned long iter;

        void init();
        bool inc(int pos);
        bool valid_combination();
        string current_to_string();

    public:
        Combinations(int len, string charset, int char_limit);
        ~Combinations();

        string next();
        bool hasNext();
};
#endif
