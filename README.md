# A-StyleInjection


[![Waffle.io - Columns and their card count](https://badge.waffle.io/Animaxx/A-StyleInjection.svg?columns=all)](https://waffle.io/Animaxx/A-StyleInjection)

**A Style Injection** is an open source library provide the way to custom your iOS application without rewrite whole project.

## Installation
Cocoa Pod install

## Usage Example
1. Setup the style name for your special contols.
2. Setup the style sheet

## Style Sheet
Now the project only support .plist file as style sheet file format. Style setting represent as multiple layer key-value structure.

Rule of Keys:
	
	1. key start of @ means that is the class of control view. Such as @UILabel means apply to all UILabel in this level.
	2. key start of # means only apply to special style name. For example #demo1 means only apply the style to these control views named 'demo1'.
	3. key start without any special character means it's a class of Controller. 

Rule of Value:
	

