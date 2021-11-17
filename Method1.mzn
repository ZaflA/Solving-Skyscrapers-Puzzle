include "globals.mzn";

int: N = 6;
set of int: POS = 1..N;
set of int: SEEN = 0..N;
set of int: HEIGHT = 1..N;
set of int: EXIST = 0..1;

array[POS] of SEEN: top;
array[POS] of SEEN: bottom;
array[POS] of SEEN: left;
array[POS] of SEEN: right;  

array[POS, POS] of var EXIST: top_visible;
array[POS, POS] of var EXIST: bottom_visible;
array[POS, POS] of var EXIST: left_visible;
array[POS, POS] of var EXIST: right_visible;

% Create 3 matrix, exist(user input) + fill(middleware) = height(the completed matrix)
array[POS, POS] of int: existence;
array[POS, POS] of var 0..N: filled;
array[POS, POS] of var HEIGHT: height;

constraint forall(i in POS, j in POS)(height[i, j] = filled[i, j] + existence[i, j]);
constraint forall(i in POS, j in POS)(if existence[i, j] != 0 then filled[i, j] = 0 endif);

% For each 4 direction, create a 'visable' matrix and fill the matrix.
constraint forall(p in POS)(
if top[p] != 0 then forall(j in POS)(
if j=1 then top_visible[p,j] = 1 elseif (max([col(height,p)[o] | o in 1..j-1]) < col(height,p)[j]) then top_visible[p,j] = 1 
else top_visible[p,j] = 0 
endif
)endif
);

constraint forall(p in POS)(
if bottom[p] != 0 then forall(j in POS)(
if j=1 then bottom_visible[p,j] = 1 elseif (max([reverse(col(height,p))[o] | o in 1..j-1]) < reverse(col(height,p))[j]) then bottom_visible[p,j] = 1 
else bottom_visible[p,j] = 0 
endif
)endif
);

constraint forall(p in POS)(
if left[p] != 0 then forall(j in POS)(
if j=1 then left_visible[p,j] = 1 elseif (max([row(height,p)[o] | o in 1..j-1]) < row(height,p)[j]) then left_visible[p,j] = 1 
else left_visible[p,j] = 0 
endif
)endif
);

constraint forall(p in POS)(
if right[p] != 0 then forall(j in POS)(
if j=1 then right_visible[p,j] = 1 elseif (max([reverse(row(height,p))[o] | o in 1..j-1]) < reverse(row(height,p))[j]) then right_visible[p,j] = 1 
else right_visible[p,j] = 0 
endif
)endif
);


% Constrain each 'visables' equal to the clue.
constraint forall(i in POS)(
sum(x in POS)(row(top_visible,i)[x] == 1) == top[i]);
constraint forall(i in POS)(
sum(x in POS)(row(bottom_visible,i)[x] == 1) == bottom[i]);
constraint forall(i in POS)(
sum(x in POS)(row(left_visible,i)[x] == 1) == left[i]);
constraint forall(i in POS)(
sum(x in POS)(row(right_visible,i)[x] == 1) == right[i]);


%constraint forall(p in POS)
%(if top[p] != 0 then (forall(j in POS)
%(if j=1 then top_visable[p,j] = 1 elseif (max([top_height[p,o] | o in 1..j-1]) < top_height[p,j]) then top_visable[p,j] = 1 
%else top_visable[p,j] = 0 endif)) 
%/\ sum(j in POS)(top_visable[j,p]) = top[p]
%endif);
     
constraint forall(p in POS)
    (all_different(row(height, p)) /\
     all_different(col(height, p)));

%constraint forall(i in POS, j in POS)(top_height[i,j] = bottom_height[N+1-i,j]);
%constraint forall(i in POS, j in POS)(left_visable[i,j] = right_visable[N+1-i,j]);
%constraint forall(i in POS, j in POS)(top_visable[i,j] = left_visable[j,i]);

solve satisfy;

output ["height = "] ++ [show2d(height)];
