" ==========================================
"  MOTOR DE CREACIÓN DE PROYECTOS JAVA
" ==========================================
" 1. Definimos el comando para que Nvim lo reconozca
command! -nargs=1 JavaNuevo call CreateJavaProject(<f-args>)

" 2. La función que ejecuta Maven en la terminal
function! CreateJavaProject(name)
  " Prepara el comando de Maven
  let l:cmd = 'mvn archetype:generate -DgroupId=prueba -DartifactId=' . a:name . ' -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false'
  
  " Ejecuta el comando usando ToggleTerm
  execute 'TermExec cmd="' . l:cmd . '"'
  
  echo "Creando proyecto Java: " . a:name . "..."
endfunction





