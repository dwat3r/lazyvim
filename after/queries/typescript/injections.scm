; extends

; this.sql`...`, obj.sql<T>`...` — member-expression tagged templates named `sql`
((call_expression
  function: (member_expression property: (property_identifier) @_prop)
  arguments: (template_string) @injection.content)
 (#eq? @_prop "sql")
 (#set! injection.language "sql"))
