module file_location;

/// A structure that represents a location in a file.
struct FileLocation
{
    /// Points to the start of the line's content.
    const(char) *line_start;

    /// The line of where the content is.
    uint line;

    /// The column of where the content starts.
    uint column;

    /// The length of the content it is pointing to.
    uint length;
}