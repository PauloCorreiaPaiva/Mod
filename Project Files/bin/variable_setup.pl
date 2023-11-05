#!/usr/bin/perl -w


use strict;
use warnings;

#use lib './bin';
use File::Slurp;
use List::Util 1.33 'any';

use lib './bin';
use XMLlists;

my $GENERATE_INFOARRAY = 0;

my $file = "DLLSources/autogenerated/AutoVariableFunctions.h";
my $file_cpp = "DLLSources/autogenerated/AutoVariableFunctionsCPP.h";
my $file_case = "DLLSources/autogenerated/AutoVariableFunctionsCase.h";

my %var;
my $output = "";
my $output_cpp = "";
my $output_case = "";
my $output_cpp_init = "";
my $output_cpp_declare = "";
my @comparison_operators = ("==", "!=", "> ", "< ", ">=", "<=");

my @compatible_variables = (
	  ["int", "short", "char"] 
	, ["unsigned int", " unsigned short", "byte"]
);


$var{Achieve}          = {not_strict => 1, XML => 1};
$var{Alarm}            = {not_strict => 1, XML => 1, JIT => "NO_JIT_ARRAY_TYPE"};
$var{AreaAI}           = {not_strict => 1,           JIT => "NO_JIT_ARRAY_TYPE", getTypeStr => 0};
$var{ArtStyle}         = {not_strict => 1, XML => 1, getTypeStr => 0};
$var{Attitude}         = {not_strict => 1, XML => 1, JIT => "NO_JIT_ARRAY_TYPE"};
$var{Attachable}       = {                 XML => 1, JIT => "NO_JIT_ARRAY_TYPE"};
$var{Automate}         = {not_strict => 1, XML => 1, JIT => "NO_JIT_ARRAY_TYPE", getTypeStr => 0};
$var{Bonus}            = {not_strict => 1, XML => 1};
$var{Build}            = {not_strict => 1, XML => 1};
$var{Building}         = {not_strict => 1, XML => 1};
$var{BuildingClass}    = {not_strict => 1, XML => 1};
$var{SpecialBuilding}  = {not_strict => 1, XML => 1, JIT => "JIT_ARRAY_BUILDING_SPECIAL"};
$var{Calendar}         = {not_strict => 1, XML => 1, JIT => "NO_JIT_ARRAY_TYPE"};
$var{CivCategory}      = {not_strict => 1,           JIT => "JIT_ARRAY_CIV_CATEGORY", NUM => "NUM_CIV_CATEGORY_TYPES", COMPILE => "COMPILE_TIME_NUM_CIV_CATEGORY_TYPES", HARDCODED => 1};
$var{CivEffect}        = {not_strict => 1, XML => 1, JIT => "JIT_ARRAY_CIV_EFFECT", NUM => "NUM_CIV_EFFECT_TYPES", COMPILE => "COMPILE_TIME_NUM_CIV_EFFECT_TYPES"};
$var{Civic}            = {not_strict => 1, XML => 1};
$var{CivicOption}      = {not_strict => 1, XML => 1};
$var{Civilization}     = {not_strict => 1, XML => 1};
$var{CityPlot}         = {not_strict => 1,           JIT => "NO_JIT_ARRAY_TYPE", NUM => "NUM_CITY_PLOTS", COMPILE => "NUM_CITY_PLOTS_2_PLOTS", LENGTH_KNOWN_WHILE_COMPILING => "0"};
$var{Climate}          = {not_strict => 1, XML => 1};
$var{Color}            = {                 XML => 1, JIT => "NO_JIT_ARRAY_TYPE", INFO => "getColorInfo"};
$var{Command}          = {not_strict => 1, XML => 1, JIT => "NO_JIT_ARRAY_TYPE"};
$var{Concept}          = {                 XML => 1, JIT => "NO_JIT_ARRAY_TYPE", INFO => "getConceptInfo"};
$var{Contact}          = {not_strict => 1          , getTypeStr => 0};
$var{Control}          = {not_strict => 1, XML => 1, JIT => "NO_JIT_ARRAY_TYPE"};
$var{Culture}          = {not_strict => 1, XML => 1, type => "CultureLevelTypes", NUM => "NUM_CULTURELEVEL_TYPES", COMPILE => "COMPILE_TIME_NUM_CULTURELEVEL_TYPES"};
$var{Cursor}           = {not_strict => 1, XML => 1, JIT => "NO_JIT_ARRAY_TYPE"};
$var{Denial}           = {not_strict => 1, XML => 1, JIT => "NO_JIT_ARRAY_TYPE"};
$var{Diplomacy}        = {                 XML => 1};
$var{DetailManager}    = {                 XML => 1, JIT => "NO_JIT_ARRAY_TYPE", DYNAMIC => 1};
$var{Domain}           = {not_strict => 1, XML => 1};
$var{Emotion}          = {not_strict => 1};
$var{Effect}           = {not_strict => 1, XML => 1, JIT => "NO_JIT_ARRAY_TYPE", INFO => "getEffectInfo"};
$var{EntityEvent}      = {not_strict => 1, XML => 1, JIT => "NO_JIT_ARRAY_TYPE"};
$var{Era}              = {not_strict => 1, XML => 1};
$var{Emphasize}        = {not_strict => 1, XML => 1};
$var{Europe}           = {not_strict => 1};
$var{Event}            = {not_strict => 1, XML => 1};
$var{EventTrigger}     = {not_strict => 1, XML => 1, JIT => "JIT_ARRAY_EVENT_TRIGGER"};
$var{Father}           = {not_strict => 1, XML => 1};
$var{FatherCategory}   = {not_strict => 1, XML => 1, JIT => "NO_JIT_ARRAY_TYPE"};
$var{FatherPoint}      = {not_strict => 1, XML => 1, JIT => "JIT_ARRAY_FATHER_POINT", NUM => "NUM_FATHER_POINT_TYPES", COMPILE => "COMPILE_TIME_NUM_FATHER_POINT_TYPES"};
$var{Feat}             = {not_strict => 1};
$var{Feature}          = {not_strict => 1, XML => 1};
$var{ForceControl}     = {not_strict => 1, XML => 1, JIT => "NO_JIT_ARRAY_TYPE"};
$var{Formation}        = {                 XML => 1, JIT => "NO_JIT_ARRAY_TYPE", DYNAMIC => 1};
$var{GameOption}       = {not_strict => 1, XML => 1, JIT => "JIT_ARRAY_GAME_OPTION"};
$var{GameSpeed}        = {not_strict => 1, XML => 1, JIT => "JIT_ARRAY_GAME_SPEED"};
$var{Goody}            = {not_strict => 1, XML => 1};
$var{GraphicOption}    = {not_strict => 1, XML => 1, JIT => "NO_JIT_ARRAY_TYPE"};
$var{Handicap}         = {not_strict => 1, XML => 1};
$var{Hint}             = {                 XML => 1, JIT => "NO_JIT_ARRAY_TYPE", DYNAMIC => 1};
$var{Hurry}            = {not_strict => 1, XML => 1};
$var{Improvement}      = {not_strict => 1, XML => 1};
$var{InterfaceMode}    = {not_strict => 1, XML => 1, JIT => "NO_JIT_ARRAY_TYPE"};
$var{Invisible}        = {not_strict => 1, XML => 1};
$var{Landscape}        = {                 XML => 1, JIT => "NO_JIT_ARRAY_TYPE"};
$var{LeaderHead}       = {not_strict => 1, XML => 1, JIT => "JIT_ARRAY_LEADER", NUM => "NUM_LEADER_TYPES", COMPILE => "COMPILE_TIME_NUM_LEADER_TYPES"};
$var{MainMenu}         = {                 XML => 1, JIT => "NO_JIT_ARRAY_TYPE"};
$var{Memory}           = {not_strict => 1};
$var{Mission}          = {not_strict => 1, XML => 1, JIT => "NO_JIT_ARRAY_TYPE"};
$var{Month}            = {not_strict => 1, XML => 1, JIT => "NO_JIT_ARRAY_TYPE"};
$var{MultiplayerOption}= {not_strict => 1, XML => 1, JIT => "NO_JIT_ARRAY_TYPE", NUM => "NUM_MPOPTION_TYPES", COMPILE => "COMPILE_TIME_NUM_MPOPTION_TYPES"};
$var{Player}           = {not_strict => 1          , getTypeStr => 0};
$var{PlayerColor}      = {not_strict => 1, XML => 1, JIT => "JIT_ARRAY_PLAYER_COLOR"};
$var{PlayerOption}     = {not_strict => 1, XML => 1, JIT => "JIT_ARRAY_PLAYER_OPTION"};
$var{Plot}             = {not_strict => 1,           get => "getPlotType", JIT => "JIT_ARRAY_PLOT_TYPE"};
$var{Profession}       = {not_strict => 1, XML => 1};
$var{Promotion}        = {not_strict => 1, XML => 1};
$var{RiverModel}       = {                 XML => 1, JIT => "NO_JIT_ARRAY_TYPE", DYNAMIC => 1};
$var{Route}            = {not_strict => 1, XML => 1};
$var{RouteModel}       = {                 XML => 1, JIT => "NO_JIT_ARRAY_TYPE", DYNAMIC => 1};
$var{SeaLevel}         = {not_strict => 1, XML => 1, JIT => "JIT_ARRAY_SEA_LEVEL"};
$var{Season}           = {not_strict => 1, XML => 1, JIT => "NO_JIT_ARRAY_TYPE"};
$var{SlideShow}        = {                 XML => 1, JIT => "NO_JIT_ARRAY_TYPE", DYNAMIC => 1};
$var{SlideShowRandom}  = {                 XML => 1, JIT => "NO_JIT_ARRAY_TYPE", DYNAMIC => 1};
$var{Strategy}         = {not_strict => 1};
$var{Team}             = {not_strict => 1          , getTypeStr => 0};
$var{Terrain}          = {not_strict => 1, XML => 1};
$var{TerrainPlane}     = {                 XML => 1, JIT => "NO_JIT_ARRAY_TYPE", DYNAMIC => 1};
$var{Trait}            = {                 XML => 1};
$var{TurnTimer}        = {                 XML => 1, JIT => "NO_JIT_ARRAY_TYPE"};
$var{TradeScreen}      = {                 XML => 1, JIT => "NO_JIT_ARRAY_TYPE"};
$var{Unit}             = {not_strict => 1, XML => 1};
$var{UnitArtStyle}     = {                 XML => 1, JIT => "NO_JIT_ARRAY_TYPE", NUM => "NUM_UNIT_ARTSTYLE_TYPES", COMPILE => "COMPILE_TIME_NUM_UNIT_ARTSTYLE_TYPES"};
$var{UnitAI}           = {not_strict => 1, XML => 1};
$var{UnitClass}        = {not_strict => 1, XML => 1};
$var{UnitCombat}       = {not_strict => 1, XML => 1};
$var{SpecialUnit}      = {not_strict => 1, XML => 1, JIT => "JIT_ARRAY_UNIT_SPECIAL"};
$var{Victory}          = {not_strict => 1, XML => 1};
$var{WarPlan}          = {not_strict => 1,           JIT => "NO_JIT_ARRAY_TYPE", getTypeStr => 0};
$var{WaterPlane}       = {                 XML => 1, JIT => "NO_JIT_ARRAY_TYPE", DYNAMIC => 1};
$var{WorldPicker}      = {                 XML => 1, JIT => "NO_JIT_ARRAY_TYPE", DYNAMIC => 1};
$var{WorldSize}        = {not_strict => 1, XML => 1, JIT => "JIT_ARRAY_WORLD_SIZE"};
$var{Yield}            = {not_strict => 1, XML => 1};


$var{int}              = {var => 1, get => "getInt"};
$var{short}            = {var => 1, get => "getInt", JIT => "JIT_ARRAY_INT"};
$var{"unsigned short"} = {var => 1, get => "getInt", JIT => "JIT_ARRAY_INT"};
$var{char}             = {var => 1, get => "getInt", JIT => "JIT_ARRAY_INT"};



$output .= "#ifndef ENUM_SPECIALIZED_FUNCTIONS_H\n";
$output .= "#define ENUM_SPECIALIZED_FUNCTIONS_H\n";
$output .= "template<typename T> const char* getTypeStr(T);\n";
$output .= "#include \"../CvEnumsFunctions.h\"\n\n";

$output_cpp .= "#ifndef ENUM_SPECIALIZED_FUNCTIONS_CPP_H\n";
$output_cpp .= "#define ENUM_SPECIALIZED_FUNCTIONS_CPP_H\n";
$output_cpp .= "#include \"AutoVariableFunctions.h\"\n";
$output_cpp .= "#include \"../CvGameCoreDLL.h\"\n\n";


foreach my $name (sort(keys %var))
{
	$var{$name}{name} = $name;
	my $NAME = uc $name;
	
	setupVar($name) if exists $var{$name}{var};
	
	$var{$name}{type} = $name . "Types" unless exists $var{$name}{type};
	my $type = $var{$name}{type};
	$var{$name}{get} = "get" . $name unless exists $var{$name}{get};
	$var{$name}{JIT} = "JIT_ARRAY_" . $NAME unless exists $var{$name}{JIT};
	$var{$name}{DEFAULT} = "-1" unless exists $var{$name}{DEFAULT};
	$var{$name}{NUM} = "NUM_" . $NAME . "_TYPES" unless exists $var{$name}{NUM};
	$var{$name}{COMPILE} = "COMPILE_TIME_NUM_" . $NAME . "_TYPES" unless exists $var{$name}{COMPILE};
	$var{$name}{START} = "static_cast<$type>(0)" unless exists $var{$name}{START};
	$var{$name}{END} = $var{$name}{NUM} unless exists $var{$name}{END};
	$var{$name}{HARDCODED} = exists $var{$name}{XML} ? isAlwaysHardcodedEnum($type) : 1;
	$var{$name}{DYNAMIC} = 0 unless exists $var{$name}{DYNAMIC};
	$var{$name}{getTypeStr} = 1 unless exists $var{$name}{getTypeStr};
	
	
	if (exists $var{$name}{LENGTH_KNOWN_WHILE_COMPILING})
	{
		$var{$name}{LENGTH_KNOWN_WHILE_COMPILING} = "MAX_SHORT" if $var{$name}{LENGTH_KNOWN_WHILE_COMPILING} eq "0";

	}
	else
	{
		$var{$name}{LENGTH_KNOWN_WHILE_COMPILING} = $var{$name}{COMPILE};
	}

	handleOperators($type);
	handleComparison($name);
	handleStruct($name);
	handleInfoArray($name);
	
	$output .= "\n"; # extra newline between different variables
}

$output_cpp .= "// Here there is a static const reference from the classes pointing to non-const local yet persistent variable.\n";
$output_cpp .= "// This way the variables can be read only except for in this file there they are set once at startup.\n";
$output_cpp .= "// Yes it looks messy. That's why they are autogenerated to ensure completeness despite looking ugly.\n";
$output_cpp .= "#ifndef HARDCODE_XML_VALUES\n";
$output_cpp .= $output_cpp_declare;
$output_cpp .= "#endif\n\n";
$output_cpp .= "void setupVARINFO()\n{\n";
$output_cpp .= "#ifndef HARDCODE_XML_VALUES\n";
$output_cpp .= $output_cpp_init;
$output_cpp .= "#endif\n}\n\n";


$output .= "#endif // !ENUM_SPECIALIZED_FUNCTIONS_H\n";
$output_cpp .= "#endif // !ENUM_SPECIALIZED_FUNCTIONS_CPP_H\n";

writeFile($file, \$output);
writeFile($file_cpp, \$output_cpp);
writeFile($file_case, \$output_case);
exit();

my $file_content = "";
$file_content = read_file($file) if -e $file;


exit() if $file_content eq $output;

print "Writing new AutoVariableFunctions.h\n";

open (my $output_file, "> " . $file) or die "Can't open file " . $file . "\n" . $!;
print $output_file $output;
close $output_file;

sub setupVar
{
	my $name = shift;
	
	$var{$name}{type} = $name;
	$var{$name}{DEFAULT} = "0" unless exists $var{$name}{DEFAULT};
}

sub handleOperators
{
	my $type = shift;
	
	return if exists $var{$type}{var};
	
	operatorAdd($type, "+");
	operatorAdd($type, "-");
	
	operator($type, "++", 0);
	operator($type, "++", 1);
	operator($type, "--", 0);
	operator($type, "--", 1);
}

sub operator
{
	my $type = shift;
	my $operator = shift;
	my $postfix = shift;
	
	$output .= "static inline $type";
	$output .= "&" unless $postfix;
	$output .= " operator" . $operator . "($type& c";
	$output .= ", int" if $postfix;
	$output .= ")\n";
	$output .= "{\n";
	$output .= "\t" . $type . " cache = c;\n" if $postfix;
	$output .= "\tc = static_cast<$type>(c " . substr($operator, 0, 1) . " 1);\n";
	$output .= "\treturn ";
	$output .=  "c" unless $postfix;
	$output .=  "cache" if $postfix;
	$output .= ";\n";
	$output .= "};\n";
}

sub operatorAdd
{
	my $type = shift;
	my $operator = shift;
	
	$output .= "static inline $type operator" . $operator . "(const $type& A, const $type& B)\n";
	$output .= "{\n";
	$output .= "\treturn static_cast<$type>((int)A $operator (int)B);\n";
	$output .= "};\n";
}

sub handleComparison
{
	my $name = shift;
	my $type = $var{$name}{type};
	my $strict = 1;
	$strict = 0 if exists $var{$name}{not_strict};
	
	return if exists $var{$name}{var};
	
	for my $operator (@comparison_operators)
	{
		singleComparison($type, "T", $operator, $strict);
		singleComparison("T", $type, $operator, $strict);
	}
}

sub singleComparison
{
	my $varA = shift;
	my $varB = shift;
	my $operator = shift;
	my $strict = shift;
	
	$output .= "template <typename T>\n";
	$output .= "static inline bool operator $operator ($varA a, $varB b)\n";
	$output .= "{\n";
	$output .= "\tconst bool bTypeCheck = boost::is_same<$varA, $varB>::value;\n" if $strict;
	$output .= "\tBOOST_STATIC_ASSERT(bTypeCheck);\n" if $strict;
	$output .= "\treturn (int)a $operator (int)b;\n";
	$output .= "};\n";
}

sub handleStruct
{
	my $name = shift;
	my $type = $var{$name}{type};
	
	$output .= "template <> struct VARINFO<$type>\n";
	$output .= "{\n";
	$output .= "\tstatic const JITarrayTypes JIT = " . $var{$name}{JIT} . ";\n";
	$output .= "\tstatic const $type DEFAULT = static_cast<$type>(" . $var{$name}{DEFAULT} . ");\n";
	$output .= "\tstatic const int IS_CLASS = 0;\n";
	
	if (exists $var{$type}{var})
	{
		structVar($name);
	}
	else
	{
		structEnum($name);
	}
	$output .= "};\n";
}

sub assignCustomFirstEnd
{
	my $name = shift;
	
	if ($name eq "CityPlot")
	{
		$output .= "\tstatic const CityPlotTypes& END;\n";
		$output .= "\tstatic const CityPlotTypes& LAST;\n";
		$output .= "\tstatic const CityPlotTypes& NUM_ELEMENTS;\n";
	}
	else
	{
		return 0;
	}
	return 1;
}

sub addVariableConstant
{
	my $name = shift;
	my $var = shift;
	my $initVal = shift;
	
	my $type = $var{$name}{type};
	
	$output .= "\tconst static $type& $var;\n";
	$output_cpp_init .= "\tVARINFO_" . $type . "_$var = $initVal;\n";
	$output_cpp_declare .= "$type VARINFO_" . $type . "_$var;\n";
	$output_cpp_declare .= "const $type& VARINFO<$type>::$var = VARINFO_" . $type . "_$var;\n";
}

sub structEnum
{
	my $name = shift;
	my $type = $var{$name}{type};
	my $hardcoded = $var{$name}{HARDCODED};
	
	addgetIndexOfTypeCase($type, $var{$name}{JIT});
	
	$output .= "\tstatic const char* getName() { return \"" . $name . "\";}\n";
	$output .= "\tstatic const VariableTypes TYPE = (int)" . $var{$name}{COMPILE} . " < 128 ? VARIABLE_TYPE_CHAR : VARIABLE_TYPE_SHORT;\n";
	$output .= "\tstatic const VariableLengthTypes LENGTH_KNOWN_WHILE_COMPILING = (int)" . $var{$name}{LENGTH_KNOWN_WHILE_COMPILING} . " != MAX_SHORT ? VARIABLE_LENGTH_ALL_KNOWN : VARIABLE_LENGTH_FIRST_KNOWN;\n";
	$output .= "\tstatic const $type FIRST = " . $var{$name}{START} . ";\n";
	
	unless (assignCustomFirstEnd($name))
	{
		if ($var{$name}{DYNAMIC})
		{
			$output .= "#if 0\n";
		}
		else
		{
			$output .= "#ifdef HARDCODE_XML_VALUES\n" unless $hardcoded;
		}
		$output .= "\tstatic const $type END = $var{$name}{END};\n";
		$output .= "\tstatic const $type LAST = static_cast<" . $type . ">((int)END - 1);\n";
		$output .= "\tstatic const $type NUM_ELEMENTS = static_cast<" . $type . ">((int)END - (int)FIRST);\n";
		
		unless ($hardcoded)
		{
			$output .= "#else\n";
			
			if ($var{$name}{DYNAMIC})
			{
				$output_cpp_init .= "#endif\n";
				$output_cpp_declare .= "#endif\n";
			}
			addVariableConstant($name, "END", "$var{$name}{END}");
			addVariableConstant($name, "LAST", "$var{$name}{END} - static_cast<$type>(1)");
			addVariableConstant($name, "NUM_ELEMENTS", "VARINFO<$type>::END - VARINFO<$type>::FIRST");
			if ($var{$name}{DYNAMIC})
			{
				$output_cpp_init .= "#ifndef HARDCODE_XML_VALUES\n";
				$output_cpp_declare .= "#ifndef HARDCODE_XML_VALUES\n";
			}
			$output .= "#endif\n";
		}
	}
	$output .= "\tstatic const $type LENGTH = " . $var{$name}{COMPILE} . ";\n";
	$output .= "\tstatic bool isInRange($type eIndex) { return eIndex >= FIRST && eIndex < END; }\n";
	$output .= "\ttemplate <int T> struct STATIC {\n";
	$output .= "\t\tstatic const VariableStaticTypes VAL = T * ((int)TYPE == (int)VARIABLE_TYPE_CHAR ? 1 : 2) <= 4 ? VARIABLE_TYPE_STATIC : VARIABLE_TYPE_DYNAMIC;\n";
	$output .= "\t};\n";
	$output .= "\ttemplate <typename T> struct COMPATIBLE {\n";
	$output .= "\t\tstatic const bool VAL = boost::is_same<" . $type . ", T>::VAL;\n";
	$output .= "\t};\n";
	if ($var{$name}{getTypeStr})
	{
		$output_cpp .= "template<>\nconst char* getTypeStr($type eIndex)\n{\n";
		if (defined $var{$name}{INFO})
		{
			$output_cpp .= "\treturn GC." . $var{$name}{INFO} . "(eIndex).getType();\n";
		}
		else
		{
			$output_cpp .= "\treturn getArrayType(VARINFO<$type>::JIT, eIndex);\n";
		}
		$output_cpp .= "}\n\n";
	}

}

sub structVar
{
	my $name = shift;
	my $type = $var{$name}{type};
	
	$output .= "\tstatic const VariableTypes TYPE = VARIABLE_TYPE_GENERIC;\n";
	$output .= "\ttemplate <int T> struct STATIC {\n";
	$output .= "\t\tstatic const VariableStaticTypes VAL = (T * sizeof($type)) <= 4 ? VARIABLE_TYPE_STATIC : VARIABLE_TYPE_DYNAMIC;\n";
	$output .= "\t};\n";
	handleStructVarGroup($type);
}

sub handleStructVarGroup
{
	my $type = shift;
	
	$output .= "\ttemplate <typename T> struct COMPATIBLE {\n";
	
	my $length = scalar @compatible_variables;
	
	for my $i (0..$length-1)
	{
		#if ($type eq $compatible_variables[$i][0])
		if (any { /$type/ } @{$compatible_variables[$i]})
		{
			$output .= "\t\tstatic const bool VAL = false";
			foreach my $var (@{$compatible_variables[$i]})
			{
				$output .= " || boost::is_same<" . $var . ", T>::VAL";
			}
			$output .= ";\n";
			$output .= "\t};\n";
			return;
		}
	}
	
	$output .= "\t\tstatic const bool VAL = boost::is_same<" . $type . ", T>::VAL;\n";
	$output .= "\t};\n";
}

sub handleInfoArray
{
	my $name = shift;
	
	return unless $GENERATE_INFOARRAY;
	
	return if $var{$name}{JIT} eq "NO_JIT_ARRAY_TYPE";
	
	handleInfoArraySingle($name, 1);
	handleInfoArraySingle($name, 2);
	handleInfoArraySingle($name, 3);
	handleInfoArraySingle($name, 4);

}sub handleInfoArraySingle
{
	my $name = shift;
	my $id = shift;
	my $type = $var{$name}{type};
	my $get = $var{$name}{get};
	my $index = $id - 1;
	
	$output .= "template<" . addtemplates("typename T", $id, 0) . ">\nclass InfoArray$id<" . addtemplates("T", $id, 1) . $type . ">\n\t: ";
	$output .= "public InfoArray$index<" . addtemplates("T", $id, 0) . ">\n" unless $id == 1;
	$output .= "protected InfoArrayBase\n\t, public boost::noncopyable\n" if $id == 1;
	$output .= "{\n";
	$output .= "\tfriend class CyInfoArray;\n";
	$output .= "public:\n";
	if ($id == 1)
	{
		$output .= "\tint getLength() const\n\t{\n\t\treturn InfoArrayBase::getLength();\n\t}\n";
		$output .= "\t$type get(int iIndex) const\n";
		$output .= "\t{\n";
		$output .= "\t\treturn static_cast<$type>(getInternal(iIndex, $index));\n";
		$output .= "\t}\n";
	}
	$output .= "\t$type get$index(int iIndex) const\n";
	$output .= "\t{\n";
	$output .= "\t\treturn static_cast<$type>(getInternal(iIndex, $index));\n";
	$output .= "\t}\n";
	$output .= "\t$type $get(int iIndex) const\n";
	$output .= "\t{\n";
	$output .= "\t\treturn static_cast<$type>(getInternal(iIndex, $index));\n";
	$output .= "\t}\n";
	$output .= "\tint getIndexOf($type eValue) const\n";
	$output .= "\t{\n";
	$output .= "\t\treturn _getIndexOf(eValue, $index);\n";
	$output .= "\t}\n";
	$output .= "protected:\n";
	$output .= "friend class CvCity;\n" if $id == 1;
	$output .= "friend class CvGlobals;\n" if $id == 1;
	$output .= "friend class CivEffectInfo;\n" if $id == 1;
	$output .= "friend class CvPlayerCivEffect;\n" if $id == 1;
	$output .= "friend class CvInfoBase;\n" if $id == 1;
	$output .= "\tInfoArray$id(JITarrayTypes eType0, JITarrayTypes eType1, JITarrayTypes eType2, JITarrayTypes eType3)\n";
	$output .= "\t\t: InfoArray" . ($id - 1) . "<" . addtemplates("T", $id, 0) . ">(eType0, eType1, eType2, eType3) {}\n" unless $id == 1;
	$output .= "\t\t: InfoArrayBase(eType0, eType1, eType2, eType3) {}\n" if $id == 1;
	$output .= "};\n";
}

sub addtemplates
{
	my $str = shift;
	my $id = shift;
	my $append_comma = shift;
	
	my $return = "";
	
	my $i = 1;
	
	return $return if $i == $id;
	$return .=  $str . "0";
	$i = 2;
	
	while ($i < $id)
	{
		$return .=  ", " . $str . ($i - 1);
		$i += 1;
	}
	
	$return .= ", " if $append_comma;
	return $return;
}

sub addgetIndexOfTypeCase
{
	my $type = shift;
	my $jit  = shift;
	
	return if $jit eq "NO_JIT_ARRAY_TYPE";
	
	$output_case .= "\t\tcase $jit:\n";
	$output_case .= "\t\t{\n";
	$output_case .= "\t\t\t$type eTmp;\n";
	$output_case .= "\t\t\treturn getIndexOfType(eTmp, szType);\n";
	$output_case .= "\t\t}\n";
}
