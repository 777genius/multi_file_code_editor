import 'package:multi_editor_plugins/multi_editor_plugins.dart';

/// Collection of JavaScript/ES6+ code snippets for autocomplete.
///
/// Contains modern JavaScript language constructs, async/await, classes, modules, etc.
class JavaScriptSnippets {
  JavaScriptSnippets._();

  // ============================================================================
  // BASIC JAVASCRIPT CONSTRUCTS
  // ============================================================================

  static const function_ = SnippetData(
    prefix: 'fn',
    label: 'function',
    body: 'function \${1:functionName}(\${2:params}) {\n  \${3:// code}\n}',
    description: 'Function declaration',
  );

  static const arrowFunction = SnippetData(
    prefix: 'af',
    label: 'arrow function',
    body: 'const \${1:functionName} = (\${2:params}) => {\n  \${3:// code}\n};',
    description: 'Arrow function',
  );

  static const arrowFunctionSingle = SnippetData(
    prefix: 'afe',
    label: 'arrow function expression',
    body: 'const \${1:functionName} = (\${2:params}) => \${3:expression};',
    description: 'Single-line arrow function',
  );

  static const asyncFunction = SnippetData(
    prefix: 'afn',
    label: 'async function',
    body:
        'async function \${1:functionName}(\${2:params}) {\n  \${3:// code}\n}',
    description: 'Async function declaration',
  );

  static const asyncArrowFunction = SnippetData(
    prefix: 'aaf',
    label: 'async arrow function',
    body:
        'const \${1:functionName} = async (\${2:params}) => {\n  \${3:// code}\n};',
    description: 'Async arrow function',
  );

  static const classSnippet = SnippetData(
    prefix: 'class',
    label: 'class',
    body:
        'class \${1:ClassName} {\n  constructor(\${2:params}) {\n    \${3:// constructor code}\n  }\n\n  \${4:// methods}\n}',
    description: 'Class declaration',
  );

  static const classWithExtends = SnippetData(
    prefix: 'classex',
    label: 'class extends',
    body:
        'class \${1:ClassName} extends \${2:BaseClass} {\n  constructor(\${3:params}) {\n    super(\${4:superParams});\n    \${5:// constructor code}\n  }\n\n  \${6:// methods}\n}',
    description: 'Class with inheritance',
  );

  static const method = SnippetData(
    prefix: 'met',
    label: 'method',
    body: '\${1:methodName}(\${2:params}) {\n  \${3:// code}\n}',
    description: 'Class method',
  );

  static const asyncMethod = SnippetData(
    prefix: 'amet',
    label: 'async method',
    body: 'async \${1:methodName}(\${2:params}) {\n  \${3:// code}\n}',
    description: 'Async class method',
  );

  static const getter = SnippetData(
    prefix: 'get',
    label: 'getter',
    body: 'get \${1:propertyName}() {\n  return \${2:value};\n}',
    description: 'Getter method',
  );

  static const setter = SnippetData(
    prefix: 'set',
    label: 'setter',
    body: 'set \${1:propertyName}(\${2:value}) {\n  \${3:// setter code}\n}',
    description: 'Setter method',
  );

  // ============================================================================
  // CONTROL FLOW
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

  static const ternary = SnippetData(
    prefix: 'ter',
    label: 'ternary operator',
    body: '\${1:condition} ? \${2:trueValue} : \${3:falseValue}',
    description: 'Ternary operator',
  );

  static const forLoop = SnippetData(
    prefix: 'for',
    label: 'for loop',
    body:
        'for (let \${1:i} = 0; \${1:i} < \${2:length}; \${1:i}++) {\n  \${3:// code}\n}',
    description: 'For loop',
  );

  static const forOfLoop = SnippetData(
    prefix: 'forof',
    label: 'for-of loop',
    body: 'for (const \${1:item} of \${2:array}) {\n  \${3:// code}\n}',
    description: 'For-of loop',
  );

  static const forInLoop = SnippetData(
    prefix: 'forin',
    label: 'for-in loop',
    body: 'for (const \${1:key} in \${2:object}) {\n  \${3:// code}\n}',
    description: 'For-in loop',
  );

  static const whileLoop = SnippetData(
    prefix: 'while',
    label: 'while loop',
    body: 'while (\${1:condition}) {\n  \${2:// code}\n}',
    description: 'While loop',
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
        'new Promise((resolve, reject) => {\n  \${1:// async code}\n  resolve(\${2:value});\n});',
    description: 'Promise constructor',
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
        'try {\n  \${1:// code}\n} catch (\${2:error}) {\n  \${3:// error handling}\n}',
    description: 'Try-catch block',
  );

  static const tryCatchFinally = SnippetData(
    prefix: 'tryf',
    label: 'try-catch-finally',
    body:
        'try {\n  \${1:// code}\n} catch (\${2:error}) {\n  \${3:// error handling}\n} finally {\n  \${4:// cleanup}\n}',
    description: 'Try-catch-finally block',
  );

  // ============================================================================
  // ES6+ FEATURES
  // ============================================================================

  static const destructuringArray = SnippetData(
    prefix: 'desa',
    label: 'destructuring array',
    body: 'const [\${1:first}, \${2:second}] = \${3:array};',
    description: 'Array destructuring',
  );

  static const destructuringObject = SnippetData(
    prefix: 'deso',
    label: 'destructuring object',
    body: 'const { \${1:property} } = \${2:object};',
    description: 'Object destructuring',
  );

  static const spreadArray = SnippetData(
    prefix: 'spra',
    label: 'spread array',
    body: '[\${1:...array}]',
    description: 'Array spread operator',
  );

  static const spreadObject = SnippetData(
    prefix: 'spro',
    label: 'spread object',
    body: '{ \${1:...object} }',
    description: 'Object spread operator',
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

  static const importAll = SnippetData(
    prefix: 'impa',
    label: 'import all',
    body: "import * as \${1:name} from '\${2:module}';",
    description: 'Import all as namespace',
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

  static const exportNamedFunction = SnippetData(
    prefix: 'expf',
    label: 'export function',
    body:
        'export function \${1:functionName}(\${2:params}) {\n  \${3:// code}\n}',
    description: 'Export named function',
  );

  static const exportDefaultFunction = SnippetData(
    prefix: 'expdf',
    label: 'export default function',
    body:
        'export default function \${1:functionName}(\${2:params}) {\n  \${3:// code}\n}',
    description: 'Export default function',
  );

  // ============================================================================
  // ARRAY METHODS
  // ============================================================================

  static const arrayMap = SnippetData(
    prefix: 'map',
    label: 'array.map',
    body: '\${1:array}.map((\${2:item}) => \${3:item})',
    description: 'Array map method',
  );

  static const arrayFilter = SnippetData(
    prefix: 'filter',
    label: 'array.filter',
    body: '\${1:array}.filter((\${2:item}) => \${3:condition})',
    description: 'Array filter method',
  );

  static const arrayReduce = SnippetData(
    prefix: 'reduce',
    label: 'array.reduce',
    body:
        '\${1:array}.reduce((\${2:acc}, \${3:item}) => \${4:acc + item}, \${5:0})',
    description: 'Array reduce method',
  );

  static const arrayFind = SnippetData(
    prefix: 'find',
    label: 'array.find',
    body: '\${1:array}.find((\${2:item}) => \${3:condition})',
    description: 'Array find method',
  );

  static const arrayForEach = SnippetData(
    prefix: 'foreach',
    label: 'array.forEach',
    body: '\${1:array}.forEach((\${2:item}) => {\n  \${3:// code}\n});',
    description: 'Array forEach method',
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

  static const consoleTable = SnippetData(
    prefix: 'ct',
    label: 'console.table',
    body: 'console.table(\${1:data});',
    description: 'Console table',
  );

  // ============================================================================
  // COMPLETE SNIPPET LIST
  // ============================================================================

  /// All available JavaScript snippets (42 total).
  static const List<SnippetData> all = [
    // Functions
    function_,
    arrowFunction,
    arrowFunctionSingle,
    asyncFunction,
    asyncArrowFunction,
    // Classes
    classSnippet,
    classWithExtends,
    method,
    asyncMethod,
    getter,
    setter,
    // Control Flow
    ifStatement,
    ifElseStatement,
    ternary,
    forLoop,
    forOfLoop,
    forInLoop,
    whileLoop,
    switchCase,
    // Async/Await
    promise,
    asyncAwait,
    tryCatch,
    tryCatchFinally,
    // ES6+ Features
    destructuringArray,
    destructuringObject,
    spreadArray,
    spreadObject,
    importNamed,
    importDefault,
    importAll,
    exportNamed,
    exportDefault,
    exportNamedFunction,
    exportDefaultFunction,
    // Array Methods
    arrayMap,
    arrayFilter,
    arrayReduce,
    arrayFind,
    arrayForEach,
    // Console
    consoleLog,
    consoleError,
    consoleTable,
  ];
}
