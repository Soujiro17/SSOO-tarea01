#!/bin/bash

uso() { echo "Modo de uso: $0 [-f <Archivo CSV>] [-N <int>]" 1>&2; exit 1; } # Función que muestra los parámetros necesarios para correr el código

############# PARÁMETROS - el código utilizado fue de Adrian Frühwirth. El código se encuentra en el README.md.

while getopts ":f:N:" o; do # Se guardan los parámetros f y N en la variable o, donde se utiliza un case ${0} para verificar los valores de los parámetros
    case "${o}" in
        f)
            f=${OPTARG} # Se guarda el valor de -f en f
            ;;
        N)
            n=${OPTARG} # Se guarda el valor de -N en n
            ;;
        *)
            uso # En caso general de que se quiera ingresar otro parámetro, devolver el método de uso del script.
            ;;
    esac
done
shift $((OPTIND-1)) # Se remueven los parámetros ya utilizados en el getopts

if [ -z "${f}" ] || [ -z "${n}" ]; then # Si alguno de los dos valores está vacío, retornar el método de uso
    uso
fi


############# COMANDO

cat="cat $f"
cut="cut -d ';' -f 2,4,5,6,17,18" # El cut usa el delimitador ';' para obtener los valores de las columnas 2,4,5,6,17,18
sed="sed 1,3d" # Elimina las primeras 3 filas sin ordenar (las "categorias" de cada columna)
sort="LC_ALL=en_US.utf-8 sort -h -k6 -r -t ';'"
# Como el resultado del sort varía según la ubicación local, se utiliza el en_US.utf-8 para establecer el formato de
# ordenamiento del dinero. Como el ejemplo trabajaba con ',', se prefirió esa opción.

command="$cat | $cut | $sed | $sort > ordenados.txt"

eval $command

############# CARGAR ARCHIVO ORDENADO

file='ordenados.txt'

count=1

############# EL ECHO PARA IMPRIMIR LOS DATOS

while IFS=';' read anio marca modelo version tasacion permiso # Se utiliza un delimitador ';' para separar por columna cada valor del archivo. Luego, se formatea.
    do

		echo "============== AUTO $count =============="
		echo "Marca: $marca"
		echo "Modelo: $modelo"
		echo "Versión: $version"
		echo "Año: $anio"
		echo "Tasación: $tasacion"
		echo "Valor Permiso: $permiso"

        (( count!=$n )) || break

        ((count++))


    done < $file

############# ELIMINAR EL ARCHIVO ORDENADO CREADO

rm ordenados.txt -rf

exit;
