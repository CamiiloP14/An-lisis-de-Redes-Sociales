<h1 align="center"> Análisis de Redes Sociales en Adolescentes - Estudio Add Health </h1>

<p align="center">
   <img src="https://img.shields.io/badge/STATUS-EN%20PROCESO-yellow">
   <img src="https://img.shields.io/badge/R-4.3.2-blue">
   <img src="https://img.shields.io/badge/igraph-1.5.1-orange">
</p>

<p align="center">
  <img width="700" src="media/network_visualization.png">
</p>

# Tabla de contenidos
* [Introducción](#introducción)
* [Contexto del estudio](#contexto-del-estudio)
* [Objetivos del análisis](#objetivos-del-análisis)
* [Metodología](#metodología)
* [Resultados clave](#resultados-clave)
* [Tecnologías utilizadas](#tecnologías-utilizadas)
* [Estructura del proyecto](#estructura-del-proyecto)
* [Conclusiones](#conclusiones)

# Introducción
Este proyecto realiza un análisis de redes sociales utilizando datos del estudio longitudinal **Add Health** (National Longitudinal Study of Adolescent to Adult Health), enfocado en entender las dinámicas de amistad y actividades sociales en adolescentes estadounidenses.

# Contexto del estudio
El estudio Add Health recopiló información de más de 20,000 adolescentes entre 1994-1995, con seguimientos hasta 2018. Los datos de redes sociales incluyen:
- Nominaciones de hasta 5 amigos masculinos y 5 femeninos
- Actividades sociales realizadas (visitas, reuniones, llamadas)
- Atributos demográficos (género, raza, escuela)

# Objetivos del análisis
1. Visualizar la estructura de la red social
2. Calcular métricas de centralidad (grado, intermediación)
3. Identificar comunidades dentro de la red
4. Analizar relación entre atributos demográficos y posición en la red

# Metodología
El análisis se desarrolló en 6 etapas principales:

1. **Carga de datos**  
   - Archivos: `taller_edgelist.csv` (conexiones) y `taller_atributos.csv` (características nodos)
   
2. **Creación del objeto de red**  
   - Uso del paquete `igraph` en R
   - Asignación de atributos a nodos

3. **Visualización básica**  
   - Sociograma inicial con diseño ForceAtlas2
   - Colorización por género y escuela

4. **Métricas de centralidad**  
   - Cálculo de grado (degree) y betweenness
   - Densidad de la red

5. **Visualización mejorada**  
   - Tamaño de nodos por grado
   - Color por raza (puntos extra)

6. **Detección de comunidades**  
   - Algoritmo Walktrap
   - Visualización de clusters

# Resultados clave
### Hallazgos principales
- **Red direccional ponderada** con 71 nodos
- **Densidad**: 0.15 (conexiones moderadas)
- **Nodo central**: ID-45 (grado = 28, betweenness = 120.5)
- **3 comunidades principales** identificadas

### Insights
- Los estudiantes de mayor grado pertenecen a la escuela 2
- Las mujeres muestran mayor diversidad en conexiones
- Comunidades reflejan agrupaciones por escuela y actividades

# Tecnologías utilizadas
**Lenguaje y herramientas**  
<img src="https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white">  
<img src="https://img.shields.io/badge/RStudio-75AADB?style=for-the-badge&logo=RStudio&logoColor=white">

**Paquetes principales**
```r
- igraph (análisis de redes)
- ggplot2 (visualizaciones)
- dplyr (manipulación de datos)
