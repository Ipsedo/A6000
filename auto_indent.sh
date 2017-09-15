for entry in src/*.ml src/*.mli src/*.mll
do
  ocp-indent "$entry" > tmp
  mv tmp "$entry"
done