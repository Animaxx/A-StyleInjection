# A-StyleInjection

**A Style Injection** provide the injection way to customize whole iOS application base on the single configuration file.


## Installation
Cocoa Pod install:
```
  pod 'A_StyleInjection'
```



## Style Sheet Format and Rules

In the style map, style item are follow below format:

1. **Multilayer style map**:
   - First layer can be either the class name of UIViewController or Type/Name style set  
   - Second layer cannot be the class name of UIViewController, only can be the name of Type/Name style set
   - When the first layer is the class name of UIViewController, that means all the children style set are apply under this UIViewController
   - When the first layer is the type/name style set, which means the style set will apply globally with lower priority

2. **Type style set**:  
   - When the key start with special character `@` means apple the style setting to the type of controls
   - For instance, `@UILabel` means the style set apply to all the `@UILabel` under that level

3. **Name style set**:  
   - When the key start with special character `#` means apple the style setting to the controls with the styleIdentifier
   - For instance, `#demoLabel` means the style set apple to all UIViews with the styleIdentifier named `#demoLabel`  

4. **Value of style set**:  
   - Style set should be dictionary, key is property name of the control; and the value is the value of the property
   - The key as property can be class/structure, and in some case need to set the property to the sub-property; we can using `(dot .)` in this case:
     + For Example, set the view to be rounded corners; then we can have  
   - In the plist, we can only set value as string, here is the format for the style set to allow us to setup different object:  
     + Color: it must start with `#` and come along with 6 digit, e.g. `#A0A0A0`  
     + Font: it must start with `$` come along with `""` has Font name init, then `:` with size of Font, e.g. `$"Helvetica Neue":17`

