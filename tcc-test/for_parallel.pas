program forParallel(input, output);
var B, C, A: integer[10000000];
	i: integer;
begin
	create_threads th:= 2 do
	var desloc: integer;
	for_parallel ii:= threadId to 10000000 step th
	begin
		A[ii] := 0;
		B[ii] := ii + 1;
		C[ii] := ii + 1;
	end;

	create_threads th:= 2 do
	var desloc: integer;
	for_parallel ii:= threadId to 10000000 step th
	begin
		A[ii] := B[ii] + C[ii];
	end;

	// i := 0;
	// while i < 10000000 do
	// begin
	// 	A[i] := 0;
	// 	B[i] := i + 1;
	// 	C[i] := i + 1;
	// 	i := i + 1;
	// end;

	// i := 0;
	// while i < 10000000 do
	// begin
	// 	A[i] := B[i] + C[i];
	// 	i := i + 1;
	// end;
end.