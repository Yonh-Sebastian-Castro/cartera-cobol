# Proyecto COBOL - Cartera

Este es un programa escrito en COBOL como parte de una prueba técnica para el cargo de desarrollador en la empresa SIIGO. 
Su propósito es leer dos archivos (`DET.DET` y `NIT.DET`), unir la información por NIT y Sucursal, y generar un listado 
ordenado por fecha de vencimiento descendente, con subtotales por fecha.

## Estructura del proyecto

- `src/Cartera.CBL`: Código fuente COBOL
- `data/DET.DET`: Archivo de movimientos (simulado)
- `data/NIT.DET`: Archivo de clientes (simulado)
- `data/LISTADO.DET`: Resultado generado

## Cómo ejecutar

Este programa puede ejecutarse usando [GnuCOBOL](https://open-cobol.sourceforge.io/) o Micro Focus COBOL. Para compilar y ejecutar en GnuCOBOL:

```bash
cd src
cobc -x Cartera.CBL -o cartera
./cartera
