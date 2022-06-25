module io;

// standard
import std.stdio;

// /
import diagnostic;

/** 
    Write colored content to console.

    Params:
        color = The content color to set in console.
        content = The content to write to console.
*/
void writec(string color, string content)
{
    write(cast(string)color);
    write(content);
    write(cast(string)DiagnosticColor.None);
}

/** 
    Write colored content with line to console.

    Params:
        color = The content color to set in console.
        content = The content to write to console.
*/
void writecln(string color, string content)
{
    writec(color, content);
    writeln();
}