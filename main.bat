@echo off
for /f "tokens=2 delims=:" %%A in ('chcp') do for /f "tokens=*" %%B in ("%%A") do (
    if "%%B" == "1251" (
        repos_win_soft\busybox_sh.exe sh -c "LC_MESSAGES=ru_RU.CP1251 ./main.sh"
    ) else if "%%B" == "866" (
        repos_win_soft\busybox_sh.exe sh -c "LC_MESSAGES=ru_RU.IBM866 ./main.sh"
    ) else (
        repos_win_soft\busybox_sh.exe sh -c "LC_MESSAGES=ru_RU.UTF-8 ./main.sh"
    )
)