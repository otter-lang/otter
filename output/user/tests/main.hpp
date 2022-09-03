#ifndef USER_TESTS_MAIN_HPP
#define USER_TESTS_MAIN_HPP

#include <otter/runtime/include.hpp>

extern "C" int_t puts(const char_t *std_c_puts_message);
extern "C" void_t *fopen(const char_t *std_c_fopen_path, const char_t *std_c_fopen_flags);
extern "C" int_t fclose(void_t *std_c_fclose_file);
extern "C" int_t fwrite(const void_t *std_c_fwrite_content, uword_t std_c_fwrite_count, uword_t std_c_fwrite_length, void_t *std_c_fwrite_file);
extern void_t std_console_writeln(string_t std_console_writeln_content);
extern void_t std_file_file_write(string_t std_file_file_write_path, const char_t *std_file_file_write_content);
extern int main(void);

#endif