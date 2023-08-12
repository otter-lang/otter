Globals.Modules.Add("global", new("global"));
Globals.SourceFiles.Add(new("tests/main.ox"));
Globals.SourceFiles.Add(new("tests/other.ox"));

Parser parser = new Parser();
parser.Start();

Emitter emitter = new Emitter();
emitter.Start();

Linker linker = new Linker();
linker.Start();