package utils;

import haxe.macro.Expr;
import haxe.macro.Type;
import haxe.macro.Context;

/**
 * ...
 * @author Masadow
 */
class Serializer
{
	
	@macro public static function build() : Array<Field>
	{
		var pos = Context.currentPos();
		var fields : Array<Field> = Context.getBuildFields();
		var serializeCalls : Array<Expr> = new Array<Expr>();
		var unserializeCalls : Array<Expr> = new Array<Expr>();
		
		//Get all serializable fields
		for (field in fields)
		{
			for (meta in field.meta)
			{
				if (meta.name == "serialize")
				{
					var fieldName = field.name;
					serializeCalls.push(macro s.serialize($i{fieldName}));
					unserializeCalls.push(macro $i{fieldName} = u.unserialize() );
				}
			}
		}
		
		//Create methods
		var hxSerialize : FieldType = FFun( {
			ret: null,
			params: [],
			expr: {
				pos: pos,
				expr: EBlock(serializeCalls)
			},
			args: [ {
					value: null,
					type: macro : haxe.Serializer,
					opt: false,
					name: "s"
				}]
		});
		var hxUnserialize : FieldType = FFun( {
			ret: null,
			params: [],
			expr: {
				pos: pos,
				expr: EBlock(unserializeCalls)
			},
			args: [ {
					value: null,
					type: macro : haxe.Unserializer,
					opt: false,
					name: "u"
				}]
		});
		
		fields.push( { pos:pos, name:"hxSerialize", meta:[], kind: hxSerialize, doc: null, access:[APublic] } ); 
		fields.push( { pos:pos, name:"hxUnserialize", meta:[], kind: hxUnserialize, doc: null, access:[APublic] } ); 
		
		return fields;
	}
	
}