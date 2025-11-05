/// Type-safe enums for Monaco Editor configuration
/// Provides compile-time safety while maintaining backward compatibility
/// Monaco Editor themes
enum MonacoTheme {
  vs('vs', 'Light'),
  vsDark('vs-dark', 'Dark'),
  hcBlack('hc-black', 'High Contrast Dark'),
  hcLight('hc-light', 'High Contrast Light');

  const MonacoTheme(this.id, this.label);

  final String id;
  final String label;

  static MonacoTheme fromId(String? id,
      {MonacoTheme orElse = MonacoTheme.vsDark}) {
    if (id == null) return orElse;
    return MonacoTheme.values.firstWhere(
      (t) => t.id == id,
      orElse: () => orElse,
    );
  }
}

/// Monaco Editor languages
enum MonacoLanguage {
  plaintext('plaintext', 'Plain Text'),
  abap('abap', 'ABAP'),
  apex('apex', 'Apex'),
  azcli('azcli', 'Azure CLI'),
  bat('bat', 'Batch'),
  bicep('bicep', 'Bicep'),
  cameligo('cameligo', 'Cameligo'),
  clojure('clojure', 'Clojure'),
  coffeescript('coffeescript', 'CoffeeScript'),
  c('c', 'C'),
  cpp('cpp', 'C++'),
  csharp('csharp', 'C#'),
  csp('csp', 'CSP'),
  css('css', 'CSS'),
  cypher('cypher', 'Cypher'),
  dart('dart', 'Dart'),
  dockerfile('dockerfile', 'Dockerfile'),
  ecl('ecl', 'ECL'),
  elixir('elixir', 'Elixir'),
  flow9('flow9', 'Flow9'),
  fsharp('fsharp', 'F#'),
  freemarker2('freemarker2', 'Freemarker2'),
  go('go', 'Go'),
  graphql('graphql', 'GraphQL'),
  handlebars('handlebars', 'Handlebars'),
  hcl('hcl', 'HCL'),
  html('html', 'HTML'),
  ini('ini', 'INI'),
  java('java', 'Java'),
  javascript('javascript', 'JavaScript'),
  julia('julia', 'Julia'),
  kotlin('kotlin', 'Kotlin'),
  less('less', 'Less'),
  lexon('lexon', 'Lexon'),
  lua('lua', 'Lua'),
  liquid('liquid', 'Liquid'),
  m3('m3', 'M3'),
  markdown('markdown', 'Markdown'),
  mdx('mdx', 'MDX'),
  mips('mips', 'MIPS'),
  msdax('msdax', 'MSDAX'),
  mysql('mysql', 'MySQL'),
  objectiveC('objective-c', 'Objective-C'),
  pascal('pascal', 'Pascal'),
  pascaligo('pascaligo', 'Pascaligo'),
  perl('perl', 'Perl'),
  pgsql('pgsql', 'PostgreSQL'),
  php('php', 'PHP'),
  pla('pla', 'PLA'),
  postiats('postiats', 'Postiats'),
  powerquery('powerquery', 'Power Query'),
  powershell('powershell', 'PowerShell'),
  proto('proto', 'Protocol Buffers'),
  pug('pug', 'Pug'),
  python('python', 'Python'),
  qsharp('qsharp', 'Q#'),
  r('r', 'R'),
  razor('razor', 'Razor'),
  redis('redis', 'Redis'),
  redshift('redshift', 'Redshift'),
  restructuredtext('restructuredtext', 'reStructuredText'),
  ruby('ruby', 'Ruby'),
  rust('rust', 'Rust'),
  sb('sb', 'Small Basic'),
  scala('scala', 'Scala'),
  scheme('scheme', 'Scheme'),
  scss('scss', 'SCSS'),
  shell('shell', 'Shell Script'),
  sol('sol', 'Solidity'),
  aes('aes', 'AES'),
  sparql('sparql', 'SPARQL'),
  sql('sql', 'SQL'),
  st('st', 'Structured Text'),
  swift('swift', 'Swift'),
  systemverilog('systemverilog', 'SystemVerilog'),
  verilog('verilog', 'Verilog'),
  tcl('tcl', 'Tcl'),
  twig('twig', 'Twig'),
  typescript('typescript', 'TypeScript'),
  typespec('typespec', 'TypeSpec'),
  vb('vb', 'Visual Basic'),
  wgsl('wgsl', 'WGSL'),
  xml('xml', 'XML'),
  yaml('yaml', 'YAML'),
  json('json', 'JSON');

  const MonacoLanguage(this.id, this.label);

  final String id;
  final String label;

  static MonacoLanguage fromId(String? id,
      {MonacoLanguage orElse = MonacoLanguage.markdown}) {
    if (id == null) return orElse;
    return MonacoLanguage.values.firstWhere(
      (l) => l.id == id,
      orElse: () => orElse,
    );
  }
}

/// Cursor blinking animation styles
enum CursorBlinking {
  blink('blink', 'Blink'),
  smooth('smooth', 'Smooth'),
  phase('phase', 'Phase'),
  expand('expand', 'Expand'),
  solid('solid', 'Solid');

  const CursorBlinking(this.id, this.label);

  final String id;
  final String label;

  static CursorBlinking fromId(String? id,
      {CursorBlinking orElse = CursorBlinking.blink}) {
    if (id == null) return orElse;
    return CursorBlinking.values.firstWhere(
      (c) => c.id == id,
      orElse: () => orElse,
    );
  }
}

/// Cursor styles
enum CursorStyle {
  line('line', 'Line'),
  block('block', 'Block'),
  underline('underline', 'Underline'),
  lineThin('line-thin', 'Line Thin'),
  blockOutline('block-outline', 'Block Outline'),
  underlineThin('underline-thin', 'Underline Thin');

  const CursorStyle(this.id, this.label);

  final String id;
  final String label;

  static CursorStyle fromId(String? id,
      {CursorStyle orElse = CursorStyle.line}) {
    if (id == null) return orElse;
    return CursorStyle.values.firstWhere(
      (c) => c.id == id,
      orElse: () => orElse,
    );
  }
}

/// Whitespace rendering options
enum RenderWhitespace {
  none('none', 'None'),
  boundary('boundary', 'Boundary'),
  selection('selection', 'Selection'),
  trailing('trailing', 'Trailing'),
  all('all', 'All');

  const RenderWhitespace(this.id, this.label);

  final String id;
  final String label;

  static RenderWhitespace fromId(String? id,
      {RenderWhitespace orElse = RenderWhitespace.selection}) {
    if (id == null) return orElse;
    return RenderWhitespace.values.firstWhere(
      (r) => r.id == id,
      orElse: () => orElse,
    );
  }
}

/// Auto-closing behavior for brackets and quotes
enum AutoClosingBehavior {
  always('always', 'Always'),
  languageDefined('languageDefined', 'Language Defined'),
  beforeWhitespace('beforeWhitespace', 'Before Whitespace'),
  never('never', 'Never');

  const AutoClosingBehavior(this.id, this.label);

  final String id;
  final String label;

  static AutoClosingBehavior fromId(String? id,
      {AutoClosingBehavior orElse = AutoClosingBehavior.languageDefined}) {
    if (id == null) return orElse;
    return AutoClosingBehavior.values.firstWhere(
      (a) => a.id == id,
      orElse: () => orElse,
    );
  }
}

/// Font family options for Monaco editor
enum MonacoFont {
  cascadiaCodePrimary('Cascadia Code, Fira Code, Consolas, monospace'),
  firaCodePrimary('Fira Code, Consolas, monospace'),
  sfMono('SF Mono, Monaco, monospace'),
  jetBrainsMono('JetBrains Mono, monospace'),
  sourceCodePro('Source Code Pro, monospace'),
  consolas('Consolas, monospace'),
  monaco('Monaco, monospace'),
  menlo('Menlo, monospace'),
  courierNew('Courier New, monospace'),
  monospace('monospace');

  const MonacoFont(this.value);

  final String value;

  /// Get all available font families as strings
  static List<String> get all => MonacoFont.values.map((f) => f.value).toList();
}
