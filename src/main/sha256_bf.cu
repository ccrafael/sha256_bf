#include <stdio.h>
#include "sha256.h"
#include "utils.h"
#include "combinations.h"
#include <chrono>
#include <string>
#include <stdlib.h> 

using namespace std;

__global__  
void sha256(BYTE * data, BYTE * hash, int len) {
	int j = (blockIdx.x * blockDim.x + threadIdx.x) * 32;
	SHA256_CTX ctx;
	sha256_init(&ctx);
	sha256_update(&ctx, data + j, len);
	sha256_final(&ctx, hash + j);
}

void usage(char * exe) {
	printf("%s blocks threads charset passlen char_limit target \n", exe);
}

int main(int argc, char ** argv) {	
	if (argc != 7) {
		usage(argv[0]);
		return 1;
	}

	int blocks =  atoi(argv[1]);
	int threads_per_block = atoi(argv[2]);
	string charset = argv[3];

	int pass_len = atoi(argv[4]);
	int char_limit = atoi(argv[5]);
	string target_pass = argv[6];

	int salt_len = 8;
	
	int N = blocks * threads_per_block;

	BYTE * hash;
	size_t hash_size = N * 32 * sizeof(BYTE);
	
	Combinations combinations(pass_len, charset , char_limit);
	
	BYTE encoded_pass_with_salt[40];
	BYTE salt[8];
	BYTE encoded_pass[32];

	string * clear_pass = new string[N];

	hexstr2byte(target_pass, encoded_pass_with_salt);
	memcpy(salt, encoded_pass_with_salt, salt_len);
	memcpy(encoded_pass, encoded_pass_with_salt + salt_len, 32);

	cudaMallocManaged(&hash,  hash_size);
	
	printf("Start \n");
	for (unsigned long j = 0; j < 20000000000; j++) {

		chrono::steady_clock::time_point begin = chrono::steady_clock::now();
		for (int i = 0; i < N; i ++) {
			clear_pass[i] = combinations.next();
			memcpy(hash + (i * 32), salt, salt_len);
			memcpy(hash + salt_len + (i * 32), clear_pass[i].c_str(), pass_len);
		}


		sha256<<<blocks,threads_per_block>>>(hash, hash, salt_len + pass_len); 
		for (int i = 0; i < 1023; i ++) {
			sha256<<<blocks,threads_per_block>>>(hash, hash, 32); 
		}

		cudaDeviceSynchronize();
		
		begin = chrono::steady_clock::now();
	
		for (int i = 0; i < N; i++) {
			if (memcmp(hash + (i * 32), encoded_pass, 32 * sizeof(BYTE)) == 0) {
				printf("password found: {%s} \n", clear_pass[i].c_str());

				cudaFree(hash);
				return 0;
			}
		}

		
		chrono::steady_clock::time_point end = chrono::steady_clock::now();
		double duration = (chrono::duration_cast<chrono::microseconds>(end - begin).count());
		double pass_per_second = ((N * 100 / duration) * 1000000.0) / 1024;
		printf("current(%d): duration: %f microseconds - %f pass/sec \n", j, duration, pass_per_second);
		
	}

	cudaFree(hash);
    
    return 0;
}
