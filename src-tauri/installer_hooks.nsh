!macro NSIS_HOOK_POSTINSTALL
  ; Mensaje de depuración
  DetailPrint "Ejecutando hook POSTINSTALL..."

  ; Crear un archivo PowerShell en el directorio temporal
  StrCpy $0 "$TEMP\\create_shortcut.ps1"
  FileOpen $1 $0 w
  FileWrite $1 "Write-Host 'Ejecutando PowerShell post-instalación...'" 
  FileWrite $1 "$\r$\n"
  FileWrite $1 "Start-Sleep -Seconds 1" 
  FileWrite $1 "$\r$\n"
  FileWrite $1 "Write-Host 'Script completado.'" 
  FileClose $1

  ; Obtener la ruta del ejecutable
  StrCpy $2 "$INSTDIR\\NetPort.exe"  ; Ruta del ejecutable

  ; Crear un acceso directo en el escritorio
  StrCpy $3 "$DESKTOP\\NetPort.lnk"
  CreateShortcut "$3" "$2" "NetPort" "$INSTDIR\\icono.ico" "" "" "runas"

  ; Asegurarse de que el acceso directo se ejecute con privilegios elevados
  WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" "EnableLUA" "1"

  ; Ejecutar el script PowerShell con permisos normales (sin credenciales)
  nsExec::Exec 'powershell -ExecutionPolicy Bypass -Command "Start-Process PowerShell -Verb RunAs -ArgumentList ''-ExecutionPolicy Bypass -File \"$0\"''"'

  DetailPrint "Hook POSTINSTALL finalizado."
!macroend
