#!/usr/bin/perl -w


use strict;
use warnings;

use XML::LibXML;

use XMLlists;

my $FILE = getAutoDir() . "/AutoXmlEnum.h.tmp";
my $FILE_TEST = getAutoDir() . "/AutoXmlTest.h.tmp";
my $FILE_DECLARE = getAutoDir() . "/AutoXmlDeclare.h.tmp";
my $FILE_INIT = getAutoDir() . "/AutoXmlInit.h.tmp";

my $files = [];

open (my $output, "> " . $FILE) or die "Can't open file " . $FILE . "\n" . $!;
open (my $output_test, "> " . $FILE_TEST) or die "Can't open file " . $FILE_TEST . "\n" . $!;
open (my $output_declare, "> " . $FILE_DECLARE) or die "Can't open file " . $FILE_DECLARE . "\n" . $!;
open (my $output_init, "> " . $FILE_INIT) or die "Can't open file " . $FILE_INIT . "\n" . $!;

print $output "#ifndef AUTO_XML_ENUM\n";
print $output "#define AUTO_XML_ENUM\n";
print $output "\n";
print $output "// Autogenerated file. Do not edit!!!\n";
print $output "\n";
print $output "// Each of the enums in this file represent an xml file.\n";
print $output "// Civ4 has always hardcoded some xml data this way and modders have always had issues with dll and xml going out of sync.\n";
print $output "// \n";
print $output "// This file will hopefully solve the out of sync problem for good.\n";
print $output "// The makefile will update this file if needed each time the compiler is used.\n";
print $output "// As a result, a compiled DLL will always match the xml files at the time of compilation.\n";
print $output "// \n";
print $output "// The debugger is aided by this file. Even if the compiler in the makefile doesn't hardcode, data, the debugger will.\n";
print $output "// This means the debugger will use the names given in this file, like UNIT_WAGON_TRAIN(81) instead of just 81.\n";
print $output "// Since it's debugger only, this won't have any effect on how the game is running.\n";
print $output "// \n";
print $output "// The file can optionally hardcode everything (it doesn't by default. It has to be enabled)\n";
print $output "// Hardcoding can help the compiler optimization, but it shouldn't be used if somebody wants to edit xml files.\n";
print $output "// \n";
print $output "// All hardcoded data will be assert checked at startup.\n";
print $output "\n";

print $output_test "\n";
print $output_test "// Autogenerated file. Do not edit!!!\n";
print $output_test "\n";

print $output_declare "\n";
print $output_declare "// Autogenerated file. Do not edit!!!\n";
print $output_declare "\n";
print $output_declare "#ifndef HARDCODE_XML_VALUES\n";

print $output_init "\n";
print $output_init "// Autogenerated file. Do not edit!!!\n";
print $output_init "\n";
print $output_init "#ifndef HARDCODE_XML_VALUES\n";

foreach my $file (getEnumFiles())
{
	processFile($output, $output_test, $file);
}

print $output "\n#endif // AUTO_XML_ENUM\n";
print $output_declare "#endif\n";
print $output_init "#endif\n";

close $output;
close $output_test;
close $output_declare;
close $output_init;

updateAutoFile($FILE);
updateAutoFile($FILE_TEST);
updateAutoFile($FILE_DECLARE);
updateAutoFile($FILE_INIT);

sub getChild
{
	my $parent = shift;
	my $name = shift;
	
	my $element = $parent->firstChild;
	
	while (1)
	{
		return if (ref($element) eq "");
		if (ref($element) eq "XML::LibXML::Element")
		{
			return $element if $name eq "" or $element->nodeName eq $name;
		}
		$element = $element->nextSibling;
	}
}

sub nextSibling
{
	my $element = shift;
	
	$element = $element->nextSibling;
	while (ref($element) ne "XML::LibXML::Element" and ref($element) ne "")
	{
		$element = $element->nextSibling;
	}
	return $element;
}

sub processFile
{
	my $output = shift;
	my $output_test = shift;
	my $filename = shift;

	my ($basename, $enum, $TYPE) = getXMLKeywords($filename);
	
	my $isHardcoded = isAlwaysHardcodedEnum($filename);
	
	my $isYield = $enum eq "YieldTypes";

	print $output "enum ";
	print $output "DllExport " if isDllExport($enum);
	print $output $enum . "\n{\n";
	print $output "\tINVALID_PROFESSION = -2,\n" if $basename eq "Profession";
	print $output "\t" . getNoType($TYPE) . " = -1,\n\n";
	print $output "#if defined(HARDCODE_XML_VALUES) || !defined(MakefileCompilation)\n\n" unless $isHardcoded;
	
	# first make the test file conditional if needed.
	print $output_test "#ifdef HARDCODE_XML_VALUES\n" unless $isHardcoded;
	
	my $dom = XML::LibXML->load_xml(location => getFileWithPath($filename));
	
	my $loopElement = getChild($dom, "");
	$loopElement = getChild($loopElement, "");
	$loopElement = getChild($loopElement, "") unless isTwoLevelFile($filename);

	while (ref ($loopElement) ne "")
	{
		my $child = getChild($loopElement, "Type");
		#$child = getChild($loopElement, "Description") unless $child; # fallback in case of no type
		die $filename . " failed to read elements" unless $child;
		my $type = $child->textContent;
		print $output "\t" . $type . ",\n";
		print $output_test "FAssertMsg(strcmp(\"". $type . "\", GC." . getInfo($basename) . "($type).getType()) == 0, \"File $filename has mismatch between xml and DLL enum\");\n";
		
		$loopElement = nextSibling($loopElement);
	}

	print $output_test "#endif\n" unless $isHardcoded;
	print $output_test "FAssertMsg(NUM_" . $TYPE . "_TYPES == " . getNumFunction($basename) . ", \"File $filename has mismatched length between xml and DLL enum\");\n";

	print $output "\n#ifdef HARDCODE_XML_VALUES\n" unless $isHardcoded;
	print $output "\n\tNUM_" . $TYPE . "_TYPES,\n";
	print $output "\n#endif // HARDCODE_XML_VALUES\n" unless $isHardcoded;
	print $output "#endif // MakefileCompilation\n" unless $isHardcoded;
	print $output "\n\tFIRST_" . $TYPE . " = 0,\n";
	print $output "\tNUM_CARGO_YIELD_TYPES = YIELD_HAMMERS,\n" if $isYield;
	print $output "};\n\n";
	
	unless ($isHardcoded)
	{
		print $output "#ifndef HARDCODE_XML_VALUES\n";
		print $output "extern int NUM_" . $TYPE . "_TYPES;\n";
		print $output "#endif\n\n";
		print $output_declare "int NUM_" . $TYPE . "_TYPES;\n";
		print $output_init "NUM_" . $TYPE . "_TYPES = (" . $enum . ")" . getNumFunction($basename) . ";\n";
	}
}
