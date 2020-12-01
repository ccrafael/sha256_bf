# Sha256
This is a Cuda program to crack Java Spring Security passwords created by the deprecated StandardPasswordEncoder class.

The digest made by that class generates a password with the following format:
```
salt + sha256_1024_iters(salt + clear_password)
```
The salt has a 8 bytes length.

The program uses bruteforce. It has an optimization when generating passwords that generate the passwords with a character repetition limit.

Java example of an encoded password using the above class:
```
import org.springframework.security.crypto.password.StandardPasswordEncoder;

public class Main {

    public static void main(String[] args) {
        StandardPasswordEncoder encoder = new StandardPasswordEncoder();
        System.out.println(encoder.encode("hellowor"));
    }
}
```

In the very first version it is able to check 1.9M Hk/s using a 1080 ti GPU. Note that the digest made by StandardPasswordEncoder it is not a simple sha256 digest but it does 1024 digest iterations.

# Usage

```
sha256_bf blocks threads charset passlen char_limit target
```

Where:
* blocks: number of cuda blocks.
* threads: number of cuda threads.
* charset: the set of chars to use.
* passlen: the len of passwords to generate.
* char_limit: maximum number of repetitons of the chars allowed in a passwords.
* target: the hex encoded string.

Example:
```
./bin/sha256_bf 1024 64 abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 8 2 e0df6922273d08b24ba4fa4ec2978bca41c937b133e77ec604b1c5c686554b3b824cb7196fbcd0d7
```

# Build
make

# Run tests
make run_tests


