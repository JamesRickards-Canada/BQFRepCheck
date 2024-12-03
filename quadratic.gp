print("\n\nType '?quadratic' for help.\n\n");
parigp_version = version();
quad_library = strprintf("./libquad-%d-%d-%d.so", parigp_version[1], parigp_version[2], parigp_version[3]);

/*quadratic.c*/
  addhelp(quadratic,"Discriminant methods:\n\tdisclist, isdisc.\n\nBasic methods:\n\tqfbapply, qfbapplyL, qfbapplyR, qfbapplyS, idealtoqfb, qfbtoideal.\n\nClass group:\n\tlexind, qfbnarrow, qfbnarrowlex.");

/*SECTION 1: BINARY QUADRATIC FORMS*/

	/*1: DISCRIMINANT METHODS*/
  install(disclist,"GGD0,L,D0,G,",,quad_library);
  addhelp(disclist, "disclist(D1, D2, {fund=0}, {cop=0}): returns the set of discriminants between D1 and D2, inclusive. If fund=1, only returns fundamental discriminants. If cop!=0, only returns discriminants coprime to cop.");
  install(isdisc,"iG");
  addhelp(isdisc,"isdisc(D): returns 1 if D is a discriminant, 0 else.");
	
  /*1: BASIC METHODS*/
  install(qfb_ZM_apply,"GG",qfbapply);/*In PARI but not installed.*/
  addhelp(qfbapply,"qfbapply(q, g): returns the quadratic form formed by g acting on q, where g is a matrix with integral coefficients.");
  install(qfbapplyL,"GD1,G,");
  addhelp(qfbapplyL,"qfbapplyL(q, {n=1}): returns L^n acting on q, where L=[1, 1;0, 1].");
  install(qfbapplyR,"GD1,G,");
  addhelp(qfbapplyR,"qfbapplyR(q, {n=1}): returns R^n acting on q, where R=[1, 0;1, 1].");
  install(qfbapplyS,"G");
  addhelp(qfbapplyS,"qfbapplyS(q): returns S acting on q, where S=[0, 1;-1, 0].");
  install(idealtoqfb,"GG");
  addhelp(idealtoqfb,"idealtoqfb(nf, x): given a quadratic number field, returns the primitive integral binary quadratic form corresponding to the fractional ideal x, positive definite if the field is imaginary. We also assume that we are working in the maximal ideal.");
  install(qfbtoideal,"GG");
  addhelp(qfbtoideal,"qfbtoideal(nf, q): given a quadratic number field, returns the fractional ideal corresponding to the primitive integral binary quadratic form q (positive definite if the field is imaginary). We also assume that its discriminant is fundamental.");
	
	/*1: CLASS GROUP*/
  install(lexind,"GL");
  addhelp(lexind,"lexind(v, ind): returns the index ind output of forvec(a=vector(#v, i, [0, v[i]-1]), print(a)), i.e. finds the corresponding lexicographic ordering element (we increment the indices from last to first).");
  install(qfbnarrow,"Gp");
  addhelp(qfbnarrow,"qfbnarrow(D): returns the narrow class group C=Cl^+(D) in terms of quadratic forms. C[1] is the class number, C[2] are the orders of generators as a Vecsmall (largest to smallest, with each term dividing the previous one), and C[3] are the corresponding generators. Note that class number 1 will return [1, Vecsmall([1]), [idelt]], not [1, [], []], and the second return element is always a Vecsmall, not a vector.");
  install(qfbnarrowlex,"Gp");
  addhelp(qfbnarrowlex,"qfbnarrowlex(D): does qfbnarrow, except the third entry is the lexicographic ordering of representatives of the class group (with respect to the generators and their orders). Can pass in qfbnarrow(D) for D.");


default(parisize, "4096M");