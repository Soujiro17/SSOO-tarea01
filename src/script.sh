
echo "Nombre del script: $0"
echo "PID del proceso: $$"

echo "Argumentos: "
for var in "$*"
	do
		echo $var
	done

echo "Primeras diez lineas de /proc/$$/status"
head --lines=10 /proc/$$/status

exit
