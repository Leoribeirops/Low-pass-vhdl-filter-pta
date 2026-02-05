@echo off
setlocal enabledelayedexpansion

REM Vai para a pasta onde este .bat está
cd /d "%~dp0"

set /p CONFIRMA=Tem certeza que deseja apagar a cosimulacao? (S/N): 

if /I "%CONFIRMA%"=="S" (
    echo Limpando rastros da cosimulacao...

    REM ================================
    REM Pastas (não mexe em backup_cosim)
    REM ================================
    if exist "slprj"        rmdir /s /q "slprj"
    if exist "work"         rmdir /s /q "work"
    if exist "output_files" rmdir /s /q "output_files"

    REM ================================
    REM Arquivos específicos
    REM ================================
    call :del_safe "compile_and_launch.tcl"
    call :del_safe "compile_project.cr.mti"
    call :del_safe "compile_project.mpf"
    call :del_safe "modelsim.ini"
    call :del_safe "tmw_esl_vsim_launch.bat"
    call :del_safe "*.log"
    call :del_safe "*.slxc"

    REM ================================
    REM Prefixos
    REM ================================
    call :del_safe "compile_hdl_design*"
    call :del_safe "hdlverifier_compile_design*"
    call :del_safe "launch_hdl_simulator*"
    call :del_safe "vsim*"
    call :del_safe "transcript*"
    call :del_safe "logger*"

    echo.
    echo Limpeza concluida com seguranca.
) else (
    echo Operacao cancelada.
)

pause
endlocal
exit /b


REM =====================================================
REM FUNCAO SEGURA: apaga ignorando backup_cosim
REM =====================================================
:del_safe
for /r %%F in (%1) do (
    echo %%F | findstr /i "\\backup_cosim\\" >nul
    if errorlevel 1 (
        del /f /q "%%F" 2>nul
    )
)
exit /b
