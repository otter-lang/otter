#ifndef USER_TESTS_MAIN_HPP
#define USER_TESTS_MAIN_HPP

#include <otter/runtime/include.hpp>

extern "C" int_t puts(const char_t *global_puts_message);
extern "C" void_t *fopen(const char_t *global_fopen_path, const char_t *global_fopen_flags);
extern "C" int_t fclose(void_t *global_fclose_file);
extern "C" int_t fwrite(const void_t *global_fwrite_content, uword_t global_fwrite_count, uword_t global_fwrite_length, void_t *global_fwrite_file);
extern void_t global_writeln(string_t global_writeln_content);
extern void_t global_file_write(string_t global_file_write_path, const char_t *global_file_write_content);
extern int main(void);

#endif