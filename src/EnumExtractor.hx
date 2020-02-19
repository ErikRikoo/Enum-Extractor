package;


#if macro
import haxe.macro.ExprTools;
import haxe.macro.Context;
import haxe.macro.Expr;

class EnumExtractor {
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
            case EMeta(entry, block) if(entry.name == "extract"):
                buildExtractingExpression(entry.params, ExprTools.map(block, modifyExpr));
            default:
                ExprTools.map(e, modifyExpr);
        }
    }

    private static function buildExtractingExpression(params:Array<Expr>, block:Expr):Expr {
        var value = params[0];
        var pattern = params[1];
        
        var ret = macro switch ($value) {
            case $pattern: $block;
            default: {}
          };
        trace(ExprTools.toString(ret));
        return ret;
    }
}

#else
@:autoBuild(EnumExtractor.build())
interface EnumExtractor {
    
}
#end