@echo off
chcp 65001 >nul
echo ===================================================
echo   PUBLICADOR AUTOMATICO - MAPPO VTT (FabbersRPG)
echo ===================================================
set /p VER="Digite o numero da versao (ex: 1.0.0 ou 1.0.1): "
set /p MSG="Digite as notas da atualizacao (Changelog): "

echo.
echo [1/3] Compactando os arquivos da pasta Build_Do_Jogo...
if exist Mappo_Build.zip del Mappo_Build.zip
powershell -Command "Compress-Archive -Path '.\Build_Do_Jogo\*' -DestinationPath '.\Mappo_Build.zip' -Force"

echo.
echo [2/3] Subindo Mappo_Build.zip para o GitHub Releases (v%VER%)...
gh release create v%VER% .\Mappo_Build.zip --title "Mappo VTT v%VER%" --notes "%MSG%"

echo.
echo [3/3] Atualizando version.json e enviando git push...
(
echo {
echo   "version": "%VER%",
echo   "zipUrl": "https://github.com/FabbersRPG/Mappo-Releases/releases/download/v%VER%/Mappo_Build.zip",
echo   "changelog": "%MSG%"
echo }
) > version.json

git add version.json .gitignore
git commit -m "Atualizacao v%VER%"
git push

if exist Mappo_Build.zip del Mappo_Build.zip
echo.
echo ===================================================
echo   PRONTO! Atualizacao v%VER% publicada com sucesso!
echo ===================================================
pause