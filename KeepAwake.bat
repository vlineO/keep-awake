@echo off
chcp 65001 >nul 2>&1
title KeepAwake - PC 잠금 방지

:: ============================================================
:: KeepAwake.bat - Windows PC 잠금 방지 스크립트 (BAT 버전)
:: ============================================================
:: 사용법: 더블클릭 또는 CMD에서 실행
:: 중지:  창을 닫거나 Ctrl+C
:: ============================================================

:: --- 설정 ---
set INTERVAL=240

:: --- VBScript 헬퍼 생성 (마우스/키보드 시뮬레이션) ---
set "VBS_FILE=%TEMP%\keepawake_helper.vbs"

(
echo Set WshShell = CreateObject^("WScript.Shell"^)
echo Set objShell = CreateObject^("Shell.Application"^)
echo ' ScrollLock 눌렀다 떼기 ^(작업에 영향 없음^)
echo WshShell.SendKeys "{SCROLLLOCK}"
echo WScript.Sleep 100
echo WshShell.SendKeys "{SCROLLLOCK}"
) > "%VBS_FILE%"

:: --- PowerShell 마우스 이동 헬퍼 생성 ---
set "PS_MOUSE=%TEMP%\keepawake_mouse.ps1"

(
echo Add-Type @"
echo using System;
echo using System.Runtime.InteropServices;
echo public class M {
echo     [DllImport^("user32.dll"^)]
echo     public static extern void mouse_event^(int f, int x, int y, int d, IntPtr e^);
echo     public static void J^(^) {
echo         mouse_event^(1, 1, 0, 0, IntPtr.Zero^);
echo         System.Threading.Thread.Sleep^(100^);
echo         mouse_event^(1, -1, 0, 0, IntPtr.Zero^);
echo     }
echo }
echo "@
echo [M]::J^(^)
) > "%PS_MOUSE%"

:: --- 메인 루프 ---
echo.
echo ============================================
echo   KeepAwake - PC 잠금 방지 스크립트 실행 중
echo ============================================
echo.
echo   간격: %INTERVAL%초
echo   중지: 창을 닫거나 Ctrl+C
echo.
echo -------------------------------------------

set /a COUNT=0

:LOOP
set /a COUNT+=1

:: 현재 시간 가져오기
for /f "tokens=1-2 delims= " %%a in ('echo %date% %time%') do set TIMESTAMP=%%a %%b

:: 마우스 미세 이동 (PowerShell 경유)
powershell -ExecutionPolicy Bypass -File "%PS_MOUSE%" >nul 2>&1

:: 키보드 입력 시뮬레이션 (VBScript 경유)
cscript //nologo "%VBS_FILE%" >nul 2>&1

echo [%TIMESTAMP%] #%COUNT% - 활동 시뮬레이션 완료 (마우스 + 키보드)

:: 대기
timeout /t %INTERVAL% /nobreak >nul

goto LOOP
