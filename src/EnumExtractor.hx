package;


#if macro
import haxe.macro.ExprTools;
import haxe.macro.Context;
import haxe.macro.Expr;

class EnumExtractor {
    private static var metaName = "as";

    public static macro function build():Array<Field> {
        var fields:Array<Field> = Context.getBuildFields();

        for(field in fields) {
            switch(field.kind) {
                case FFun(f):
                    f.expr = modifyExpr(f.expr);
                default:
            }
        }

        return fields;
    }

    private static function modifyExpr(e:Expr):Expr {
        return switch(e.expr) {
            case null:
                null;
            case EMeta(entry, block) if(entry.name == metaName):
                buildExtractingExpression(entry.params, ExprTools.map(block, modifyExpr), e.pos);
            default:
                ExprTools.map(e, modifyExpr);
        }
    }

    private static function buildExtractingExpression(params:Array<Expr>, block:Expr, metaPos:Position):Expr {
        switch(params[0]) {
            case macro $value => $pattern:
                var ret = macro switch ($value) {
                    case $pattern: $block;
                    default: {}
                  };
                // trace(ExprTools.toString(ret));
                return ret;
            case null:
                throw new Error("Invalid pattern: it must not be empty", metaPos);
            default:
                throw new Error("Invalid pattern: it must be expr => expr", params[0].pos);
        }
    }
}

#else
@:autoBuild(EnumExtractor.build())
interface EnumExtractor {
    
}
#end