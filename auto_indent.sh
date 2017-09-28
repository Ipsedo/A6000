for entry in src/*.ml src/*.mli
do
  ocp-indent "$entry" > tmp
  mv tmp "$entry"
done
