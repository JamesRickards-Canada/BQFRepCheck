/*
LOAD quadratic.gp in addition to this file.

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



/*SECTION 2: Theorem 2*/

/*Returns [D, theta_2, [p_1, ..., p_r], [theta_{p_1}, ..., theta_{p_r}], [D_{p_1}, ..., D_{p_r}], D_2]*/
D_getdat(D) = {
  my(Dsig, th2, f, ps, ths, Ds);
  if (D < 0, Dsig = -D, Dsig = D);/*Make positive*/
  th2 = valuation(Dsig, 2);
  Dsig >>= th2;/*Odd part*/
  f = factor(Dsig);
  ps = f[, 1]~;/*Odd prime factors*/
  ths = f[, 2]~;/*Powers */
  Ds = vector(#ps);
  for (i = 1, #ps,
    Ds[i] = D / ps[i]^ths[i];
  );
  return ([D, th2, ps, ths, Ds, D >> th2]);
}

/*Given a genus of quadratic forms, all of discriminant D, with representative [a, b, c] satisfying gcd(a, 2D)=1, as well as Ddat=D_getdat(D), this checks if n is represented by a form in this genus, as determined by Theorem 2 of Iwaniec.*/
thm2(a, Ddat, n) = {
  my(D, m, p, th, e, ptoe, line2check, e2, th2, D2, nodd, frem, f);
  /*Begin by checking the odd primes dividing D.*/
  D = Ddat[1];
  m = n;
  for (i = 1, #Ddat[3],/*Start with lines 1-5*/
    p = Ddat[3][i];
    th = Ddat[4][i];/*p^th||D, p is odd, th>=1.*/
    e = valuation(m, p);
    ptoe = p^e;
    if (e < th,/*line 1 or fail*/
      if (e % 2, return(0));/*Must be even*/
      /*Now check if kron(n/p^e, p)=kron(a, p) or not*/
      if (kronecker(n / ptoe, p) != kronecker(a, p), return(0));
    );
    if (e == th,/*Lines 2 - 4*/
      if (e % 2,/*Line 4*/
        if (kronecker(n / ptoe, p) != kronecker(-a * Ddat[5][i], p), return(0));
      ,/*Lines 2-3. We only need to do stuff when p=3.*/
        if (p == 3,/*Line 3*/
          line2check = 1;
          if (Ddat[5][i] % 3 == 1,/*Passes final column*/
            if ((n / p^e) % 3 == (-a % 3), line2check = 0);/*Line 3 passed, no need to check line 2.*/
          );
          if (line2check,/*Check line 2 for p=3*/
            if (Ddat[5][i] % 3 != 2, return(0));
          );
        );
      );
    );
    if (e > th,/*Line 5*/
      if (th % 2, return(0));
      if (kronecker(Ddat[5][i], p) != 1, return(0));
    );
    m = m / ptoe;/*Update m*/
  );
  
  /*Next, p=2*/
  e2 = valuation(m, 2);
  th2 = Ddat[2];
  D2 = Ddat[6];
  nodd = n >> e2;/*Odd part of n.*/
  if (e2 == 0,
    if (th2 == 0, if (D % 4 != 1, return(0)));/*Line 7*/
    if (th2 == 1, return(0));/*Not represented*/
    if (th2 == 2,/*Line 8*/
      if (D2 % 4 == 3,/*8a, one more check*/
        if (nodd % 4 != (a % 4), return(0));/*Line 8a failed*/
      );
    );
    if (th2 == 3,/*Line 9*/
      frem = nodd % 8;
      if (frem != (a % 8) && frem != ((a * (1 - 2 * D2)) % 8), return(0));
    );
    if (th2 == 4,/*Line 10*/
      if (nodd % 4 != (a % 4), return(0));
    );
    if (th2 >= 5,/*Line 11*/
      if (nodd % 8 != (a % 8), return(0));
    );
  );
  if (e2 >= 1 && th2 == 0,/*Line 12*/
    if (D % 8 != 1, return(0));
  );
  if (e2 >= 1 && th2 >= 1 && e2 <= (th2 - 5),/*Line 13*/
    if (e2 % 2, return(0));
    if (nodd % 8 != (a % 8), return(0));
  );
  if (e2 >= 1 && th2 >= 1 && e2 == (th2 - 4),/*Line 14*/
    if (e2 % 2, return(0));
    if (nodd % 8 != (5*a % 8), return(0));
  );
  if (e2 >= 1 && th2 >= 1 && e2 == (th2 - 3),/*Line 15*/
    if (e2 % 2, return(0));
    if (nodd % 8 != ((a * (1 - 2 * D2)) % 8), return(0));
  );
  if (e2 >= 1 && th2 >= 1 && e2 == (th2 - 2),/*Line 16, 17*/
    if (e2 % 2,/*Line 17*/
      frem = nodd % 8;
      if (frem != ((-a * D2) % 8) && (frem != ((a * (2 - D2)) % 8)), return(0));
    ,/*Line 16*/
      if ((nodd % 4) != ((-a * D2) % 4), return(0));
    )
  );
  if (e2 >= 1 && th2 >= 1 && e2 == (th2 - 1),/*Line 18*/
    if (e2 % 2 == 0, return(0));
    if (D2 % 4 != 3, return(0));
    if (nodd % 4 != (a * ((1 - D2) / 2) % 4), return(0));
  );
  if (e2 >= 1 && th2 >= 1 && e2 == th2,/*Line 19*/
    if (e2 % 2, return(0));
    if (D2 % 8 != 5, return(0));
  );
  if (e2 >= 1 && th2 >= 1 && e2 > th2,/*Line 20*/
    if (th2 % 2, return(0));
    if (D2 % 8 != 1, return(0));
  );
  m >>= e2;/*Update m*/
  
  /*Finally, Line 6*/
  f = factor(m)[, 1];
  for (i = 1, #f,
    p = f[i];
    if (kronecker(D, p) != 1, return(0));
  );
  return(1);/*All lines passed!*/
}

/*Tests Theorem 2 on all genera for n between n1 and n2, printing any exceptions that occur.*/
test_thm2(D, n1, n2) = {
  my(except = 0, g, Ddat, a);
  g = genera(D);
  Ddat = D_getdat(D);
  for (i = 1, #g,
    a = Vec(qfbcoprimeshift(g[i][1]))[1];
    for (n = n1, n2,
      if (n != 0 && thm2(a, Ddat, n) != qfbvecsolve(g[i], n), 
        except++;
        printf("%d %d\n", i, n);
        if (except >= 20, return(0));/*More than 20 exceptions, ABORT*/
      );
    );
  );
  return(1);
}

