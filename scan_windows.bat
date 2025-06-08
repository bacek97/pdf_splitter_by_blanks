@echo off
set "SFX_7ZIP=common\win_soft\win_soft.exe"
@if exist "%SFX_7ZIP%" ("%SFX_7ZIP%" -ocommon -y && del /q "%SFX_7ZIP%")

for /f "tokens=2 delims=:" %%A in ('chcp') do for /f "tokens=*" %%B in ("%%A") do (
    if "%%B" == "1251" (
        common\win_soft\busybox_sh.exe sh -c "CHCP=1251  LC_MESSAGES=ru_RU.CP1251 ./scan_unix.sh"
    ) else if "%%B" == "866" (
        common\win_soft\busybox_sh.exe sh -c "CHCP=866   LC_MESSAGES=ru_RU.CP1251 ./scan_unix.sh"
    ) else (
        common\win_soft\busybox_sh.exe sh -c "CHCP=65001 LC_MESSAGES=ru_RU.UTF-8  ./scan_unix.sh"
    )
)
