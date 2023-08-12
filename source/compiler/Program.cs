Globals.Modules.Add("global", new("global"));
Globals.SourceFiles.Add(new("tests/main.ox"));
Globals.SourceFiles.Add(new("tests/other.ox"));

Pass parser = new Parser();
parser.Start();

Pass emitter = new CEmitter();
emitter.Start();

Pass linker = new CLinker();
linker.Start();