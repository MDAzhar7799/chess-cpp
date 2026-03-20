# Chess Game - Build Instructions

## Prerequisites

1. **Emscripten SDK** - Required to compile C++ to WebAssembly
   - Download from: https://emscripten.org/docs/getting_started/downloads.html
   - Or install via Git:
     ```bash
     git clone https://github.com/emscripten-core/emsdk.git
     cd emsdk
     emsdk install latest
     emsdk activate latest
     ```

2. **Web Browser** - Any modern browser with WebAssembly support
   - Chrome, Firefox, Safari, Edge (all recent versions)

## Building on Windows

### Option 1: Using build.bat (Recommended)
```cmd
cd chess
build.bat
```

### Option 2: Using PowerShell
```powershell
cd chess\cpp
em++ -std=c++17 -O3 -s WASM=1 -s EXPORT_ES6=0 -s MODULARIZE=0 -s EXPORT_NAME="'Module'" -s ALLOW_MEMORY_GROWTH=1 -s INITIAL_MEMORY=67108864 -s MAXIMUM_MEMORY=268435456 --bind -s NO_EXIT_RUNTIME=1 -s ENVIRONMENT=web chess_engine.cpp ai.cpp bindings.cpp -o ../build/chess.js
```

## Building on Linux/Mac

```bash
cd chess/cpp
make
```

Or manually:
```bash
cd chess/cpp
em++ -std=c++17 -O3 -s WASM=1 --bind -s NO_EXIT_RUNTIME=1 -s ENVIRONMENT=web chess_engine.cpp ai.cpp bindings.cpp -o ../build/chess.js
```

## Running the Game

### Method 1: Direct File Open (Limited)
Simply open `web/index.html` in your browser.
Note: Some browsers may block WASM from file:// protocol.

### Method 2: Local Server (Recommended)
```bash
# Using Python 3
cd chess
python -m http.server 8000

# Using Python 2
cd chess
python -m SimpleHTTPServer 8000

# Using Node.js (if http-server is installed)
cd chess
npx http-server
```

Then open: http://localhost:8000/web/

## Project Structure

```
chess/
├── cpp/                    # C++ source files
│   ├── chess_engine.h      # Chess engine header
│   ├── chess_engine.cpp    # Core chess logic
│   ├── ai.h               # AI header
│   ├── ai.cpp             # Minimax AI implementation
│   ├── bindings.cpp       # Emscripten bindings
│   └── Makefile           # Build configuration
├── web/                   # Frontend files
│   ├── index.html         # Main HTML
│   ├── css/
│   │   └── style.css      # Responsive styles
│   ├── js/
│   │   ├── audio.js       # Sound effects
│   │   ├── board.js       # Board rendering
│   │   └── app.js         # Main application
│   └── assets/
│       └── sounds/        # Sound files (optional)
├── build/                 # Build output
│   ├── chess.js          # Generated JS glue
│   └── chess.wasm        # WebAssembly binary
├── build.bat             # Windows build script
└── BUILD.md              # This file
```

## Features

- **Two Game Modes**: Player vs Player, Player vs AI
- **AI Difficulty**: Easy (depth 2), Medium (depth 4), Hard (depth 6)
- **Responsive Design**: Works on desktop and mobile
- **Sound Effects**: Move, capture, check, win/lose sounds
- **Special Moves**: Castling, en passant, pawn promotion
- **Game State Detection**: Check, checkmate, stalemate

## Troubleshooting

### "em++ not found"
Make sure Emscripten is activated:
```cmd
emsdk activate latest
emsdk_env.bat
```

### "WASM compilation failed"
Check that all C++ files are present and Emscripten is properly installed.

### "Audio not playing"
Browsers require user interaction before playing audio. Click anywhere on the page first.

### "Board not appearing"
Check browser console for errors. Ensure chess.js and chess.wasm are in the build folder.

## Development

### Debug Build
Add debug flags for development:
```bash
em++ ... -g4 -s ASSERTIONS=2 -s SAFE_HEAP=1 ...
```

### Rebuild After Changes
```bash
cd chess/cpp
make clean-all
# or on Windows: del ..\build\chess.js ..\build\chess.wasm
```

## Browser Compatibility

- Chrome 57+
- Firefox 52+
- Safari 11+
- Edge 16+

All modern browsers support WebAssembly.
