#include <modules/main.hpp>
#include <modules/std.c.hpp>
#include <modules/std.c.hpp>
#include <modules/std.console.hpp>

void_t std_console_writeln(string_t std_console_writeln_content)
{
	puts(std_console_writeln_content);
}

void_t std_file_file_write(string_t std_file_file_write_path, const char_t *std_file_file_write_content)
{
	void_t *std_file_file_write_file = fopen(std_file_file_write_path, "wb");
	fwrite(std_file_file_write_content, 1, 3, std_file_file_write_file);
	fclose(std_file_file_write_file);
}

int main(void)
{
	std_console_writeln("Hello, World!");
}