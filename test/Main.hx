enum A {
	Value(v:Int);
	Value2(v1:Int, v2:Int);
}

class Main implements EnumExtractor {
	static function main() {
		var a:A = Value(5);
		@extract(a, Value(v)) {
			trace(v);
		}

		a = Value2(5, 10);
		@extract(a, Value(v) | Value2(_, v)) {
			trace(v);
		}
	}
}
