# docgen

docgen is a utility to parse code into a markdown file. The common scenario is to auto-generate a technical markdown but some parts are written in code.

## Usage

```
USAGE: docgen [--verbose] [--enable-indent] [--disable-indent] [--codetag <codetag>] [--methodtag <methodtag>] [--attributetag <attributetag>] [--source-file-name-exts <source-file-name-exts>] [--document-file-name-exts <document-file-name-exts>] <source-path> <docuemnt-path>

ARGUMENTS:
  <source-path>           source folder
  <docuemnt-path>         document folder

OPTIONS:
  --verbose
  --enable-indent/--disable-indent
                          indent with codetag (default: --enable-indent)
  --codetag <codetag>     codetag (default: SAMPLE)
  --methodtag <methodtag> (default: METHOD)
  --attributetag <attributetag>
                          (default: ATTRIBUTE)
  --source-file-name-exts <source-file-name-exts>
                          source file name extention (default: kt,java,swift,m,mm,xml,c,cpp)
  --document-file-name-exts <document-file-name-exts>
                          doucment file name extention (default: md)
  -h, --help              Show help information.
  ```

## Supports
Use a variable like `{{identifier}}` in the markdown file. The utility parse code or comment with the same identifier, and replace it in markdown. The default code file we search are: java, kotlin, xml (for Android), swift, m, mm, c and cpp.

## Sample code

Sample is the comments in code. When detected, it extract the source and don't change the format.

### Line Comment
```c
// SAMPLE: abc
code ...
// SAMPLE
```
the code between SAMPLE are assign to variable "abc". 

### Inline Comment
```c
code line // SAMPLE: abc
```
This inline commnet usaully for single line comment.

### Block Comment
```c
unused /* SAMPLE: abc */ want /* SAMPLE */ blabla
```
This block comment used for some samll code. ** Not Recommend **.

### XML Comment
Support extract part of xml lines.
```xml
<!--SAMPLE:abc-->
<class_list>
  <key>data</key>
</class_list>
<!--SAMPLE-->
```
Here use xml comment.

## API document 

This keyword is used to generate API table like https://ant.design/components/button-cn#api.

The comment format must be `/// METHOD: class_name.method_name` or `/// ATTRIBUT: class_name.attribute_name`.

After process all the input file, it will **merge** all method or attribut with same class name into a table.

Table in markdown file use the identifier `{{METHOD:class_name}}` or `{{ATTRIBUT:class_name}}`.

### Swift style
```Swift
/// METHOD: Button.init
/// Designer defined button
/// - Parameters:
///   - frame: size of frame
///   - text: the string on button
///   - icon: the image shown on the left of the text
public init(
  frame: CGRect,
  text: String? = nil,
  icon: UIImage? = nil,
) {
}

/// ATTRIBUT: Button.color
/// the tint color
/// - Value: Default: black
public var color: Color! 
```

### Swift official style
```Swift
/// METHOD: Name.createFullName
/**
This is an extremely complicated method that concatenates
- Parameter firstname:The first part of the full name.
- Parameter lastname:The last part of the fullname.

Returns:The full name as a string value.
*/
func createFullName(firstname:String, lastname:String)->String { 
    return "\(firstname)\(lastname)"
}
```

### JavaDoc style
```Java
/// METHOD: Button.constructor
/**
creating new instance programmatically
 
@param buttonType button type
@param buttonIcon button icon
*/
constructor(buttonType: Int, buttonIcon: Drawable?) {
}
    
/// ATTRIBUT: Button.color
/**
the color of the text
  
@value color: Default: black
*/
public var color: Color;
```
