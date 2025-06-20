# Proyecto COBOL - Cartera

Este es un programa escrito en COBOL como parte de una prueba técnica para el cargo de Developer Ssr COBOL en la empresa SIIGO.  
Su propósito es:

- Leer dos archivos (DET.DET y NIT.DET)
- Unir la información por NIT y Sucursal
- Generar un listado ordenado por Fecha de Vencimiento descendente
- Incluir subtotales por Fecha

---

## Estructura del proyecto
cartera-cobol/
data/
  DET.DET - archivo de movimientos
  NIT.DET - archivo de clientes
docs/
  ejemplo-ejecucion.txt - muestra de la salida generada
  demo-ejecucion.png - demostracion de la ejecución y resultado de la ejcución
src/
 bin/
  Cartera.exe - ejecutable principal
  DET.DET - archivo de movimientos
  NIT.DET - archivo de clientes
  LISTADO.DET - archivo generado con el resultado
Cartera.cbl - código fuente COBOL
README.md


## Cómo ejecutar

### Requisitos

- GnuCOBOL (instalado desde OpenCobolIDE o vía Chocolatey) o Micro Focus COBOL
- Archivos "DET.DET" y "NIT.DET" ubicados en la misma carpeta que el ".exe"

### Ejecución rápida

Desde una terminal (CMD o PowerShell):

bash
cd src\bin
.\Cartera.exe

Ejemplo de salida
Consulta el archivo docs/ejemplo-ejecucion.txt para ver un ejemplo del archivo generado por el programa.

Autor
Yonh Sebastian Pinzon Castro
jhon.sebas997@gmail.com