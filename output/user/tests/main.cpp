#include <modules/global.hpp>

void_t global_writeln(string_t global_writeln_content)
{
	puts(global_writeln_content);
}

void_t global_file_write(string_t global_file_write_path, const char_t *global_file_write_content)
{
	void_t *global_file_write_file = fopen(global_file_write_path, "wb");
	fwrite(global_file_write_content, 1, 3, global_file_write_file);
	fclose(global_file_write_file);
}

int main(void)
{
	global_file_write("A.md", "lol");
	global_writeln("Hello, World!");
}