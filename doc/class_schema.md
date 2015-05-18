#Class schema

```json
{
  "meta": [{
    "name": "Module"
  }],
  "lib": "my.lib",
  "name": "*Module",
  "fields": [{
    "name": "moduleName",
	"type": "String",
	"optional": false
  }],
  "methods": [{
    "meta": [],
    "name": "methodName",
    "returnType": "bool",
    "positionalParameter": ["String", "int"],
    "namedParameter": [{
      "name": "parameterName",
      "type": "String"
    }],
    "optional": false
  }] 
}
```
