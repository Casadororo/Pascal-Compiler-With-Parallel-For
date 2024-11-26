program forParallel(input, output);
var i, y: integer;
    A,B,C: integer[100];
begin
  i:=0;

  create_threads th: 4 do
	var desloc: integer;
  for_thread ii:= 1 to 100 step th
  begin 
    A[ii] = B[ii] + C[ii];
    ---- Compilador
    ii += 4
    if ii < _for_parallel_to_var
    ----
  end;
  
  write(i);
end.
