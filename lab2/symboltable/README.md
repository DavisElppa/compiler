# symboltable

try1.y为实现字符表的第一次尝试：

使用bison运行时出现expr定义字符组规则的错误，自己并没有找到原因

symbol.y发现了try1中的错误：expr应定义为type，而不是token，并正确实现了符号表

symbo2.y在symbol.y的基础上实现了小数的识别
