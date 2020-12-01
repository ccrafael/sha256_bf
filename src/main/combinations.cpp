#include "combinations.h"
#include <stdio.h>
#include <string.h>
#include <sstream> 
#include <iostream>
#include <math.h>

using namespace std;

Combinations::Combinations(int len, string charset, int char_limit) {
    this->char_limit = char_limit;
    this->charset = charset;
    this->len = len;

    num_chars = charset.size();
    actual_char_count = new int[num_chars];
    current_combination = new int[len];
    iter = -1;
}

Combinations::~Combinations() {
    delete this->actual_char_count;
    delete this->current_combination;
}

void Combinations::init() {
    int initial_val  = 0;

    for (int i = 0; i < len; i++) {
        if (actual_char_count[initial_val] == char_limit) {
            initial_val ++;
        }
        current_combination[i] = initial_val;
        actual_char_count[initial_val]++;
    }
}

bool Combinations::valid_combination() {
    memset(actual_char_count, 0, sizeof(int) * num_chars);

    for (int i = 0; i < len; i++) {
        if (actual_char_count[current_combination[i]] == char_limit) {
            return false;
        } else {
            actual_char_count[current_combination[i]]++;
        }
    }
    return true;
}

string Combinations::current_to_string() {
    stringstream ss;
    for (int i = 0; i < len; i++) {
        ss << charset[current_combination[i]];
    }

    return ss.str();
}

string Combinations::next() {
    iter ++;

    if (iter == 0) {
        init();
        return current_to_string();
    }

    do {
        
        bool there_is_carriage = false;
        int current_pos = 0;
        do {
            if (current_combination[current_pos] == num_chars - 1) {
                current_combination[current_pos] = 0;
                current_pos++;
                there_is_carriage = true;
            } else {
                current_combination[current_pos]++;
                there_is_carriage = false;
            }
        } while (there_is_carriage && current_pos < len);

    } while (!valid_combination());

    return current_to_string();
}

// TODO
bool Combinations::hasNext() {
    return true;
}

