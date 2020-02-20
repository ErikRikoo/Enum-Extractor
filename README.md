# Enum Extractor
This library provides sugar syntax to access Enum value for one pattern and do nothing for other patterns.

## Usage
You should implement EnumExtractor to be able to use this.

This code ([...] means optionnal):
```haxe
@as(variable => pattern [, [@if] conditionnal]) {
	// code executed if variable matches pattern
}
```
Will generate:
```haxe 
switch(variable) {
	case pattern [if(conditionnal)]:
		// code
	default:
}
```

## Exemples
If you have an enum like:
```haxe
enum A {
    Value(v:Int);
    Value2(v1:Int, v2:Int);
}
```

You can use the extractor like this:
```haxe
class Main implements EnumExtractor {
    static function main() {
		var a:A = Value(5);
		@as(a => Value(v)) {
			trace(v); // Traces 5
		}

		a = Value2(5, 10);
		@as(a => Value(v) | Value2(_, v)) {
			trace(v); // Traces 10
		}

		// You can also use it on multiple values
		@as(a => Value2(v1, v2)) {
			trace(v1 + v2); // Traces 15
		}

		// You can use the optional second argument to have a guard on it
		@as(a => Value2(v1, v2), v1 > 6) {
			trace(v1 + v2); // Will not trace anything because v1 = 5 <= 6
		}

		// You can use @if before the guard to add semantic
		@as(a => Value2(v1, v2), @if v1 > 2) {
			trace(v1 + v2); // Traces 15 because v1 > 2
		}
	}
}
```