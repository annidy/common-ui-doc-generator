# docgen

docgen is a utility to parse code into a markdown file. The common scenario is to auto-generate a technical markdown but some parts are written in code.

## Supports
Use a variable like `{{identifier}}` in the markdown file. The utility parse code or comment with the same identifier, and replace it in markdown. The default code file we search are: java, kotlin, xml (for Android), swift, m, mm, c and cpp.

## Comments

Comments is used for code, it don't change the format.

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

## API Document 

