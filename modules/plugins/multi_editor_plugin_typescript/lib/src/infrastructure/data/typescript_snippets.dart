import 'package:multi_editor_plugins/multi_editor_plugins.dart';

/// Collection of TypeScript code snippets for autocomplete.
///
/// Contains TypeScript-specific constructs including types, interfaces, generics, decorators, etc.
class TypeScriptSnippets {
  TypeScriptSnippets._();

  // ============================================================================
  // BASIC TYPESCRIPT CONSTRUCTS
  // ============================================================================

  static const function_ = SnippetData(
    prefix: 'fn',
    label: 'function',
    body:
        'function \${1:functionName}(\${2:params}: \${3:type}): \${4:returnType} {\n  \${5:// code}\n}',
    description: 'Function declaration with types',
  );

  static const arrowFunction = SnippetData(
    prefix: 'af',
    label: 'arrow function',
    body:
        'const \${1:functionName} = (\${2:params}: \${3:type}): \${4:returnType} => {\n  \${5:// code}\n};',
    description: 'Arrow function with types',
  );

  static const arrowFunctionSingle = SnippetData(
    prefix: 'afe',
    label: 'arrow function expression',
    body:
        'const \${1:functionName} = (\${2:params}: \${3:type}): \${4:returnType} => \${5:expression};',
    description: 'Single-line arrow function with types',
  );

  static const asyncFunction = SnippetData(
    prefix: 'afn',
    label: 'async function',
    body:
        'async function \${1:functionName}(\${2:params}: \${3:type}): Promise<\${4:returnType}> {\n  \${5:// code}\n}',
    description: 'Async function with types',
  );

  static const asyncArrowFunction = SnippetData(
    prefix: 'aaf',
    label: 'async arrow function',
    body:
        'const \${1:functionName} = async (\${2:params}: \${3:type}): Promise<\${4:returnType}> => {\n  \${5:// code}\n};',
    description: 'Async arrow function with types',
  );

  // ============================================================================
  // TYPES & INTERFACES
  // ============================================================================

  static const interface_ = SnippetData(
    prefix: 'interface',
    label: 'interface',
    body:
        'interface \${1:InterfaceName} {\n  \${2:property}: \${3:type};\n  \${4:method}(\${5:params}: \${6:type}): \${7:returnType};\n}',
    description: 'Interface declaration',
  );

  static const interfaceExtends = SnippetData(
    prefix: 'interfaceex',
    label: 'interface extends',
    body:
        'interface \${1:InterfaceName} extends \${2:BaseInterface} {\n  \${3:property}: \${4:type};\n}',
    description: 'Interface with inheritance',
  );

  static const type_ = SnippetData(
    prefix: 'type',
    label: 'type alias',
    body: 'type \${1:TypeName} = \${2:type};',
    description: 'Type alias',
  );

  static const typeUnion = SnippetData(
    prefix: 'typeu',
    label: 'union type',
    body: 'type \${1:TypeName} = \${2:Type1} | \${3:Type2};',
    description: 'Union type',
  );

  static const typeIntersection = SnippetData(
    prefix: 'typei',
    label: 'intersection type',
    body: 'type \${1:TypeName} = \${2:Type1} & \${3:Type2};',
    description: 'Intersection type',
  );

  static const enum_ = SnippetData(
    prefix: 'enum',
    label: 'enum',
    body: 'enum \${1:EnumName} {\n  \${2:Value1} = \${3:0},\n  \${4:Value2} = \${5:1},\n}',
    description: 'Enum declaration',
  );

  static const enumString = SnippetData(
    prefix: 'enums',
    label: 'string enum',
    body:
        "enum \${1:EnumName} {\n  \${2:Value1} = '\${3:value1}',\n  \${4:Value2} = '\${5:value2}',\n}",
    description: 'String enum declaration',
  );

  // ============================================================================
  // CLASSES
  // ============================================================================

  static const classSnippet = SnippetData(
    prefix: 'class',
    label: 'class',
    body:
        'class \${1:ClassName} {\n  private \${2:property}: \${3:type};\n\n  constructor(\${4:params}: \${5:type}) {\n    \${6:// constructor code}\n  }\n\n  \${7:// methods}\n}',
    description: 'Class declaration with types',
  );

  static const classWithExtends = SnippetData(
    prefix: 'classex',
    label: 'class extends',
    body:
        'class \${1:ClassName} extends \${2:BaseClass} {\n  constructor(\${3:params}: \${4:type}) {\n    super(\${5:superParams});\n    \${6:// constructor code}\n  }\n\n  \${7:// methods}\n}',
    description: 'Class with inheritance',
  );

  static const classImplements = SnippetData(
    prefix: 'classimp',
    label: 'class implements',
    body:
        'class \${1:ClassName} implements \${2:InterfaceName} {\n  \${3:property}: \${4:type};\n\n  constructor(\${5:params}: \${6:type}) {\n    \${7:// constructor code}\n  }\n\n  \${8:// methods}\n}',
    description: 'Class implementing interface',
  );

  static const method = SnippetData(
    prefix: 'met',
    label: 'method',
    body:
        '\${1:methodName}(\${2:params}: \${3:type}): \${4:returnType} {\n  \${5:// code}\n}',
    description: 'Class method with types',
  );

  static const asyncMethod = SnippetData(
    prefix: 'amet',
    label: 'async method',
    body:
        'async \${1:methodName}(\${2:params}: \${3:type}): Promise<\${4:returnType}> {\n  \${5:// code}\n}',
    description: 'Async class method with types',
  );

  static const getter = SnippetData(
    prefix: 'get',
    label: 'getter',
    body: 'get \${1:propertyName}(): \${2:type} {\n  return \${3:value};\n}',
    description: 'Getter method with type',
  );

  static const setter = SnippetData(
    prefix: 'set',
    label: 'setter',
    body:
        'set \${1:propertyName}(\${2:value}: \${3:type}) {\n  \${4:// setter code}\n}',
    description: 'Setter method with type',
  );

  // ============================================================================
  // GENERICS
  // ============================================================================

  static const genericFunction = SnippetData(
    prefix: 'fng',
    label: 'generic function',
    body:
        'function \${1:functionName}<\${2:T}>(\${3:param}: \${2:T}): \${4:returnType}<\${2:T}> {\n  \${5:// code}\n}',
    description: 'Generic function',
  );

  static const genericClass = SnippetData(
    prefix: 'classg',
    label: 'generic class',
    body:
        'class \${1:ClassName}<\${2:T}> {\n  private \${3:property}: \${2:T};\n\n  constructor(\${4:value}: \${2:T}) {\n    this.\${3:property} = \${4:value};\n  }\n}',
    description: 'Generic class',
  );

  static const genericInterface = SnippetData(
    prefix: 'interfaceg',
    label: 'generic interface',
    body: 'interface \${1:InterfaceName}<\${2:T}> {\n  \${3:property}: \${2:T};\n}',
    description: 'Generic interface',
  );

  // ============================================================================
  // CONTROL FLOW (TypeScript specific)
  // ============================================================================

  static const ifStatement = SnippetData(
    prefix: 'if',
    label: 'if statement',
    body: 'if (\${1:condition}) {\n  \${2:// code}\n}',
    description: 'If statement',
  );

  static const ifElseStatement = SnippetData(
    prefix: 'ife',
    label: 'if-else statement',
    body:
        'if (\${1:condition}) {\n  \${2:// code}\n} else {\n  \${3:// code}\n}',
    description: 'If-else statement',
  );

  static const forLoop = SnippetData(
    prefix: 'for',
    label: 'for loop',
    body:
        'for (let \${1:i}: number = 0; \${1:i} < \${2:length}; \${1:i}++) {\n  \${3:// code}\n}',
    description: 'For loop with type',
  );

  static const forOfLoop = SnippetData(
    prefix: 'forof',
    label: 'for-of loop',
    body:
        'for (const \${1:item} of \${2:array}) {\n  \${3:// code}\n}',
    description: 'For-of loop',
  );

  static const switchCase = SnippetData(
    prefix: 'switch',
    label: 'switch statement',
    body:
        'switch (\${1:expression}) {\n  case \${2:value1}:\n    \${3:// code}\n    break;\n  case \${4:value2}:\n    \${5:// code}\n    break;\n  default:\n    \${6:// default code}\n}',
    description: 'Switch statement',
  );

  // ============================================================================
  // ASYNC/AWAIT & PROMISES
  // ============================================================================

  static const promise = SnippetData(
    prefix: 'prom',
    label: 'promise',
    body:
        'new Promise<\${1:type}>((resolve, reject) => {\n  \${2:// async code}\n  resolve(\${3:value});\n});',
    description: 'Promise constructor with type',
  );

  static const asyncAwait = SnippetData(
    prefix: 'aw',
    label: 'await',
    body: 'await \${1:promise}',
    description: 'Await expression',
  );

  static const tryCatch = SnippetData(
    prefix: 'try',
    label: 'try-catch',
    body:
        'try {\n  \${1:// code}\n} catch (\${2:error}: unknown) {\n  \${3:// error handling}\n}',
    description: 'Try-catch block with typed error',
  );

  // ============================================================================
  // DECORATORS
  // ============================================================================

  static const classDecorator = SnippetData(
    prefix: 'decc',
    label: 'class decorator',
    body:
        'function \${1:decoratorName}(constructor: Function) {\n  \${2:// decorator logic}\n}',
    description: 'Class decorator',
  );

  static const methodDecorator = SnippetData(
    prefix: 'decm',
    label: 'method decorator',
    body:
        'function \${1:decoratorName}(target: any, propertyKey: string, descriptor: PropertyDescriptor) {\n  \${2:// decorator logic}\n}',
    description: 'Method decorator',
  );

  static const propertyDecorator = SnippetData(
    prefix: 'decp',
    label: 'property decorator',
    body:
        'function \${1:decoratorName}(target: any, propertyKey: string) {\n  \${2:// decorator logic}\n}',
    description: 'Property decorator',
  );

  // ============================================================================
  // ES6+ FEATURES WITH TYPES
  // ============================================================================

  static const destructuringArray = SnippetData(
    prefix: 'desa',
    label: 'destructuring array',
    body: 'const [\${1:first}, \${2:second}]: \${3:type}[] = \${4:array};',
    description: 'Array destructuring with type',
  );

  static const destructuringObject = SnippetData(
    prefix: 'deso',
    label: 'destructuring object',
    body: 'const { \${1:property} }: \${2:type} = \${3:object};',
    description: 'Object destructuring with type',
  );

  static const importNamed = SnippetData(
    prefix: 'imp',
    label: 'import named',
    body: "import { \${1:exports} } from '\${2:module}';",
    description: 'Named import',
  );

  static const importDefault = SnippetData(
    prefix: 'impd',
    label: 'import default',
    body: "import \${1:name} from '\${2:module}';",
    description: 'Default import',
  );

  static const importType = SnippetData(
    prefix: 'impt',
    label: 'import type',
    body: "import type { \${1:Type} } from '\${2:module}';",
    description: 'Import type only',
  );

  static const exportNamed = SnippetData(
    prefix: 'exp',
    label: 'export named',
    body: 'export { \${1:name} };',
    description: 'Named export',
  );

  static const exportDefault = SnippetData(
    prefix: 'expd',
    label: 'export default',
    body: 'export default \${1:value};',
    description: 'Default export',
  );

  static const exportType = SnippetData(
    prefix: 'expt',
    label: 'export type',
    body: 'export type { \${1:Type} };',
    description: 'Export type only',
  );

  // ============================================================================
  // UTILITY TYPES
  // ============================================================================

  static const partial = SnippetData(
    prefix: 'partial',
    label: 'Partial type',
    body: 'Partial<\${1:Type}>',
    description: 'Partial utility type',
  );

  static const readonly_ = SnippetData(
    prefix: 'readonly',
    label: 'Readonly type',
    body: 'Readonly<\${1:Type}>',
    description: 'Readonly utility type',
  );

  static const record = SnippetData(
    prefix: 'record',
    label: 'Record type',
    body: 'Record<\${1:Key}, \${2:Value}>',
    description: 'Record utility type',
  );

  static const pick = SnippetData(
    prefix: 'pick',
    label: 'Pick type',
    body: "Pick<\${1:Type}, '\${2:property}'>",
    description: 'Pick utility type',
  );

  static const omit = SnippetData(
    prefix: 'omit',
    label: 'Omit type',
    body: "Omit<\${1:Type}, '\${2:property}'>",
    description: 'Omit utility type',
  );

  // ============================================================================
  // CONSOLE & DEBUGGING
  // ============================================================================

  static const consoleLog = SnippetData(
    prefix: 'cl',
    label: 'console.log',
    body: "console.log('\${1:label}:', \${2:value});",
    description: 'Console log',
  );

  static const consoleError = SnippetData(
    prefix: 'ce',
    label: 'console.error',
    body: "console.error('\${1:error}:', \${2:error});",
    description: 'Console error',
  );

  // ============================================================================
  // COMPLETE SNIPPET LIST
  // ============================================================================

  /// All available TypeScript snippets (50 total).
  static const List<SnippetData> all = [
    // Functions
    function_,
    arrowFunction,
    arrowFunctionSingle,
    asyncFunction,
    asyncArrowFunction,
    // Types & Interfaces
    interface_,
    interfaceExtends,
    type_,
    typeUnion,
    typeIntersection,
    enum_,
    enumString,
    // Classes
    classSnippet,
    classWithExtends,
    classImplements,
    method,
    asyncMethod,
    getter,
    setter,
    // Generics
    genericFunction,
    genericClass,
    genericInterface,
    // Control Flow
    ifStatement,
    ifElseStatement,
    forLoop,
    forOfLoop,
    switchCase,
    // Async/Await
    promise,
    asyncAwait,
    tryCatch,
    // Decorators
    classDecorator,
    methodDecorator,
    propertyDecorator,
    // ES6+ with Types
    destructuringArray,
    destructuringObject,
    importNamed,
    importDefault,
    importType,
    exportNamed,
    exportDefault,
    exportType,
    // Utility Types
    partial,
    readonly_,
    record,
    pick,
    omit,
    // Console
    consoleLog,
    consoleError,
  ];
}
