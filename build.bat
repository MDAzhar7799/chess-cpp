@echo off
echo Building Chess Game WebAssembly Module...
echo.

REM Check if em++ is available
where em++ >nul 2>nul
if %errorlevel% neq 0 (
    echo Error: Emscripten not found!
    echo Please install Emscripten and activate it:
    echo   1. Install: https://emscripten.org/docs/getting_started/downloads.html
    echo   2. Run: emsdk activate latest
    echo   3. Run: emsdk_env.bat
    exit /b 1
)

REM Create build directory if not exists
if not exist "build" mkdir build

REM Compile to WebAssembly
echo Compiling C++ to WebAssembly...
em++ -std=c++17 -O3 ^
    -s WASM=1 ^
    -s EXPORT_ES6=0 ^
    -s MODULARIZE=0 ^
    -s EXPORT_NAME="'Module'" ^
    -s ALLOW_MEMORY_GROWTH=1 ^
    -s INITIAL_MEMORY=67108864 ^
    -s MAXIMUM_MEMORY=268435456 ^
    -s EXPORTED_RUNTIME_METHODS="['ccall', 'cwrap']" ^
    --bind ^
    -s NO_EXIT_RUNTIME=1 ^
    -s ENVIRONMENT=web ^
    cpp/chess_engine.cpp ^
    cpp/ai.cpp ^
    cpp/bindings.cpp ^
    -o build/chess.js

if %errorlevel% neq 0 (
    echo.
    echo Build failed!
    exit /b 1
)

echo.
echo Build successful!
echo Output: build/chess.js and build/chess.wasm
echo.
echo To run the game:
echo   1. Open web/index.html in a web browser
echo   2. Or serve with a local server: python -m http.server 8000
echo.
pause
