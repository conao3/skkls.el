# skkls.el

An Emacs client for [skkls](https://github.com/conao3/skkls), bringing SKK-style Japanese input to modern Emacs through the Language Server Protocol.

## Overview

skkls.el integrates with Eglot to provide SKK (Simple Kana to Kanji conversion) functionality via LSP. This approach offers a clean separation between the input method logic and the editor, making it easier to maintain and extend.

## Requirements

- Emacs 29.1 or later
- [skkls](https://github.com/conao3/skkls) server
- Eglot (built into Emacs 29+)

## Installation

### Manual Installation

Clone this repository and add it to your load path:

```elisp
(add-to-list 'load-path "/path/to/skkls.el")
(require 'skkls)
```

### With leaf.el

```elisp
(leaf skkls
  :load-path "/path/to/skkls.el"
  :require t)
```

## Configuration

### Eglot Setup

Register skkls with Eglot for the modes where you want Japanese input:

```elisp
(add-to-list 'eglot-server-programs
             '(text-mode . ("skkls")))
```

### Troubleshooting

If you encounter errors with `track-changes-fetch`, you can apply this workaround:

```elisp
(leaf eglot
  :preface
  (defun my/advice--track-changes-fetch (f &rest args)
    (when (car args)
      (apply f args)))
  :advice (:around track-changes-fetch my/advice--track-changes-fetch))
```

## Usage

Enable the minor mode in any buffer:

```
M-x skkls-mode
```

Once enabled, printable characters are sent to the skkls server for processing. The server handles kana conversion, kanji selection, and other SKK operations.

## How It Works

1. When `skkls-mode` is active, key presses are intercepted
2. Each key is sent to the skkls server via Eglot
3. The server returns actions (insert text, delete characters, etc.)
4. skkls.el executes these actions in the buffer

## License

GPL-3.0-or-later

## Author

Naoya Yamashita ([@conao3](https://github.com/conao3))
