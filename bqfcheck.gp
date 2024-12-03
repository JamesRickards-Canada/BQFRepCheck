/*
REQUIRES quadratic.gp

SECTION 1: Background
Quadratic form supporting methods.


SECTION 2: Theorem 2
Testing Theorem 2.

*/




/*SECTION 1: Background*/

/*Lazy way to get the genera. Returns them as a vector, with each component being a vector of 1 genera.*/
genera(D) = {
  my(cg, prin, ords, gens, last, v, ind, q);
  cg = qfbnarrow(D);
  prin = principalgenus(cg);
  ords = cg[2];
  gens = cg[3];
  last = #ords;
  for (i = 1, last,/*Keep only the generators with even order.*/
    if (ords[i] % 2 == 1, last = i - 1; break);
  );
  if (last == 0, return([prin]));
  topow = vector(last, i, [0, 1]);/*The different genera*/
  v = vector(1 << last);/*How many*/
  ind = 1;
  forvec (X = topow,
    v[ind] = qfbpowmulvec(gens, X);
    ind++;
  );/*Now we have the representatives for each genera*/
  for (i = 1, #v,
    q = v[i];
    v[i] = vector(#prin, j, qfbcomp(q, prin[j]));
  );
  return(v);
}

/*Given the output of qfbnarrow(D), this returns the principal genus. It is poorly done / inefficient, but this isn't really an issue.*/
principalgenus(cg) = {
  my(ords, gens, last, topow, L);
  ords = cg[2];
  gens = cg[3];
  last = #ords;
  for (i = 1, last,/*Square the generators if the order is odd.*/
    if (ords[i] == 2, last = i - 1; break);/*Squares to 1, and everything thereafter does as well.*/
    if (ords[i] % 2 == 1, break);/*This and the rest are odd, and we leave them unchanged.*/
    gens[i] = qfbpow(gens[i], 2);/*Square it*/
    ords[i] = ords[i] >> 1;/*Halve it, still bigger than 1.*/
  );
  if (last == 0, return([qfbpow(gens[1], 2)]));/*All order 2, so only element of principal genus is the identity.*/
  topow = vector(last, i, [0, ords[i] - 1]);/*Possible orders*/
  L = List();/*We know the actual length, but I am lazy.*/
  forvec (X = topow,
    listput(L, qfbpowmulvec(gens, X));
  );
  return(Vec(L));
}

/*gens=[q1, ..., qr] and pows=[a1, ..., as], returns q1^a1*...*qr^ar. We must have s<=r (and can have s<r).*/
qfbpowmulvec(gens, pows) = {
  my(q);
  q = qfbpow(gens[1], pows[1]);
  for (i = 2, #pows, q = qfbcomp(q, qfbpow(gens[i], pows[i])));
  return(q);
}

/*Given a Qfb x, this returns a similar form with first coefficient coprime to 2D (twice the discriminant). We hit it randomly with L and S until this is true.*/
qfbcoprimeshift(x) = {
  my(twoD);
  twoD = x.disc << 1;
  while (gcd(twoD, Vec(x)[1]) > 1,
    if (random(2),
      x = qfbapplyS(x);
    ,
      x = qfbapplyL(x);
    );
  );
  return(x);
}


/*Given a vector v of qfbs, this returns 1 if one of the elements properly represents n, and 0 if none of them do.*/
qfbvecsolve(v, n) = {
  my(l);
  l = #v;
  for (i = 1, l,
    if (qfbsolve(v[i], n, 0), return(1));
  );
  return(0);
}


