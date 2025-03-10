## Proyecto de Análisis de Redes Sociales


#---------------------------------------------#
# Trabajo realizado por:
# Camilo Pedreros
#---------------------------------------------#
"
El presente taller utilizará datos de redes sociales del estudio 
Add Health (National Longitudinal Study of Adolescent to Adult Health ), 
uno de los estudios longitudinales más grandes y complejos que se ha llevado a cabo. 
Este estudio se basa en una muestra representativa nacional de más de 20.000 adolescentes 
de los EE. UU. mientras éstos cursaban los grados 7-12 del colegio durante los años 1994-95. 
El estudio ha hecho cinco seguimientos a los participantes, el más reciente en 2016-18.
"

#Teniendo en cuenta el contexto del estudio,la red social que se usara
#consiste en una red direccionada de 71 x 71 ponderada . Se deben utilizar los siguientes archivos:

# 	taller_edgelist.csv
# taller_atributos.csv

#Paso 1. Cargar los archivos.

#Cargamos el archivo edgelist
edgelist <- read.csv(file = "C:/Users/USUARIO/Documents/trabajo r studio/Trabajo final/taller_edgelist.csv")
head(edgelist,6)

#Verificamos el tipo del archivo

class(edgelist)

#Cargamos el archivo edgelist

atributos <- read.csv(file = "C:/Users/USUARIO/Documents/trabajo r studio/Trabajo final/taller_atributos.csv")
head(atributos,6)

#Verificamos el tipo del archivo

class(atributos)

##Los atributos se codificaron así: “gender” (1=hombre; 2=mujer); “race” (1=blanco; 3=asiático; 5=negro)

#PASO 2.

#2 Cree un objeto de red y cargue los atributos.
#Aquí es donde se debe crear un objeto de red para poder crear visualizaciones y hacer cálculos de métricas.

# cargamos la libreria igraph 

library(igraph)

# (1) Creamos una red usando un edgelist con igraph
# creamos un objeto igraph

class_red_edgelist <- graph_from_data_frame(d = edgelist, directed = T)
class_red_edgelist

# ahora agregamos los atributos

class_red_edgelist <- graph_from_data_frame(d = edgelist, directed = T,
                                            vertices = atributos)
class_red_edgelist


#PASO 3

#3. Cree una primera visualización de la red.
#Seguidamente, haga mejoras al sociograma resaltando, por ejemplo, atributos con colores. 
#Interprete la visualización preliminar, valorando las características observables.



#Hacemos una visualizacion basica con igraph

library(igraph)
class_net <- graph_from_data_frame(d = edgelist, directed = T, 
                                   vertices = atributos) # creamos objeto igraph
plot(class_net) 

# mejoramos la visualización

cols <- ifelse(atributos$gender == 2, "#FF82AB", "#548B54") 
table(cols, atributos$gender) # verificamos
V(class_net)$color <- cols # cambiamos colores
# (grado--degree)
indeg <- degree(class_net, mode = "in")
plot(class_net, vertex.size = indeg + 3, vertex.label = NA, 
     vertex.frame.color = NA, edge.arrow.size = .5, edge.arrow.width = .75, 
     edge.color = "light gray", layout = layout_with_kk, margin = -.10) # layout Kamada-Kawai



# Ahora visualizamos con ggplot para ver mejor las conexiones entre nodos

detach(package:igraph)
library(network)
library(intergraph)
library(ggplot2)
library(GGally)


class_net_sna <- asNetwork(class_net) # creamos objeto de red

set.vertex.attribute(class_net_sna, attrname = "indeg", value = indeg) # agregamos indegree

ggnet2(class_net_sna) # graficamos


ggnet2(class_net_sna,  node.size = indeg,  node.color = "gender",
       palette = c("2" = "#FF82AB", "1" = "#548B54"),
       edge.size = .5, arrow.size = 3, arrow.gap = 0.02, 
       edge.color = "grey60")+
  guides(size = "none", color = guide_legend(override.aes = list(size = 8))) +# resaltamos el tamaño de los colores de la leyenda
  scale_color_manual(values = c("2" = "#FF82AB", "1" = "#548B54"), 
      labels = c("1" = "Hombre", "2" = "Mujer")) +  # Mejoramos las etiquetas de género
  labs(color = "Género", title = "Red Social de Amigos por Género")+  # Personalizamos el título de la leyenda
theme(  plot.title = element_text(hjust = 0.5)) #ajustamos el título al centro

# Interpretacion preeliminar de la red

'
En el sociograma, se puede notar que los nodos femeninos (en rosa) tienden a estar más conectados entre sí,
lo que sugiere que las mujeres forman una red de amigas más sólida en comparación con las conexiones entre hombres (en verde).
Esto podría reflejar una dinámica de género donde las mujeres tienden a construir amistades más cercanas.
Además, varios de los nodos rosados son de mayor tamaño, lo que indica que estas estudiantes tienen muchas conexiones,
colocándolas en el centro de la red y posiblemente ejerciendo influencia entre sus compañeros. 
Finalmente, destaca un nodo rosa con múltiples flechas unidireccionales hacia él, 
lo que podría señalar que esta persona es muy popular o considerada importante por los demás, 
aunque no necesariamente sienta la misma cercanía hacia ellos.

'

#PASO 4.
#Ahora, calcule las siguientes métricas de centralidad: grado (degree) e intermediación (betweenness).
#Calcule también la densidad de la red.
#Aquí, calcule tanto el grado para cada nodo como el grado promedio de la red.
#Interprete los resultados. ¿Qué significan estos resultados de la red social?


### Análisis de Centralidad y Medidas de Red ####

#### Grado #####
library(igraph)

class_net <- graph_from_data_frame(d = edgelist, directed = T, 
                                   vertices = atributos)

# 1. Calcular el grado (degree) de cada nodo
centralidad_grado <- degree(class_net, mode = "all") # Calcula tanto entradas como salidas (para redes dirigidas)
print("Centralidad de grado:")
centralidad_grado

# Grado promedio de la red
grado_promedio <- mean(centralidad_grado)
print("Centralidad promedio de grado:")
grado_promedio

# 2. Calcular la intermediación (betweenness) de cada nodo
centralidad_intermediacion <- betweenness(class_net, directed = TRUE, normalized = TRUE)  # Intermediación en redes dirigidas
print("Centralidad de Intermediación:")
centralidad_intermediacion

# 3. Calcular la densidad de la red
densidad <- edge_density(class_net, loops = FALSE)  # No contamos los loops (autoconexiones)
print(paste("Densidad de la red:", densidad))


# Para visualizar los resultados en conjunto:
# Creas un dataframe con las métricas de cada nodo
metricas_nodos <- data.frame(
  Nodo = V(class_net)$name,
  Grado = centralidad_grado,
  Intermediacion = centralidad_intermediacion)

# Imprimimos el dataframe con las métricas de los nodos
print(metricas_nodos)

"
CONCLUSIONES:

1. Centralidad de grado.

La centralidad de grado mide cuántas conexiones directas tiene cada nodo.
Un valor alto indica que un nodo está muy conectado y, por lo tanto, es probable que sea importante o influyente en la red.

Resultados: Los valores varían desde 0 hasta 22. Los nodos con los grados más altos tienen 15, 19, y 22 conexiones.
Estos nodos actúan como centros de actividad dentro de la red, ya que tienen muchas conexiones directas con otros nodos. 
Por otro lado, algunos nodos tienen grado 0, lo que significa que no tienen conexiones directas.

Grado promedio: El grado promedio de 8.59 indica que, en promedio, cada nodo tiene alrededor de 8 conexiones directas 
en la red. Esto nos da una idea general de cuán conectada está la red.

2.Centralidad de intermediación.

La centralidad de intermediación mide cuántos caminos más cortos pasan a través de un nodo.
Un nodo con alta intermediación puede actuar como <<puente>> entre diferentes partes de la red,
controlando el flujo de información.

Resultados: Los valores varían desde 0 hasta 0.347. Nodos con valores altos como 0.347, 0.278 y 0.243 
tienen una gran influencia en la red al actuar como intermediarios entre otros nodos. 
Estos nodos probablemente juegan un papel clave en la facilitación del flujo de información.

3. . Densidad de la Red:
La densidad de la red mide cuán conectados están los nodos en relación con todas las conexiones posibles.
Un valor de densidad cercano a 1 indicaría que la mayoría de los nodos están conectados entre sí, 
mientras que un valor cercano a 0 indicaría que pocos nodos están conectados.

Densidad: El valor de densidad de 0.061 indica una red poco densa, 
lo que sugiere que solo una pequeña parte de las conexiones posibles entre los nodos está presente. 
Esto podría significar que la red está formada por subgrupos o comunidades con muchas conexiones dentro de ellas 
pero pocas entre los diferentes grupos.

CONCLUSION GENERAL.

La red tiene una baja densidad, lo que sugiere que no todos los nodos están interconectados. 
Sin embargo, hay ciertos nodos con alta centralidad de grado e intermediación, 
lo que implica que estos nodos son muy influyentes dentro de la red. Los nodos con alta intermediación
controlan un flujo de información importante entre diferentes partes de la red, mientras que los nodos 
con alto grado de centralidad probablemente tengan una gran visibilidad o popularidad.

"
#5. Cree una segunda visualización mejorada de la red.
#Ahora, cree otra visualización de la red en donde haga énfasis en el grado de los nodos. 
#Visualice los diferentes valores de grado en la red. Utilice un color diferente para visualizar el atributo de “género”. 
#Interprete nuevamente la visualización, esta vez valorando las características observables con las mejoras y características resaltadas.

# Cargar librerías necesarias
library(igraph)
library(ggplot2)
library(GGally)
library(intergraph)

# Calculamos el grado de cada nodo
grado <- degree(class_net, mode = "all")

# Convertimos la red a formato compatible con ggnet2
class_net_sna <- asNetwork(class_net)

# Agregamos IDs de los nodos
# Los identificadores de los nodos están en 'atributos$id'
node_ids <- atributos$id

# Visualización con ggnet2, mostrando ID en el centro y grado al lado
ggnet2(class_net_sna, 
       node.size = grado+3,  # Tamaño ajustado por grado
       node.color = atributos$gender,  # Usamos el atributo de género
       #node.label = node_ids,  # Mostrar IDs en el centro de los nodos
       node.label.size = 2,  # Ajustar tamaño de la etiqueta del ID
       palette = c("2" = "#607B8B", "1" = "#B0C4DE"),  # Colores para género
       edge.size = 0.5, edge.color = "grey80", 
       arrow.size = 3, arrow.gap = 0.02) +
  guides(size = "none", color = guide_legend(override.aes = list(size = 8))) +# resaltamos el tamaño de los colores de la leyenda
  scale_color_manual(values = c("2" = "#607B8B", "1" = "#B0C4DE"), 
                     labels = c("1" = "Hombre", "2" = "Mujer")) +  # Mejoramos las etiquetas de género
  labs(color = "Género", title = "Red Social de Amigos por Género")+  # Personalizamos el título de la leyenda
  theme(  plot.title = element_text(hjust = 0.5))+ #ajustamos el título al centro
  geom_text(aes(label = grado), vjust = 1.5, hjust=-0.5, size = 2.5, color="navy")+  # Mostrar el grado debajo de los nodos
  geom_text(aes(label = node_ids), color = "black", size = 3.5)+
  # Añadir leyenda explicativa personalizada
  annotate("text", x = Inf, y = -Inf, label = "Interpretación:\n- Número en el nodo: Identificador del nodo\n-
           Tamaño del nodo: Mayor valor de la medida\n- Valor debajo del nodo: Medida exacta\n- Dirección de la flecha: Sentido de la relación", 
           hjust = 1, vjust = 0, color = "black", size = 4, fontface = "italic") +
  theme(legend.position = "right",  # Mueve la leyenda a la derecha
        legend.justification = "top",plot.margin = margin(1, 6, 2, 1, "cm"))  # Aumentamos el margen para dejar espacio a la leyenda


"INTERPRETACIONES
El gráfico presenta un análisis claro de la red social basado en el grado de los nodos, el género y la posición de cada nodo.
El tamaño de cada nodo refleja su grado, donde los nodos más grandes representan a personas con más conexiones, 
mientras que los nodos más pequeños tienen menos. En cuanto al género, los nodos color azul oscuro representan a mujeres 
y los nodos en azul claro representan a hombres.
Esta visualización de colores, junto con el tamaño de los nodos, permite observar si hay alguna diferencia significativa
entre los géneros en términos de centralidad o popularidad. Además, se puede notar cómo ciertos nodos están mejor
conectados dentro de la red; los nodos centrales tienden a ser los más influyentes y conectados, 
lo que nos hace pensar en la importancia de su posición en la dinámica social general.
"
#6. Realice un análisis de detección de comunidades (grupos).
#Por último, utilice el método “walktrap” para detectar comunidades o grupos en la red. 
#Este punto debe tener como resultado la visualización de las comunidades.
#Interprete los resultados. ¿Qué significan éstos resultados de la red social?

# Cargar librerías necesarias
library(igraph)
library(ggplot2)
library(GGally)
library(intergraph)

# Crear el objeto igraph usando la lista de aristas y atributos de nodos

comunidad <- graph_from_data_frame(d=edgelist, directed = TRUE, vertices = atributos)

# Visualización básica de la red sin etiquetas

plot(comunidad, vertex.label=NA, vertex.size=10,
     edge.arrow.size=25, edge.arrow.width=1,
     edge.color="light gray", vertex.frame.color=NA)

# Calcular la densidad de la red

edge_density(comunidad) # Proporción de posibles conexiones que realmente existen

# Calcular componentes débiles (conexiones indirectas)

componentes <- components(graph = comunidad, mode = "weak")
componentes # Identifica componentes (conexiones)

# Proporción del tamaño de cada componente respecto al total

componentes$csize / sum(componentes$csize)

# Detectar bicomponentes (partes que siguen conectadas al eliminar un nodo)

bicomponentes <- biconnected_components(graph = comunidad)
bicomponentes

# Crear versión no dirigida para calcular caminos disjuntos (sin compartir nodos)

vertex_bicomponentes <- as.undirected(comunidad, mode = "collapse")
vertex_disjoint_paths(graph = vertex_bicomponentes, source = 1, target = 9)

# Conectividad: nodos mínimos para desconectar la red

vertex_connectivity(graph = comunidad)

# Remover nodos aislados (con grado 0)

isolates <- which(degree(vertex_bicomponentes) == 0)
red_noisolates <- delete_vertices(vertex_bicomponentes, isolates)
vertex_connectivity(graph = red_noisolates) # Red sin nodos aislados

# Detectar comunidades con método Walktrap, usando 4 pasos

gruposwt_4 <- cluster_walktrap(graph = vertex_bicomponentes, steps = 4, membership = TRUE)
mems_wt_4 <- membership(gruposwt_4) # Asigna nodos a sus comunidades
mod_wt_4 <- modularity(gruposwt_4) # Modularidad (calidad) de comunidades

# Detectar comunidades con Walktrap en 2 pasos

gruposwt_2 <- cluster_walktrap(graph = vertex_bicomponentes, steps = 2, membership = TRUE)
mems_wt_2 <- membership(gruposwt_2)
mod_wt_2 <- modularity(gruposwt_2)

# Visualización de comunidades con 4 y 2 pasos

par(mfrow = c(1, 2)) # Configurar para mostrar dos gráficos juntos
layout <- layout.fruchterman.reingold(comunidad) # Posición de nodos en el gráfico

# Gráfico para Walktrap con 4 pasos
plot(vertex_bicomponentes, layout = layout,
     vertex.color = mems_wt_4, edge.color = "light gray",
     vertex.size = 20, main = "Walktrap: 4 steps")

# Gráfico para Walktrap con 2 pasos
plot(vertex_bicomponentes, layout = layout,
     vertex.color = mems_wt_2, edge.color = "light gray",
     vertex.size = 20, main = "Walktrap: 2 steps")


"
ANÁLISIS 

Los análisis realizados sugieren que la red social tiene una estructura de baja densidad y alta vulnerabilidad, 
lo que implica que contiene subgrupos o comunidades que se mantienen conectados a través de unos pocos nodos o <<puentes>>
críticos. Esto significa que ciertos nodos son clave para mantener la cohesión de la red, y resulta fundamental identificar 
estos nodos de influencia, así como comprender cómo podría fragmentarse la red si algunos de ellos se desconectaran.

En la visualización correspondiente a 4 pasos, se observan 7 comunidades, de las cuales 5 son de gran tamaño, 
mientras que las otras 2 están desconectadas y consisten en un solo nodo cada una.
Por otro lado, al analizar el gráfico de 3 pasos, se identifican alrededor de 8 comunidades,
de las cuales 5 también son de gran tamaño. Sin embargo, entre las otras 3, dos se encuentran aisladas y consisten 
en un solo nodo, mientras que la última comprende solo dos nodos.

CONCLUSIÓN

Estos datos obtenidos reflejan la complejidad y la estructura de la red social analizada. 
La presencia de múltiples comunidades, así como la identificación de nodos críticos, 
son elementos clave para entender la dinámica de interacción y el potencial impacto de la desconexión de ciertos nodos
en la cohesión general de la red.
"
