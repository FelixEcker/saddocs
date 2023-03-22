{$mode objfpc}
program saddocs;

{$H+}

uses Dos, SysUtils, uSADParser, uSADHTMLParser;

const
  VERSION = '1.0.0';
  AUTHOR = 'Marie Eckert';

var
  binhome: String;
  sad_parser: TSADHTMLParser;

procedure Help;
begin
  writeln('saddocs ', VERSION, ' by ', AUTHOR);
  writeln('A tool for converting a directory of .sad files to HTML');
  writeln;
  writeln('Options: ');
  writeln('--help     Display this Help text');
  writeln('-o         Specify the output directory (default ./html)');
  writeln('-i         Specify the input direcotry (default .)');
  writeln('-r         Convert in recursive mode. Converts all sad files in', sLineBreak,
          '           all subdirectories. The same directory structure will be', sLineBreak,
          '           carried over to the output directory');
end;
  
procedure Convert(const APath: String; const AOutdir: String);
begin
  try
    if not Assigned(sad_parser) then
      sad_parser := TSADHTMLParser.Create;

    if not DirectoryExists(AOutDir) then
      ForceDirectories(AOutDir);

    sad_parser.Path := APath;
    sad_parser.section := '.';
    sad_parser.Open;
    
    sad_parser.WriteHtml(AOutDir+
      PathDelim+ExtractFileName(APath)+'.html', 
      binhome+'style.css', false);
  except
    on e: EMalformedDocumentException do
    begin
      writeln('Couldn''t convert: Input File is Malformed: ', e.Message);
    end;
    on e: ENoSuchSectionException do
    begin
      writeln('Couldn''t convert: ', e.Message);
    end;
  end;
end;

procedure DoConversion(AInDir, AOutDir: String; const ARecurse: Boolean);
var
  search_attr: Word;
  search_rec: TRawbyteSearchRec;
begin
  search_attr := faAnyFile;
  
  FindFirst(AInDir+PathDelim+'*.sad', search_attr, search_rec);
  while search_rec.name <> '' do
  begin
    write('Converting ', AInDir+PathDelim+search_rec.name, '... ');
    Convert(AInDir+PathDelim+search_rec.name, AOutDir);
    writeln('DONE');
    if FindNext(search_rec) <> 0 then break;
  end;
  FindClose(search_rec);

  if not ARecurse then exit;

  search_attr := faDirectory;

  FindFirst(AInDir+PathDelim+'*', search_attr, search_rec);
  while search_rec.name <> '' do
  begin
    if not ((search_rec.name = '.') or (search_rec.name = '..')) and (search_rec.attr = search_attr) then 
      DoConversion(AInDir+PathDelim+search_rec.name, AOutDir+PathDelim+search_rec.name, ARecurse);
    if FindNext(search_rec) <> 0 then break;
  end;
  FindClose(search_rec);
end;

var
  in_dir: String;
  out_dir: String;
  modestr: String;

  i: Integer;
begin
  in_dir := '.';
  out_dir := 'html';
  modestr := 'Non-Recursive Mode';

  for i := 1 to ParamCount() do
    case ParamStr(i) of
    '--help': begin Help; exit; end;
    '-o': begin
      if ParamCount() < i+1 then
      begin
        writeln('error: -o flag requires 1 paramter: path');
        exit;
      end;
      out_dir := ParamStr(i+1);
    end;
    '-i': begin
      if ParamCount() < i+1 then
      begin
        writeln('error: -i flag requries 1 paramter: path');
        exit;
      end;
      in_dir := ParamStr(i+1);
    end;
    '-r': modestr := 'Recursive Mode';
  end;

  binhome := ExtractFilePath(ParamStr(0));
  out_dir := ExpandFileName(out_dir);
  in_dir := ExpandFileName(in_dir);
  writeln('Converting all .sad documents from ', in_dir, ' (', modestr, ')...');
  DoConversion(in_dir, out_dir, pos('Non', modestr) = 0);
  sad_parser.Free;
end.