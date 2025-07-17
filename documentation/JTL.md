# 🧩 JetLeaf TemplateEngine

JetLeaf’s powerful and lightweight HTML templating engine — built exclusively for the JetLeaf backend framework.  
It uses **JTL** (JetLeaf Template Language), a Mustache-style syntax for writing dynamic HTML with variables, loops, conditionals, and partial includes.

> JTL is designed for seamless server-side rendering in Dart using pure HTML templates with logic annotations.

---

## 💡 What is JTL?

**JTL (JetLeaf Template Language)** is a markup syntax built into JetLeaf.  
It combines expressive logic (e.g., loops, conditionals, includes) with readable HTML, making it ideal for building dynamic views.

JTL templates are typically `.html` files processed at runtime.  
They support rich rendering features without mixing Dart code into HTML.

---

## ✨ Features

- 🧠 **Logic-aware templates** using `{{}}` syntax
- 🔁 **Loops** (`{{#each items}} ... {{/each}}`)
- ❓ **Conditionals** (`{{#if condition}} ... {{/if}}`)
- 📦 **Includes** (`{{> partial}}`)
- 🧬 **Nested Properties** (e.g., `{{user.address.city}}`)
- ⚡ **Runtime caching** for speed
- 🛡️ **Safe auto-escaping** (XSS prevention)

---

## 🔤 JTL Syntax Reference

| Feature       | Syntax Example                                        |
|---------------|-------------------------------------------------------|
| Variable      | `{{user.name}}`                                       |
| If block      | `{{#if isAdmin}}Welcome Admin{{/if}}`                 |
| Each block    | `{{#each users}}<li>{{this}}</li>{{/each}}`          |
| Include       | `{{> header}}`                                        |

---

## 🚀 Getting Started

### 1. Add a JTL HTML Template

Create `resources/html/user-profile.html`:

```html
<h1>Hello, {{user.name}}</h1>
<p>Email: {{user.email}}</p>

{{#if isAdmin}}
  <div class="admin-box">You have admin privileges</div>
{{/if}}

<ul>
  {{#each user.tags}}
    <li>{{this}}</li>
  {{/each}}
</ul>

{{> footer}}
```

---

### 2. Render it with Dart

```dart
import 'package:jetleaf/jtl.dart';

void main() async {
  final engine = JtlTemplateEngine(baseDirectory: 'resources/html');

  final output = await engine.render('user-profile', {
    'user': {
      'name': 'Alice',
      'email': 'alice@example.com',
      'tags': ['admin', 'active']
    },
    'isAdmin': true
  });

  print(output);
}
```

---

## 🧠 Advanced JTL Features

### 🔄 Nested Variables

```html
<p>{{user.profile.contact.phone}}</p>
```

### 🔁 Loop Helpers

Inside a `{{#each}}` block:

| Helper       | Description           |
| ------------ | --------------------- |
| `{{this}}`   | Current item          |
| `{{@index}}` | Index of item         |
| `{{@first}}` | True if first in loop |
| `{{@last}}`  | True if last in loop  |

---

### 📦 Template Includes

JTL supports modular templates via `{{> partial}}`:

```html
{{> header}}   <!-- Loads header.html -->
{{> footer}}   <!-- Loads footer.html -->
```

Includes are resolved relative to your base directory.

---

## 🧼 HTML Escaping

By default, all variables are escaped to prevent XSS:

| Character | Escaped As |
| --------- | ---------- |
| `&`       | `&amp;`    |
| `<`       | `&lt;`     |
| `>`       | `&gt;`     |
| `"`       | `&quot;`   |
| `'`       | `&#x27;`   |

> Support for unescaped HTML (`{{{ rawHtml }}}`) is planned.

---

## ⚙️ How It Works (JTL Lifecycle)

1. Loads the template from `baseDirectory`
2. Resolves `{{> includes}}`
3. Evaluates:

   * `{{#if}}`, `{{#each}}`
   * `{{@index}}`, `{{this}}`, etc.
   * Variable interpolation like `{{user.name}}`
4. Merges final HTML output

---

## 🚀 Caching

Templates are compiled and cached at runtime.

* To disable caching:

```dart
TemplateEngine(baseDirectory: 'resources/html', enableCaching: false);
```

* To manually clear:

```dart
engine.clearCache();
```

---

## 📁 Recommended Structure

```
project_root/
├── resources/
│   └── html/
│       ├── user-profile.html
│       ├── header.html
│       ├── footer.html
│       └── error/
│           ├── 404.html
│           ├── 500.html
│           └── home.html
```

---

## 🔒 Notes on Production

* Your JetLeaf engine should include a **JTL runtime loader** (like `JtlAssetBundle`) to resolve default templates embedded inside the framework, even when users deploy via pub.dev.
* For custom project templates, `baseDirectory` should point to a local folder.

---

## 📄 License

MIT License © JetLeaf Framework Authors