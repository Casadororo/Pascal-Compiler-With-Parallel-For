program forParallel(input, output);
var A, B, C: integer[8];
	i: integer;
begin
	while i < 8 do
	begin
		A[i] := 0;
		B[i] := i + 1;
		C[i] := i + 1;
		i := i + 1;
	end;

	create_threads th:= 4 do
	var desloc: integer;
	for_parallel ii:= threadId to 8 step th
	begin
		A[ii] := B[ii] + C[ii];
	end;
end.