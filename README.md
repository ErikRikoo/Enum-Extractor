# Enum Extractor
This library provides sugar syntax to access Enum value for one pattern and do nothing for other patterns.

## Usage
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
	}
}
```

The haxe code generated for the last extraction will be:
```haxe
    switch(a) {
        case Value2(v1, v2):
            trace(v1 + v2);
        default:
    }
```

## Remarks
This library allow you to use or patterns(|) and extractors(=>) but not guards.

