fib = method(n,
  i = 0
  j = 1
  cur = 1
  while(cur <= n,
    k = i
    i = j
    j = k + j
    cur++)
  i)

System ifMain(fib(300000))
