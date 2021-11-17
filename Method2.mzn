include "globals.mzn";

int: N = 6;
set of int: POS = 1..N;
set of int: SEEN = 0..N;
set of int: HEIGHT = 1..N;

array[POS] of SEEN: top;
array[POS] of SEEN: bottom;
array[POS] of SEEN: left;
array[POS] of SEEN: right;   

% Create 3 matrix, existence(user input) + filled(middleware) = height(the completed matrix)
array[POS, POS] of int: existence;
array[POS, POS] of var 0..N: filled;
array[POS, POS] of var HEIGHT: height;

constraint forall(i in POS, j in POS)(height[i, j] = filled[i, j] + existence[i, j]);
constraint forall(i in POS, j in POS)(if existence[i, j] != 0 then filled[i, j] = 0 endif);

% For different visible numbers, generate corresponding tables
array[1..120, POS] of HEIGHT: table1;
array[1..274, POS] of HEIGHT: table2;
array[1..225, POS] of HEIGHT: table3;
array[1..85, POS] of HEIGHT: table4;
array[1..15, POS] of HEIGHT: table5;
array[1..1, POS] of HEIGHT: table6;

% For each 4 direction, and for each line, connect the visible number to the corresponding table.
constraint forall(p in POS)(
if top[p] != 0 then 
(if top[p] = 1 then table(col(height, p), table1)
elseif top[p] = 2 then table(col(height, p), table2)
elseif top[p] = 3 then table(col(height, p), table3)
elseif top[p] = 4 then table(col(height, p), table4)
elseif top[p] = 5 then table(col(height, p), table5)
else table(col(height, p), table6)
endif)
endif
);

constraint forall(p in POS)(
if bottom[p] != 0 then 
(if bottom[p] = 1 then table(reverse(col(height, p)), table1)
elseif bottom[p] = 2 then table(reverse(col(height, p)), table2)
elseif bottom[p] = 3 then table(reverse(col(height, p)), table3)
elseif bottom[p] = 4 then table(reverse(col(height, p)), table4)
elseif bottom[p] = 5 then table(reverse(col(height, p)), table5)
else table(reverse(col(height, p)), table6)
endif)
endif
);

constraint forall(p in POS)(
if left[p] != 0 then 
(if left[p] = 1 then table(row(height, p), table1)
elseif left[p] = 2 then table(row(height, p), table2)
elseif left[p] = 3 then table(row(height, p), table3)
elseif left[p] = 4 then table(row(height, p), table4)
elseif left[p] = 5 then table(row(height, p), table5)
else table(row(height, p), table6)
endif)
endif
);

constraint forall(p in POS)(
if right[p] != 0 then 
(if right[p] = 1 then table(reverse(row(height, p)), table1)
elseif right[p] = 2 then table(reverse(row(height, p)), table2)
elseif right[p] = 3 then table(reverse(row(height, p)), table3)
elseif right[p] = 4 then table(reverse(row(height, p)), table4)
elseif right[p] = 5 then table(reverse(row(height, p)), table5)
else table(reverse(row(height, p)), table6)
endif)
endif
);

% All different constraint                    
constraint forall(p in POS)
    (all_different(row(height, p)) /\
     all_different(col(height, p)));

solve satisfy;

output ["height = "] ++ [show2d(height)];
