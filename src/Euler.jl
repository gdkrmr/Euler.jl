module Euler

# start a Julia REPL and activate the project
# ] activate .

# Go to projecteuler.net and read the assignment complete the functions and run
# the tests with
# ] test

# I have not tested if all the solutions are valid! I you think your solution is
# correct and the test is not, please let me know!

## generate with:
# MAXEULER = 857
# for i in 1:MAXEULER
#     println("# https://projecteuler.net/problem=$i")
#     println("export euler$i")
#     println("function euler$i()")
#     println("")
#     println("end")
# end
#


MAXEULER = 857
for i in 1:MAXEULER
  @eval export $(Symbol("euler" * string(i)))
end


"""
# Exercise:

https://projecteuler.net/problem=1

# Hints:

- x % y: modulus, returns the remainder of x divided by y
- use a for loop to check numbers
"""
function euler1()
  s = 0
  for i in 1:999
    if i % 3 == 0 || i % 5 == 0
      s += i
    end
  end
  return s
end

"""
#Exercise:

https://projecteuler.net/problem=2

# Hints:

- x % y: modulus, returns the remainder of x divided by y
- Fibonacci numbers: x1 = 1, x2 = 2, x3 = x1 + x2, x4 = x3 + x2, ...
"""
function euler2()
  s = 0
  a = 1
  b = 2
  while a < 4_000_000
    if a % 2 == 0
      s += a
    end
    a, b = b, a + b
  end
  return s
end

"""
#Exercise:

https://projecteuler.net/problem=3

# Hints:

- successively divide by small numbers until you cannot any more will also give
  the largest prime factor a factor can occurr more than once

"""
function euler3()
  n = 600851475143
  i = 2
  while i < n
    d, r = divrem(n, i)
    if r == 0
      n = d
    else
      i += 1
    end
  end
  return n
end

# copilot was not able to solve this, but it was able to define this function
# that solved it
function reverse_int(n)
  m = 0
  while n > 0
    n, r = divrem(n, 10)
    m = m * 10 + r
  end
  return m
end

# copilot did not solve this one on first try
"""
#Exercise:

https://projecteuler.net/problem=4

# Hints:
- use two for loops to loop over all combinations of three digit numbers
- you can save half of the work, because x*y == y*x
- write a function that reverses an integer in the decimal system
  - slow version: convert to string, reverse string, parse to number
- fast version: use divrem(n, 10) -> "left digits", "smallest digits"
"""
function euler4()
  m = 0
  for i in 100:999
    for j in 100:999
      n = i * j
      if n > m && n == reverse_int(n)
        m = n
      end
    end
  end
  return m
end

"""
#Exercise:

https://projecteuler.net/problem=5

# Hints:
- checkout the documentation for lcm()
- This is still solvable with brute force.
"""
function euler5()
  n = 1
  for i in 1:20
    n = lcm(n, i)
  end
  return n
end

# The brute force variant takes a while
function euler5()
  n = 20
  d = 1
  while d <= typemax(n)
    for i in 1:n
      if d % i != 0
        d += 1
        break
      end
      if i == n
        return d
      end
    end
  end
end

euler5() = lcm(1:20...)


"""
#Exercise:

https://projecteuler.net/problem=6

# Hints:
- Should be straight forward.
"""
function euler6()
  s = 0
  for i in 1:100
    s += i
  end
  s = s^2
  for i in 1:100
    s -= i^2
  end
  return s
end

# copilot defined this one and solved euler7
function isprime(x)
  if x < 2
    return false
  end
  for i in 2:floor(Int, sqrt(x))
    if x % i == 0
      return false
    end
  end
  return true
end

# copilot did not solve this one on first try! It just assumed there was an
# isprime() function

"""
#Exercise:

https://projecteuler.net/problem=7

# Hints: 
- A prime number  is a number that is only divisible by 1 and itself.
- You only have to check for divisors up to sqrt(n).
- You only have to check prime numbers as divisors.
"""
function euler7()
  n = 0
  i = 0
  while n < 10001
    i += 1
    if isprime(i)
      n += 1
    end
  end
  return i
end

# This is still 100x slower than Primes.prime...
function euler7(n = 10_001)
  if n < 1 
    return Int[]
  end
  #n = 10_001
  # preallocate vector for speed, the vector will contain all first n primes
  primes = Vector{Int}(undef, n)
  primes[1] = 2
  # the number to test if it is prime
  num = 2
  # - i points to the ith prime stored as primes[i]
  # - for 2:1 end does nothing, which makes n = 1 work!
  for i in 2:n 
    @label restart
    num += 1
    # test for the already found primes
    for j in 1:(i - 1) 
      if num % primes[j] == 0
        @goto restart
      end
    end
    # we have to try everything above one by one
    # TODO: we can still optimize not testing all multiples of previous primes.
    for j in primes[i - 1] + 1:floor(Int, sqrt(num))
      if num % j == 0
        @goto restart
      end
    end
    # num is a prime!
    primes[i] = num
  end
  return primes[end]
end

# copilot could not solve this one, I had to do it by hand. Probably because it
# was not able to memorize the 1000 digits.

"""
#Exercise:

https://projecteuler.net/problem=8

# Hints: 
- prod([1, 2, 3]) calculates the product of an array
- *(1, 2, 3) calculates the product of scalars
- reduce(*, [1, 2, 3]) is the same as prod
- 1:10 is a range and data[1:10] copies contiguous indices from an array
- 1:10 + 1 is the same as 1:11 and 1:10 .+ 1 is the same as 2:11
- @view data[1:10] creates a View and avoids copying data.
"""
function euler8()

  data = [
    7, 3, 1, 6, 7, 1, 7, 6, 5, 3, 1, 3, 3, 0, 6, 2, 4, 9, 1, 9, 2, 2, 5, 1,
    1, 9, 6, 7, 4, 4, 2, 6, 5, 7, 4, 7, 4, 2, 3, 5, 5, 3, 4, 9, 1, 9, 4, 9,
    3, 4, 9, 6, 9, 8, 3, 5, 2, 0, 3, 1, 2, 7, 7, 4, 5, 0, 6, 3, 2, 6, 2, 3,
    9, 5, 7, 8, 3, 1, 8, 0, 1, 6, 9, 8, 4, 8, 0, 1, 8, 6, 9, 4, 7, 8, 8, 5,
    1, 8, 4, 3, 8, 5, 8, 6, 1, 5, 6, 0, 7, 8, 9, 1, 1, 2, 9, 4, 9, 4, 9, 5,
    4, 5, 9, 5, 0, 1, 7, 3, 7, 9, 5, 8, 3, 3, 1, 9, 5, 2, 8, 5, 3, 2, 0, 8,
    8, 0, 5, 5, 1, 1, 1, 2, 5, 4, 0, 6, 9, 8, 7, 4, 7, 1, 5, 8, 5, 2, 3, 8,
    6, 3, 0, 5, 0, 7, 1, 5, 6, 9, 3, 2, 9, 0, 9, 6, 3, 2, 9, 5, 2, 2, 7, 4,
    4, 3, 0, 4, 3, 5, 5, 7, 6, 6, 8, 9, 6, 6, 4, 8, 9, 5, 0, 4, 4, 5, 2, 4,
    4, 5, 2, 3, 1, 6, 1, 7, 3, 1, 8, 5, 6, 4, 0, 3, 0, 9, 8, 7, 1, 1, 1, 2,
    1, 7, 2, 2, 3, 8, 3, 1, 1, 3, 6, 2, 2, 2, 9, 8, 9, 3, 4, 2, 3, 3, 8, 0,
    3, 0, 8, 1, 3, 5, 3, 3, 6, 2, 7, 6, 6, 1, 4, 2, 8, 2, 8, 0, 6, 4, 4, 4,
    4, 8, 6, 6, 4, 5, 2, 3, 8, 7, 4, 9, 3, 0, 3, 5, 8, 9, 0, 7, 2, 9, 6, 2,
    9, 0, 4, 9, 1, 5, 6, 0, 4, 4, 0, 7, 7, 2, 3, 9, 0, 7, 1, 3, 8, 1, 0, 5,
    1, 5, 8, 5, 9, 3, 0, 7, 9, 6, 0, 8, 6, 6, 7, 0, 1, 7, 2, 4, 2, 7, 1, 2,
    1, 8, 8, 3, 9, 9, 8, 7, 9, 7, 9, 0, 8, 7, 9, 2, 2, 7, 4, 9, 2, 1, 9, 0,
    1, 6, 9, 9, 7, 2, 0, 8, 8, 8, 0, 9, 3, 7, 7, 6, 6, 5, 7, 2, 7, 3, 3, 3,
    0, 0, 1, 0, 5, 3, 3, 6, 7, 8, 8, 1, 2, 2, 0, 2, 3, 5, 4, 2, 1, 8, 0, 9,
    7, 5, 1, 2, 5, 4, 5, 4, 0, 5, 9, 4, 7, 5, 2, 2, 4, 3, 5, 2, 5, 8, 4, 9,
    0, 7, 7, 1, 1, 6, 7, 0, 5, 5, 6, 0, 1, 3, 6, 0, 4, 8, 3, 9, 5, 8, 6, 4,
    4, 6, 7, 0, 6, 3, 2, 4, 4, 1, 5, 7, 2, 2, 1, 5, 5, 3, 9, 7, 5, 3, 6, 9,
    7, 8, 1, 7, 9, 7, 7, 8, 4, 6, 1, 7, 4, 0, 6, 4, 9, 5, 5, 1, 4, 9, 2, 9,
    0, 8, 6, 2, 5, 6, 9, 3, 2, 1, 9, 7, 8, 4, 6, 8, 6, 2, 2, 4, 8, 2, 8, 3,
    9, 7, 2, 2, 4, 1, 3, 7, 5, 6, 5, 7, 0, 5, 6, 0, 5, 7, 4, 9, 0, 2, 6, 1,
    4, 0, 7, 9, 7, 2, 9, 6, 8, 6, 5, 2, 4, 1, 4, 5, 3, 5, 1, 0, 0, 4, 7, 4,
    8, 2, 1, 6, 6, 3, 7, 0, 4, 8, 4, 4, 0, 3, 1, 9, 9, 8, 9, 0, 0, 0, 8, 8,
    9, 5, 2, 4, 3, 4, 5, 0, 6, 5, 8, 5, 4, 1, 2, 2, 7, 5, 8, 8, 6, 6, 6, 8,
    8, 1, 1, 6, 4, 2, 7, 1, 7, 1, 4, 7, 9, 9, 2, 4, 4, 4, 2, 9, 2, 8, 2, 3,
    0, 8, 6, 3, 4, 6, 5, 6, 7, 4, 8, 1, 3, 9, 1, 9, 1, 2, 3, 1, 6, 2, 8, 2,
    4, 5, 8, 6, 1, 7, 8, 6, 6, 4, 5, 8, 3, 5, 9, 1, 2, 4, 5, 6, 6, 5, 2, 9,
    4, 7, 6, 5, 4, 5, 6, 8, 2, 8, 4, 8, 9, 1, 2, 8, 8, 3, 1, 4, 2, 6, 0, 7,
    6, 9, 0, 0, 4, 2, 2, 4, 2, 1, 9, 0, 2, 2, 6, 7, 1, 0, 5, 5, 6, 2, 6, 3,
    2, 1, 1, 1, 1, 1, 0, 9, 3, 7, 0, 5, 4, 4, 2, 1, 7, 5, 0, 6, 9, 4, 1, 6,
    5, 8, 9, 6, 0, 4, 0, 8, 0, 7, 1, 9, 8, 4, 0, 3, 8, 5, 0, 9, 6, 2, 4, 5,
    5, 4, 4, 4, 3, 6, 2, 9, 8, 1, 2, 3, 0, 9, 8, 7, 8, 7, 9, 9, 2, 7, 2, 4,
    4, 2, 8, 4, 9, 0, 9, 1, 8, 8, 8, 4, 5, 8, 0, 1, 5, 6, 1, 6, 6, 0, 9, 7,
    9, 1, 9, 1, 3, 3, 8, 7, 5, 4, 9, 9, 2, 0, 0, 5, 2, 4, 0, 6, 3, 6, 8, 9,
    9, 1, 2, 5, 6, 0, 7, 1, 7, 6, 0, 6, 0, 5, 8, 8, 6, 1, 1, 6, 4, 6, 7, 1,
    0, 9, 4, 0, 5, 0, 7, 7, 5, 4, 1, 0, 0, 2, 2, 5, 6, 9, 8, 3, 1, 5, 5, 2,
    0, 0, 0, 5, 5, 9, 3, 5, 7, 2, 9, 7, 2, 5, 7, 1, 6, 3, 6, 2, 6, 9, 5, 6,
    1, 8, 8, 2, 6, 7, 0, 4, 2, 8, 2, 5, 2, 4, 8, 3, 6, 0, 0, 8, 2, 3, 2, 5,
    7, 5, 3, 0, 4, 2, 0, 7, 5, 2, 9, 6, 3, 4, 5, 0
  ]

  p = 0
  n = 13
  for i in 0:length(data)-n
    r = (1:n) .+ i
    digits = @view data[r]
    pi = prod(digits)
    if pi > p
      p = pi
    end
  end
  return p
end

"""
#Exercise:

https://projecteuler.net/problem=9

# Hints: 
- should be straightforward
"""
function euler9()
  for a in 1:1000
    for b in a:1000
      c = 1000 - a - b
      if a^2 + b^2 == c^2
        return a * b * c
      end
    end
  end
end

# copilot did not want to autocomplete here, maybe there is ratelimiting :shrug:

"""
#Exercise:

https://projecteuler.net/problem=10

# Hints: 
- we created a function to check if a number is prime earlier
"""
function euler10()
  s = 0
  for i in 1:1_999_999
    if isprime(i)
      s += i
    end
  end
  return s
end

"""
#Exercise:

https://projecteuler.net/problem=11

# Hints: 
- Create a matrix with data = [1 2; 3 4]
- A matrix can be accessed with two indices data[1, 2]
- prod(i for i in 1:10) is a comprehension and is one possible way to multiply selectively from a dense matrix.
"""
function euler11()

  data = [
    08 02 22 97 38 15 00 40 00 75 04 05 07 78 52 12 50 77 91 08;
    49 49 99 40 17 81 18 57 60 87 17 40 98 43 69 48 04 56 62 00;
    81 49 31 73 55 79 14 29 93 71 40 67 53 88 30 03 49 13 36 65;
    52 70 95 23 04 60 11 42 69 24 68 56 01 32 56 71 37 02 36 91;
    22 31 16 71 51 67 63 89 41 92 36 54 22 40 40 28 66 33 13 80;
    24 47 32 60 99 03 45 02 44 75 33 53 78 36 84 20 35 17 12 50;
    32 98 81 28 64 23 67 10 26 38 40 67 59 54 70 66 18 38 64 70;
    67 26 20 68 02 62 12 20 95 63 94 39 63 08 40 91 66 49 94 21;
    24 55 58 05 66 73 99 26 97 17 78 78 96 83 14 88 34 89 63 72;
    21 36 23 09 75 00 76 44 20 45 35 14 00 61 33 97 34 31 33 95;
    78 17 53 28 22 75 31 67 15 94 03 80 04 62 16 14 09 53 56 92;
    16 39 05 42 96 35 31 47 55 58 88 24 00 17 54 24 36 29 85 57;
    86 56 00 48 35 71 89 07 05 44 44 37 44 60 21 58 51 54 17 58;
    19 80 81 68 05 94 47 69 28 73 92 13 86 52 17 77 04 89 55 40;
    04 52 08 83 97 35 99 16 07 97 57 32 16 26 26 79 33 27 98 66;
    88 36 68 87 57 62 20 72 03 46 33 67 46 55 12 32 63 93 53 69;
    04 42 16 73 38 25 39 11 24 94 72 18 08 46 29 32 40 62 76 36;
    20 69 36 41 72 30 23 88 34 62 99 69 82 67 59 85 74 04 36 16;
    20 73 35 29 78 31 90 01 74 31 49 71 48 86 81 16 23 57 05 54;
    01 70 54 71 83 51 54 69 16 92 33 48 61 43 52 01 89 19 67 48
  ]

  n = size(data)
  m = 4
  p = 0

  # horizontal
  for i in 1:n[1]
    for j in 1:n[2]-m
      pi = prod(data[i, j:j+m-1])
      if pi > p
        p = pi
      end
    end
  end

  # vertical
  for i in 1:n[1]-m
    for j in 1:n[2]
      pi = prod(data[i:i+m-1, j])
      if pi > p
        p = pi
      end
    end
  end

  # copilot did not extract the diagonal but an entire submatrix
  # diagonal bottom left to top right
  for i in m:n[1]
    for j in 1:n[2]-m
      # pi = prod(data[i - m + 1:i, j:j + m - 1])
      pi = prod(data[i-k, j+k] for k in 0:m-1)
      if pi > p
        p = pi
      end
    end
  end

  # copilot did not extract the diagonal but an entire submatrix
  # diagonal top left to bottom right
  for i in 1:n[1]-m
    for j in 1:n[2]-m
      pi = prod(data[i+k, j+k] for k in 0:m-1)
      if pi > p
        p = pi
      end
    end
  end

  return p
end

triangle(n) = n * (n + 1) / 2
function divisors(n)
  d = 0
  for i in 1:floor(sqrt(n))
    if n % i == 0
      d += 1
    end
  end
  return 2 * d
end

"""
#Exercise:

https://projecteuler.net/problem=12

# Hints: 
- Use the Gauss formula to calculate the sum of numbers from 1:n.
- you only have to check divisors from 1 to sqrt(n).
- Primes.factor can also calculate prime factors.
"""
function euler12()
  n = 1
  while divisors(triangle(n)) < 500
    n += 1
  end
  return triangle(n)
end

"""
#Exercise:

https://projecteuler.net/problem=13

# Hints: 
- The numbers are too large for normal data types. Normal integer types will overflow and floats will lack accurracy.
- Julia has builtin support for BigInts which do not have these issues, you can create one with big"123".
- To get the first ten digits, either divide repeatedly by ten or convert to string.
- string(123) converts a number to a string.
- parse(Int, "123") converts the string back to an Int
"""
function euler13()
  data = [
    big"37107287533902102798797998220837590246510135740250",
    big"46376937677490009712648124896970078050417018260538",
    big"74324986199524741059474233309513058123726617309629",
    big"91942213363574161572522430563301811072406154908250",
    big"23067588207539346171171980310421047513778063246676",
    big"89261670696623633820136378418383684178734361726757",
    big"28112879812849979408065481931592621691275889832738",
    big"44274228917432520321923589422876796487670272189318",
    big"47451445736001306439091167216856844588711603153276",
    big"70386486105843025439939619828917593665686757934951",
    big"62176457141856560629502157223196586755079324193331",
    big"64906352462741904929101432445813822663347944758178",
    big"92575867718337217661963751590579239728245598838407",
    big"58203565325359399008402633568948830189458628227828",
    big"80181199384826282014278194139940567587151170094390",
    big"35398664372827112653829987240784473053190104293586",
    big"86515506006295864861532075273371959191420517255829",
    big"71693888707715466499115593487603532921714970056938",
    big"54370070576826684624621495650076471787294438377604",
    big"53282654108756828443191190634694037855217779295145",
    big"36123272525000296071075082563815656710885258350721",
    big"45876576172410976447339110607218265236877223636045",
    big"17423706905851860660448207621209813287860733969412",
    big"81142660418086830619328460811191061556940512689692",
    big"51934325451728388641918047049293215058642563049483",
    big"62467221648435076201727918039944693004732956340691",
    big"15732444386908125794514089057706229429197107928209",
    big"55037687525678773091862540744969844508330393682126",
    big"18336384825330154686196124348767681297534375946515",
    big"80386287592878490201521685554828717201219257766954",
    big"78182833757993103614740356856449095527097864797581",
    big"16726320100436897842553539920931837441497806860984",
    big"48403098129077791799088218795327364475675590848030",
    big"87086987551392711854517078544161852424320693150332",
    big"59959406895756536782107074926966537676326235447210",
    big"69793950679652694742597709739166693763042633987085",
    big"41052684708299085211399427365734116182760315001271",
    big"65378607361501080857009149939512557028198746004375",
    big"35829035317434717326932123578154982629742552737307",
    big"94953759765105305946966067683156574377167401875275",
    big"88902802571733229619176668713819931811048770190271",
    big"25267680276078003013678680992525463401061632866526",
    big"36270218540497705585629946580636237993140746255962",
    big"24074486908231174977792365466257246923322810917141",
    big"91430288197103288597806669760892938638285025333403",
    big"34413065578016127815921815005561868836468420090470",
    big"23053081172816430487623791969842487255036638784583",
    big"11487696932154902810424020138335124462181441773470",
    big"63783299490636259666498587618221225225512486764533",
    big"67720186971698544312419572409913959008952310058822",
    big"95548255300263520781532296796249481641953868218774",
    big"76085327132285723110424803456124867697064507995236",
    big"37774242535411291684276865538926205024910326572967",
    big"23701913275725675285653248258265463092207058596522",
    big"29798860272258331913126375147341994889534765745501",
    big"18495701454879288984856827726077713721403798879715",
    big"38298203783031473527721580348144513491373226651381",
    big"34829543829199918180278916522431027392251122869539",
    big"40957953066405232632538044100059654939159879593635",
    big"29746152185502371307642255121183693803580388584903",
    big"41698116222072977186158236678424689157993532961922",
    big"62467957194401269043877107275048102390895523597457",
    big"23189706772547915061505504953922979530901129967519",
    big"86188088225875314529584099251203829009407770775672",
    big"11306739708304724483816533873502340845647058077308",
    big"82959174767140363198008187129011875491310547126581",
    big"97623331044818386269515456334926366572897563400500",
    big"42846280183517070527831839425882145521227251250327",
    big"55121603546981200581762165212827652751691296897789",
    big"32238195734329339946437501907836945765883352399886",
    big"75506164965184775180738168837861091527357929701337",
    big"62177842752192623401942399639168044983993173312731",
    big"32924185707147349566916674687634660915035914677504",
    big"99518671430235219628894890102423325116913619626622",
    big"73267460800591547471830798392868535206946944540724",
    big"76841822524674417161514036427982273348055556214818",
    big"97142617910342598647204516893989422179826088076852",
    big"87783646182799346313767754307809363333018982642090",
    big"10848802521674670883215120185883543223812876952786",
    big"71329612474782464538636993009049310363619763878039",
    big"62184073572399794223406235393808339651327408011116",
    big"66627891981488087797941876876144230030984490851411",
    big"60661826293682836764744779239180335110989069790714",
    big"85786944089552990653640447425576083659976645795096",
    big"66024396409905389607120198219976047599490197230297",
    big"64913982680032973156037120041377903785566085089252",
    big"16730939319872750275468906903707539413042652315011",
    big"94809377245048795150954100921645863754710598436791",
    big"78639167021187492431995700641917969777599028300699",
    big"15368713711936614952811305876380278410754449733078",
    big"40789923115535562561142322423255033685442488917353",
    big"44889911501440648020369068063960672322193204149535",
    big"41503128880339536053299340368006977710650566631954",
    big"81234880673210146739058568557934581403627822703280",
    big"82616570773948327592232845941706525094512325230608",
    big"22918802058777319719839450180888072429661980811197",
    big"77158542502016545090413245809786882778948721859617",
    big"72107838435069186155435662884062257473692284509516",
    big"20849603980134001723930671666823555245252804609722",
    big"53503534226472524250874054075591789781264330331690"
  ]
  return parse(Int, string(sum(data))[1:10])
end

function collatz(n)
  if n % 2 == 0
    return n / 2
  else
    return 3n + 1
  end
end
function collatz_length(n)
  l = 1
  while n != 1
    n = collatz(n)
    l += 1
  end
  return l
end

"""
#Exercise:

https://projecteuler.net/problem=14

# Hints: 
- should be straightforward
"""
function euler14()
  max = 0
  max_i = 0
  for i in 1:999999
    l = collatz_length(i)
    if l > max
      max = l
      max_i = i
    end
  end
  return max_i
end


# euler 15
"""
#Exercise:

https://projecteuler.net/problem=15

# Hints: 
- Combinatorics: in an nxn square we we can go right and down, each n times.
- We can do this in arbitrary order.
- Imagine this as accomodating n times "l" and n times "r" in arbitrary order, e.g. [llrr]
- how many different ways of doing this are there?
- This is 40!/20!/20!
- Numbers are too large for normal Ints, even though the result is not
- Convert to integer with Int(big(123))
"""
euler15() = 
  Int(factorial(big(40)) / (factorial(big(20)) * factorial(big(20))))


"""
#Exercise:

https://projecteuler.net/problem=16

# Hints: 
- Numbers are too large for normal ints again.
- Extract digits as string or by using divmod(x, 10)
"""
function euler16()
  s = 0
  for c in string(big"2"^big"1000")
    s += parse(Int, c)
  end
  return s
end

function number_to_string(n)
  if n == 0
    return ""
  elseif n == 1
    return "one"
  elseif n == 2
    return "two"
  elseif n == 3
    return "three"
  elseif n == 4
    return "four"
  elseif n == 5
    return "five"
  elseif n == 6
    return "six"
  elseif n == 7
    return "seven"
  elseif n == 8
    return "eight"
  elseif n == 9
    return "nine"
  elseif n == 10
    return "ten"
  elseif n == 11
    return "eleven"
  elseif n == 12
    return "twelve"
  elseif n == 13
    return "thirteen"
  elseif n == 14
    return "fourteen"
  elseif n == 15
    return "fifteen"
  elseif n == 16
    return "sixteen"
  elseif n == 17
    return "seventeen"
  elseif n == 18
    return "eighteen"
  elseif n == 19
    return "nineteen"
  elseif n == 20
    return "twenty"
  elseif n == 30
    return "thirty"
  elseif n == 40
    return "forty"
  elseif n == 50
    return "fifty"
  elseif n == 60
    return "sixty"
  elseif n == 70
    return "seventy"
  elseif n == 80
    return "eighty"
  elseif n == 90
    return "ninety"
  elseif n == 100
    return "onehundred"
  elseif n == 1000
    return "onethousand"
  elseif n < 100
    return number_to_string(floor(n / 10) * 10) * number_to_string(n % 10)
  elseif n < 1000
    return number_to_string(floor(n / 100)) * "hundred" * (n % 100 == 0 ? "" : "and") * number_to_string(n % 100)
  end
end

"""
#Exercise:

https://projecteuler.net/problem=17

# Hints: 
- very annoying...
- concatenate strings with "asdf" * "qwer".
- length("adf") gives the length of a string.
"""
function euler17()
  s = 0
  for i in 1:1000
    s += length(number_to_string(i))
  end
  return s
end

"""
#Exercise:

https://projecteuler.net/problem=18

# Hints: 
"""
function euler18()

  data = [
    [75],
    [95, 64],
    [17, 47, 82],
    [18, 35, 87, 10],
    [20, 04, 82, 47, 65],
    [19, 01, 23, 75, 03, 34],
    [88, 02, 77, 73, 07, 63, 67],
    [99, 65, 04, 28, 06, 16, 70, 92],
    [41, 41, 26, 56, 83, 40, 80, 70, 33],
    [41, 48, 72, 33, 47, 32, 37, 16, 94, 29],
    [53, 71, 44, 65, 25, 43, 91, 52, 97, 51, 14],
    [70, 11, 33, 28, 77, 73, 17, 78, 39, 68, 17, 57],
    [91, 71, 52, 38, 17, 14, 91, 43, 58, 50, 27, 29, 48],
    [63, 66, 04, 68, 89, 53, 67, 30, 73, 16, 69, 87, 40, 31],
    [04, 62, 98, 27, 23, 09, 70, 98, 73, 93, 38, 53, 60, 04, 23]
  ]

  # # greedy does not work!
  # s = data[1][1]
  # j = 1
  # for i in 2:length(data)
  #     j = data[i][j] > data[i][j+1] ? j : j+1
  #     s += data[i][j]
  # end
  # return s

  function val(data, path)
    s = 0
    for i in 1:length(data)
      s += data[i][path[i]]
    end
    return s
  end

  path = repeat([1], length(data))
  maxval = val(data, path)

  for j in 1:length(data)-1
    for i in 1:j-1
      path[end-i+1] += 1
      show(path)
      println()
      v = val(data, path)
      if v > maxval
        maxval = v
      end
    end
  end

  return maxval
end

"""
#Exercise:

https://projecteuler.net/problem=19

# Hints: 
"""
function euler19()

end
"""
#Exercise:

https://projecteuler.net/problem=20

# Hints: 
"""
function euler20()

end
"""
#Exercise:

https://projecteuler.net/problem=21

# Hints: 
"""
function euler21()

end
"""
#Exercise:

https://projecteuler.net/problem=22

# Hints: 
"""
function euler22()

end
"""
#Exercise:

https://projecteuler.net/problem=23

# Hints: 
"""
function euler23()

end
"""
#Exercise:

https://projecteuler.net/problem=24

# Hints: 
"""
function euler24()

end
"""
#Exercise:

https://projecteuler.net/problem=25

# Hints: 
"""
function euler25()

end
"""
#Exercise:

https://projecteuler.net/problem=26

# Hints: 
"""
function euler26()

end
"""
#Exercise:

https://projecteuler.net/problem=27

# Hints: 
"""
function euler27()

end
"""
#Exercise:

https://projecteuler.net/problem=28

# Hints: 
"""
function euler28()

end
"""
#Exercise:

https://projecteuler.net/problem=29

# Hints: 
"""
function euler29()

end
"""
#Exercise:

https://projecteuler.net/problem=30

# Hints: 
"""
function euler30()

end
"""
#Exercise:

https://projecteuler.net/problem=31

# Hints: 
"""
function euler31()

end
"""
#Exercise:

https://projecteuler.net/problem=32

# Hints: 
"""
function euler32()

end
"""
#Exercise:

https://projecteuler.net/problem=33

# Hints: 
"""
function euler33()

end
"""
#Exercise:

https://projecteuler.net/problem=34

# Hints: 
"""
function euler34()

end
"""
#Exercise:

https://projecteuler.net/problem=35

# Hints: 
"""
function euler35()

end
"""
#Exercise:

https://projecteuler.net/problem=36

# Hints: 
"""
function euler36()

end
"""
#Exercise:

https://projecteuler.net/problem=37

# Hints: 
"""
function euler37()

end
"""
#Exercise:

https://projecteuler.net/problem=38

# Hints: 
"""
function euler38()

end
"""
#Exercise:

https://projecteuler.net/problem=39

# Hints: 
"""
function euler39()

end
"""
#Exercise:

https://projecteuler.net/problem=40

# Hints: 
"""
function euler40()

end
"""
#Exercise:

https://projecteuler.net/problem=41

# Hints: 
"""
function euler41()

end
"""
#Exercise:

https://projecteuler.net/problem=42

# Hints: 
"""
function euler42()

end
"""
#Exercise:

https://projecteuler.net/problem=43

# Hints: 
"""
function euler43()

end
"""
#Exercise:

https://projecteuler.net/problem=44

# Hints: 
"""
function euler44()

end
"""
#Exercise:

https://projecteuler.net/problem=45

# Hints: 
"""
function euler45()

end
"""
#Exercise:

https://projecteuler.net/problem=46

# Hints: 
"""
function euler46()

end
"""
#Exercise:

https://projecteuler.net/problem=47

# Hints: 
"""
function euler47()

end
"""
#Exercise:

https://projecteuler.net/problem=48

# Hints: 
"""
function euler48()

end
"""
#Exercise:

https://projecteuler.net/problem=49

# Hints: 
"""
function euler49()

end
"""
#Exercise:

https://projecteuler.net/problem=50

# Hints: 
"""
function euler50()

end
"""
#Exercise:

https://projecteuler.net/problem=51

# Hints: 
"""
function euler51()

end
"""
#Exercise:

https://projecteuler.net/problem=52

# Hints: 
"""
function euler52()

end
"""
#Exercise:

https://projecteuler.net/problem=53

# Hints: 
"""
function euler53()

end
"""
#Exercise:

https://projecteuler.net/problem=54

# Hints: 
"""
function euler54()

end
"""
#Exercise:

https://projecteuler.net/problem=55

# Hints: 
"""
function euler55()

end
"""
#Exercise:

https://projecteuler.net/problem=56

# Hints: 
"""
function euler56()

end
"""
#Exercise:

https://projecteuler.net/problem=57

# Hints: 
"""
function euler57()

end
"""
#Exercise:

https://projecteuler.net/problem=58

# Hints: 
"""
function euler58()

end
"""
#Exercise:

https://projecteuler.net/problem=59

# Hints: 
"""
function euler59()

end
"""
#Exercise:

https://projecteuler.net/problem=60

# Hints: 
"""
function euler60()

end
"""
#Exercise:

https://projecteuler.net/problem=61

# Hints: 
"""
function euler61()

end
"""
#Exercise:

https://projecteuler.net/problem=62

# Hints: 
"""
function euler62()

end
"""
#Exercise:

https://projecteuler.net/problem=63

# Hints: 
"""
function euler63()

end
"""
#Exercise:

https://projecteuler.net/problem=64

# Hints: 
"""
function euler64()

end
"""
#Exercise:

https://projecteuler.net/problem=65

# Hints: 
"""
function euler65()

end
"""
#Exercise:

https://projecteuler.net/problem=66

# Hints: 
"""
function euler66()

end
"""
#Exercise:

https://projecteuler.net/problem=67

# Hints: 
"""
function euler67()

end
"""
#Exercise:

https://projecteuler.net/problem=68

# Hints: 
"""
function euler68()

end
"""
#Exercise:

https://projecteuler.net/problem=69

# Hints: 
"""
function euler69()

end
"""
#Exercise:

https://projecteuler.net/problem=70

# Hints: 
"""
function euler70()

end
"""
#Exercise:

https://projecteuler.net/problem=71

# Hints: 
"""
function euler71()

end
"""
#Exercise:

https://projecteuler.net/problem=72

# Hints: 
"""
function euler72()

end
"""
#Exercise:

https://projecteuler.net/problem=73

# Hints: 
"""
function euler73()

end
"""
#Exercise:

https://projecteuler.net/problem=74

# Hints: 
"""
function euler74()

end
"""
#Exercise:

https://projecteuler.net/problem=75

# Hints: 
"""
function euler75()

end
"""
#Exercise:

https://projecteuler.net/problem=76

# Hints: 
"""
function euler76()

end
"""
#Exercise:

https://projecteuler.net/problem=77

# Hints: 
"""
function euler77()

end
"""
#Exercise:

https://projecteuler.net/problem=78

# Hints: 
"""
function euler78()

end
"""
#Exercise:

https://projecteuler.net/problem=79

# Hints: 
"""
function euler79()

end
"""
#Exercise:

https://projecteuler.net/problem=80

# Hints: 
"""
function euler80()

end
"""
#Exercise:

https://projecteuler.net/problem=81

# Hints: 
"""
function euler81()

end
"""
#Exercise:

https://projecteuler.net/problem=82

# Hints: 
"""
function euler82()

end
"""
#Exercise:

https://projecteuler.net/problem=83

# Hints: 
"""
function euler83()

end
"""
#Exercise:

https://projecteuler.net/problem=84

# Hints: 
"""
function euler84()

end
"""
#Exercise:

https://projecteuler.net/problem=85

# Hints: 
"""
function euler85()

end
"""
#Exercise:

https://projecteuler.net/problem=86

# Hints: 
"""
function euler86()

end
"""
#Exercise:

https://projecteuler.net/problem=87

# Hints: 
"""
function euler87()

end
"""
#Exercise:

https://projecteuler.net/problem=88

# Hints: 
"""
function euler88()

end
"""
#Exercise:

https://projecteuler.net/problem=89

# Hints: 
"""
function euler89()

end
"""
#Exercise:

https://projecteuler.net/problem=90

# Hints: 
"""
function euler90()

end
"""
#Exercise:

https://projecteuler.net/problem=91

# Hints: 
"""
function euler91()

end
"""
#Exercise:

https://projecteuler.net/problem=92

# Hints: 
"""
function euler92()

end
"""
#Exercise:

https://projecteuler.net/problem=93

# Hints: 
"""
function euler93()

end
"""
#Exercise:

https://projecteuler.net/problem=94

# Hints: 
"""
function euler94()

end
"""
#Exercise:

https://projecteuler.net/problem=95

# Hints: 
"""
function euler95()

end
"""
#Exercise:

https://projecteuler.net/problem=96

# Hints: 
"""
function euler96()

end
"""
#Exercise:

https://projecteuler.net/problem=97

# Hints: 
"""
function euler97()

end
"""
#Exercise:

https://projecteuler.net/problem=98

# Hints: 
"""
function euler98()

end
"""
#Exercise:

https://projecteuler.net/problem=99

# Hints: 
"""
function euler99()

end
"""
#Exercise:

https://projecteuler.net/problem=100

# Hints: 
"""
function euler100()

end
"""
#Exercise:

https://projecteuler.net/problem=101

# Hints: 
"""
function euler101()

end
"""
#Exercise:

https://projecteuler.net/problem=102

# Hints: 
"""
function euler102()

end
"""
#Exercise:

https://projecteuler.net/problem=103

# Hints: 
"""
function euler103()

end
"""
#Exercise:

https://projecteuler.net/problem=104

# Hints: 
"""
function euler104()

end
"""
#Exercise:

https://projecteuler.net/problem=105

# Hints: 
"""
function euler105()

end
"""
#Exercise:

https://projecteuler.net/problem=106

# Hints: 
"""
function euler106()

end
"""
#Exercise:

https://projecteuler.net/problem=107

# Hints: 
"""
function euler107()

end
"""
#Exercise:

https://projecteuler.net/problem=108

# Hints: 
"""
function euler108()

end
"""
#Exercise:

https://projecteuler.net/problem=109

# Hints: 
"""
function euler109()

end
"""
#Exercise:

https://projecteuler.net/problem=110

# Hints: 
"""
function euler110()

end
"""
#Exercise:

https://projecteuler.net/problem=111

# Hints: 
"""
function euler111()

end
"""
#Exercise:

https://projecteuler.net/problem=112

# Hints: 
"""
function euler112()

end
"""
#Exercise:

https://projecteuler.net/problem=113

# Hints: 
"""
function euler113()

end
"""
#Exercise:

https://projecteuler.net/problem=114

# Hints: 
"""
function euler114()

end
"""
#Exercise:

https://projecteuler.net/problem=115

# Hints: 
"""
function euler115()

end
"""
#Exercise:

https://projecteuler.net/problem=116

# Hints: 
"""
function euler116()

end
"""
#Exercise:

https://projecteuler.net/problem=117

# Hints: 
"""
function euler117()

end
"""
#Exercise:

https://projecteuler.net/problem=118

# Hints: 
"""
function euler118()

end
"""
#Exercise:

https://projecteuler.net/problem=119

# Hints: 
"""
function euler119()

end
"""
#Exercise:

https://projecteuler.net/problem=120

# Hints: 
"""
function euler120()

end
"""
#Exercise:

https://projecteuler.net/problem=121

# Hints: 
"""
function euler121()

end
"""
#Exercise:

https://projecteuler.net/problem=122

# Hints: 
"""
function euler122()

end
"""
#Exercise:

https://projecteuler.net/problem=123

# Hints: 
"""
function euler123()

end
"""
#Exercise:

https://projecteuler.net/problem=124

# Hints: 
"""
function euler124()

end
"""
#Exercise:

https://projecteuler.net/problem=125

# Hints: 
"""
function euler125()

end
"""
#Exercise:

https://projecteuler.net/problem=126

# Hints: 
"""
function euler126()

end
"""
#Exercise:

https://projecteuler.net/problem=127

# Hints: 
"""
function euler127()

end
"""
#Exercise:

https://projecteuler.net/problem=128

# Hints: 
"""
function euler128()

end
"""
#Exercise:

https://projecteuler.net/problem=129

# Hints: 
"""
function euler129()

end
"""
#Exercise:

https://projecteuler.net/problem=130

# Hints: 
"""
function euler130()

end
"""
#Exercise:

https://projecteuler.net/problem=131

# Hints: 
"""
function euler131()

end
"""
#Exercise:

https://projecteuler.net/problem=132

# Hints: 
"""
function euler132()

end
"""
#Exercise:

https://projecteuler.net/problem=133

# Hints: 
"""
function euler133()

end
"""
#Exercise:

https://projecteuler.net/problem=134

# Hints: 
"""
function euler134()

end
"""
#Exercise:

https://projecteuler.net/problem=135

# Hints: 
"""
function euler135()

end
"""
#Exercise:

https://projecteuler.net/problem=136

# Hints: 
"""
function euler136()

end
"""
#Exercise:

https://projecteuler.net/problem=137

# Hints: 
"""
function euler137()

end
"""
#Exercise:

https://projecteuler.net/problem=138

# Hints: 
"""
function euler138()

end
"""
#Exercise:

https://projecteuler.net/problem=139

# Hints: 
"""
function euler139()

end
"""
#Exercise:

https://projecteuler.net/problem=140

# Hints: 
"""
function euler140()

end
"""
#Exercise:

https://projecteuler.net/problem=141

# Hints: 
"""
function euler141()

end
"""
#Exercise:

https://projecteuler.net/problem=142

# Hints: 
"""
function euler142()

end
"""
#Exercise:

https://projecteuler.net/problem=143

# Hints: 
"""
function euler143()

end
"""
#Exercise:

https://projecteuler.net/problem=144

# Hints: 
"""
function euler144()

end
"""
#Exercise:

https://projecteuler.net/problem=145

# Hints: 
"""
function euler145()

end
"""
#Exercise:

https://projecteuler.net/problem=146

# Hints: 
"""
function euler146()

end
"""
#Exercise:

https://projecteuler.net/problem=147

# Hints: 
"""
function euler147()

end
"""
#Exercise:

https://projecteuler.net/problem=148

# Hints: 
"""
function euler148()

end
"""
#Exercise:

https://projecteuler.net/problem=149

# Hints: 
"""
function euler149()

end
"""
#Exercise:

https://projecteuler.net/problem=150

# Hints: 
"""
function euler150()

end
"""
#Exercise:

https://projecteuler.net/problem=151

# Hints: 
"""
function euler151()

end
"""
#Exercise:

https://projecteuler.net/problem=152

# Hints: 
"""
function euler152()

end
"""
#Exercise:

https://projecteuler.net/problem=153

# Hints: 
"""
function euler153()

end
"""
#Exercise:

https://projecteuler.net/problem=154

# Hints: 
"""
function euler154()

end
"""
#Exercise:

https://projecteuler.net/problem=155

# Hints: 
"""
function euler155()

end
"""
#Exercise:

https://projecteuler.net/problem=156

# Hints: 
"""
function euler156()

end
"""
#Exercise:

https://projecteuler.net/problem=157

# Hints: 
"""
function euler157()

end
"""
#Exercise:

https://projecteuler.net/problem=158

# Hints: 
"""
function euler158()

end
"""
#Exercise:

https://projecteuler.net/problem=159

# Hints: 
"""
function euler159()

end
"""
#Exercise:

https://projecteuler.net/problem=160

# Hints: 
"""
function euler160()

end
"""
#Exercise:

https://projecteuler.net/problem=161

# Hints: 
"""
function euler161()

end
"""
#Exercise:

https://projecteuler.net/problem=162

# Hints: 
"""
function euler162()

end
"""
#Exercise:

https://projecteuler.net/problem=163

# Hints: 
"""
function euler163()

end
"""
#Exercise:

https://projecteuler.net/problem=164

# Hints: 
"""
function euler164()

end
"""
#Exercise:

https://projecteuler.net/problem=165

# Hints: 
"""
function euler165()

end
"""
#Exercise:

https://projecteuler.net/problem=166

# Hints: 
"""
function euler166()

end
"""
#Exercise:

https://projecteuler.net/problem=167

# Hints: 
"""
function euler167()

end
"""
#Exercise:

https://projecteuler.net/problem=168

# Hints: 
"""
function euler168()

end
"""
#Exercise:

https://projecteuler.net/problem=169

# Hints: 
"""
function euler169()

end
"""
#Exercise:

https://projecteuler.net/problem=170

# Hints: 
"""
function euler170()

end
"""
#Exercise:

https://projecteuler.net/problem=171

# Hints: 
"""
function euler171()

end
"""
#Exercise:

https://projecteuler.net/problem=172

# Hints: 
"""
function euler172()

end
"""
#Exercise:

https://projecteuler.net/problem=173

# Hints: 
"""
function euler173()

end
"""
#Exercise:

https://projecteuler.net/problem=174

# Hints: 
"""
function euler174()

end
"""
#Exercise:

https://projecteuler.net/problem=175

# Hints: 
"""
function euler175()

end
"""
#Exercise:

https://projecteuler.net/problem=176

# Hints: 
"""
function euler176()

end
"""
#Exercise:

https://projecteuler.net/problem=177

# Hints: 
"""
function euler177()

end
"""
#Exercise:

https://projecteuler.net/problem=178

# Hints: 
"""
function euler178()

end
"""
#Exercise:

https://projecteuler.net/problem=179

# Hints: 
"""
function euler179()

end
"""
#Exercise:

https://projecteuler.net/problem=180

# Hints: 
"""
function euler180()

end
"""
#Exercise:

https://projecteuler.net/problem=181

# Hints: 
"""
function euler181()

end
"""
#Exercise:

https://projecteuler.net/problem=182

# Hints: 
"""
function euler182()

end
"""
#Exercise:

https://projecteuler.net/problem=183

# Hints: 
"""
function euler183()

end
"""
#Exercise:

https://projecteuler.net/problem=184

# Hints: 
"""
function euler184()

end
"""
#Exercise:

https://projecteuler.net/problem=185

# Hints: 
"""
function euler185()

end
"""
#Exercise:

https://projecteuler.net/problem=186

# Hints: 
"""
function euler186()

end
"""
#Exercise:

https://projecteuler.net/problem=187

# Hints: 
"""
function euler187()

end
"""
#Exercise:

https://projecteuler.net/problem=188

# Hints: 
"""
function euler188()

end
"""
#Exercise:

https://projecteuler.net/problem=189

# Hints: 
"""
function euler189()

end
"""
#Exercise:

https://projecteuler.net/problem=190

# Hints: 
"""
function euler190()

end
"""
#Exercise:

https://projecteuler.net/problem=191

# Hints: 
"""
function euler191()

end
"""
#Exercise:

https://projecteuler.net/problem=192

# Hints: 
"""
function euler192()

end
"""
#Exercise:

https://projecteuler.net/problem=193

# Hints: 
"""
function euler193()

end
"""
#Exercise:

https://projecteuler.net/problem=194

# Hints: 
"""
function euler194()

end
"""
#Exercise:

https://projecteuler.net/problem=195

# Hints: 
"""
function euler195()

end
"""
#Exercise:

https://projecteuler.net/problem=196

# Hints: 
"""
function euler196()

end
"""
#Exercise:

https://projecteuler.net/problem=197

# Hints: 
"""
function euler197()

end
"""
#Exercise:

https://projecteuler.net/problem=198

# Hints: 
"""
function euler198()

end
"""
#Exercise:

https://projecteuler.net/problem=199

# Hints: 
"""
function euler199()

end
"""
#Exercise:

https://projecteuler.net/problem=200

# Hints: 
"""
function euler200()

end
"""
#Exercise:

https://projecteuler.net/problem=201

# Hints: 
"""
function euler201()

end
"""
#Exercise:

https://projecteuler.net/problem=202

# Hints: 
"""
function euler202()

end
"""
#Exercise:

https://projecteuler.net/problem=203

# Hints: 
"""
function euler203()

end
"""
#Exercise:

https://projecteuler.net/problem=204

# Hints: 
"""
function euler204()

end
"""
#Exercise:

https://projecteuler.net/problem=205

# Hints: 
"""
function euler205()

end
"""
#Exercise:

https://projecteuler.net/problem=206

# Hints: 
"""
function euler206()

end
"""
#Exercise:

https://projecteuler.net/problem=207

# Hints: 
"""
function euler207()

end
"""
#Exercise:

https://projecteuler.net/problem=208

# Hints: 
"""
function euler208()

end
"""
#Exercise:

https://projecteuler.net/problem=209

# Hints: 
"""
function euler209()

end
"""
#Exercise:

https://projecteuler.net/problem=210

# Hints: 
"""
function euler210()

end
"""
#Exercise:

https://projecteuler.net/problem=211

# Hints: 
"""
function euler211()

end
"""
#Exercise:

https://projecteuler.net/problem=212

# Hints: 
"""
function euler212()

end
"""
#Exercise:

https://projecteuler.net/problem=213

# Hints: 
"""
function euler213()

end
"""
#Exercise:

https://projecteuler.net/problem=214

# Hints: 
"""
function euler214()

end
"""
#Exercise:

https://projecteuler.net/problem=215

# Hints: 
"""
function euler215()

end
"""
#Exercise:

https://projecteuler.net/problem=216

# Hints: 
"""
function euler216()

end
"""
#Exercise:

https://projecteuler.net/problem=217

# Hints: 
"""
function euler217()

end
"""
#Exercise:

https://projecteuler.net/problem=218

# Hints: 
"""
function euler218()

end
"""
#Exercise:

https://projecteuler.net/problem=219

# Hints: 
"""
function euler219()

end
"""
#Exercise:

https://projecteuler.net/problem=220

# Hints: 
"""
function euler220()

end
"""
#Exercise:

https://projecteuler.net/problem=221

# Hints: 
"""
function euler221()

end
"""
#Exercise:

https://projecteuler.net/problem=222

# Hints: 
"""
function euler222()

end
"""
#Exercise:

https://projecteuler.net/problem=223

# Hints: 
"""
function euler223()

end
"""
#Exercise:

https://projecteuler.net/problem=224

# Hints: 
"""
function euler224()

end
"""
#Exercise:

https://projecteuler.net/problem=225

# Hints: 
"""
function euler225()

end
"""
#Exercise:

https://projecteuler.net/problem=226

# Hints: 
"""
function euler226()

end
"""
#Exercise:

https://projecteuler.net/problem=227

# Hints: 
"""
function euler227()

end
"""
#Exercise:

https://projecteuler.net/problem=228

# Hints: 
"""
function euler228()

end
"""
#Exercise:

https://projecteuler.net/problem=229

# Hints: 
"""
function euler229()

end
"""
#Exercise:

https://projecteuler.net/problem=230

# Hints: 
"""
function euler230()

end
"""
#Exercise:

https://projecteuler.net/problem=231

# Hints: 
"""
function euler231()

end
"""
#Exercise:

https://projecteuler.net/problem=232

# Hints: 
"""
function euler232()

end
"""
#Exercise:

https://projecteuler.net/problem=233

# Hints: 
"""
function euler233()

end
"""
#Exercise:

https://projecteuler.net/problem=234

# Hints: 
"""
function euler234()

end
"""
#Exercise:

https://projecteuler.net/problem=235

# Hints: 
"""
function euler235()

end
"""
#Exercise:

https://projecteuler.net/problem=236

# Hints: 
"""
function euler236()

end
"""
#Exercise:

https://projecteuler.net/problem=237

# Hints: 
"""
function euler237()

end
"""
#Exercise:

https://projecteuler.net/problem=238

# Hints: 
"""
function euler238()

end
"""
#Exercise:

https://projecteuler.net/problem=239

# Hints: 
"""
function euler239()

end
"""
#Exercise:

https://projecteuler.net/problem=240

# Hints: 
"""
function euler240()

end
"""
#Exercise:

https://projecteuler.net/problem=241

# Hints: 
"""
function euler241()

end
"""
#Exercise:

https://projecteuler.net/problem=242

# Hints: 
"""
function euler242()

end
"""
#Exercise:

https://projecteuler.net/problem=243

# Hints: 
"""
function euler243()

end
"""
#Exercise:

https://projecteuler.net/problem=244

# Hints: 
"""
function euler244()

end
"""
#Exercise:

https://projecteuler.net/problem=245

# Hints: 
"""
function euler245()

end
"""
#Exercise:

https://projecteuler.net/problem=246

# Hints: 
"""
function euler246()

end
"""
#Exercise:

https://projecteuler.net/problem=247

# Hints: 
"""
function euler247()

end
"""
#Exercise:

https://projecteuler.net/problem=248

# Hints: 
"""
function euler248()

end
"""
#Exercise:

https://projecteuler.net/problem=249

# Hints: 
"""
function euler249()

end
"""
#Exercise:

https://projecteuler.net/problem=250

# Hints: 
"""
function euler250()

end
"""
#Exercise:

https://projecteuler.net/problem=251

# Hints: 
"""
function euler251()

end
"""
#Exercise:

https://projecteuler.net/problem=252

# Hints: 
"""
function euler252()

end
"""
#Exercise:

https://projecteuler.net/problem=253

# Hints: 
"""
function euler253()

end
"""
#Exercise:

https://projecteuler.net/problem=254

# Hints: 
"""
function euler254()

end
"""
#Exercise:

https://projecteuler.net/problem=255

# Hints: 
"""
function euler255()

end
"""
#Exercise:

https://projecteuler.net/problem=256

# Hints: 
"""
function euler256()

end
"""
#Exercise:

https://projecteuler.net/problem=257

# Hints: 
"""
function euler257()

end
"""
#Exercise:

https://projecteuler.net/problem=258

# Hints: 
"""
function euler258()

end
"""
#Exercise:

https://projecteuler.net/problem=259

# Hints: 
"""
function euler259()

end
"""
#Exercise:

https://projecteuler.net/problem=260

# Hints: 
"""
function euler260()

end
"""
#Exercise:

https://projecteuler.net/problem=261

# Hints: 
"""
function euler261()

end
"""
#Exercise:

https://projecteuler.net/problem=262

# Hints: 
"""
function euler262()

end
"""
#Exercise:

https://projecteuler.net/problem=263

# Hints: 
"""
function euler263()

end
"""
#Exercise:

https://projecteuler.net/problem=264

# Hints: 
"""
function euler264()

end
"""
#Exercise:

https://projecteuler.net/problem=265

# Hints: 
"""
function euler265()

end
"""
#Exercise:

https://projecteuler.net/problem=266

# Hints: 
"""
function euler266()

end
"""
#Exercise:

https://projecteuler.net/problem=267

# Hints: 
"""
function euler267()

end
"""
#Exercise:

https://projecteuler.net/problem=268

# Hints: 
"""
function euler268()

end
"""
#Exercise:

https://projecteuler.net/problem=269

# Hints: 
"""
function euler269()

end
"""
#Exercise:

https://projecteuler.net/problem=270

# Hints: 
"""
function euler270()

end
"""
#Exercise:

https://projecteuler.net/problem=271

# Hints: 
"""
function euler271()

end
"""
#Exercise:

https://projecteuler.net/problem=272

# Hints: 
"""
function euler272()

end
"""
#Exercise:

https://projecteuler.net/problem=273

# Hints: 
"""
function euler273()

end
"""
#Exercise:

https://projecteuler.net/problem=274

# Hints: 
"""
function euler274()

end
"""
#Exercise:

https://projecteuler.net/problem=275

# Hints: 
"""
function euler275()

end
"""
#Exercise:

https://projecteuler.net/problem=276

# Hints: 
"""
function euler276()

end
"""
#Exercise:

https://projecteuler.net/problem=277

# Hints: 
"""
function euler277()

end
"""
#Exercise:

https://projecteuler.net/problem=278

# Hints: 
"""
function euler278()

end
"""
#Exercise:

https://projecteuler.net/problem=279

# Hints: 
"""
function euler279()

end
"""
#Exercise:

https://projecteuler.net/problem=280

# Hints: 
"""
function euler280()

end
"""
#Exercise:

https://projecteuler.net/problem=281

# Hints: 
"""
function euler281()

end
"""
#Exercise:

https://projecteuler.net/problem=282

# Hints: 
"""
function euler282()

end
"""
#Exercise:

https://projecteuler.net/problem=283

# Hints: 
"""
function euler283()

end
"""
#Exercise:

https://projecteuler.net/problem=284

# Hints: 
"""
function euler284()

end
"""
#Exercise:

https://projecteuler.net/problem=285

# Hints: 
"""
function euler285()

end
"""
#Exercise:

https://projecteuler.net/problem=286

# Hints: 
"""
function euler286()

end
"""
#Exercise:

https://projecteuler.net/problem=287

# Hints: 
"""
function euler287()

end
"""
#Exercise:

https://projecteuler.net/problem=288

# Hints: 
"""
function euler288()

end
"""
#Exercise:

https://projecteuler.net/problem=289

# Hints: 
"""
function euler289()

end
"""
#Exercise:

https://projecteuler.net/problem=290

# Hints: 
"""
function euler290()

end
"""
#Exercise:

https://projecteuler.net/problem=291

# Hints: 
"""
function euler291()

end
"""
#Exercise:

https://projecteuler.net/problem=292

# Hints: 
"""
function euler292()

end
"""
#Exercise:

https://projecteuler.net/problem=293

# Hints: 
"""
function euler293()

end
"""
#Exercise:

https://projecteuler.net/problem=294

# Hints: 
"""
function euler294()

end
"""
#Exercise:

https://projecteuler.net/problem=295

# Hints: 
"""
function euler295()

end
"""
#Exercise:

https://projecteuler.net/problem=296

# Hints: 
"""
function euler296()

end
"""
#Exercise:

https://projecteuler.net/problem=297

# Hints: 
"""
function euler297()

end
"""
#Exercise:

https://projecteuler.net/problem=298

# Hints: 
"""
function euler298()

end
"""
#Exercise:

https://projecteuler.net/problem=299

# Hints: 
"""
function euler299()

end
"""
#Exercise:

https://projecteuler.net/problem=300

# Hints: 
"""
function euler300()

end
"""
#Exercise:

https://projecteuler.net/problem=301

# Hints: 
"""
function euler301()

end
"""
#Exercise:

https://projecteuler.net/problem=302

# Hints: 
"""
function euler302()

end
"""
#Exercise:

https://projecteuler.net/problem=303

# Hints: 
"""
function euler303()

end
"""
#Exercise:

https://projecteuler.net/problem=304

# Hints: 
"""
function euler304()

end
"""
#Exercise:

https://projecteuler.net/problem=305

# Hints: 
"""
function euler305()

end
"""
#Exercise:

https://projecteuler.net/problem=306

# Hints: 
"""
function euler306()

end
"""
#Exercise:

https://projecteuler.net/problem=307

# Hints: 
"""
function euler307()

end
"""
#Exercise:

https://projecteuler.net/problem=308

# Hints: 
"""
function euler308()

end
"""
#Exercise:

https://projecteuler.net/problem=309

# Hints: 
"""
function euler309()

end
"""
#Exercise:

https://projecteuler.net/problem=310

# Hints: 
"""
function euler310()

end
"""
#Exercise:

https://projecteuler.net/problem=311

# Hints: 
"""
function euler311()

end
"""
#Exercise:

https://projecteuler.net/problem=312

# Hints: 
"""
function euler312()

end
"""
#Exercise:

https://projecteuler.net/problem=313

# Hints: 
"""
function euler313()

end
"""
#Exercise:

https://projecteuler.net/problem=314

# Hints: 
"""
function euler314()

end
"""
#Exercise:

https://projecteuler.net/problem=315

# Hints: 
"""
function euler315()

end
"""
#Exercise:

https://projecteuler.net/problem=316

# Hints: 
"""
function euler316()

end
"""
#Exercise:

https://projecteuler.net/problem=317

# Hints: 
"""
function euler317()

end
"""
#Exercise:

https://projecteuler.net/problem=318

# Hints: 
"""
function euler318()

end
"""
#Exercise:

https://projecteuler.net/problem=319

# Hints: 
"""
function euler319()

end
"""
#Exercise:

https://projecteuler.net/problem=320

# Hints: 
"""
function euler320()

end
"""
#Exercise:

https://projecteuler.net/problem=321

# Hints: 
"""
function euler321()

end
"""
#Exercise:

https://projecteuler.net/problem=322

# Hints: 
"""
function euler322()

end
"""
#Exercise:

https://projecteuler.net/problem=323

# Hints: 
"""
function euler323()

end
"""
#Exercise:

https://projecteuler.net/problem=324

# Hints: 
"""
function euler324()

end
"""
#Exercise:

https://projecteuler.net/problem=325

# Hints: 
"""
function euler325()

end
"""
#Exercise:

https://projecteuler.net/problem=326

# Hints: 
"""
function euler326()

end
"""
#Exercise:

https://projecteuler.net/problem=327

# Hints: 
"""
function euler327()

end
"""
#Exercise:

https://projecteuler.net/problem=328

# Hints: 
"""
function euler328()

end
"""
#Exercise:

https://projecteuler.net/problem=329

# Hints: 
"""
function euler329()

end
"""
#Exercise:

https://projecteuler.net/problem=330

# Hints: 
"""
function euler330()

end
"""
#Exercise:

https://projecteuler.net/problem=331

# Hints: 
"""
function euler331()

end
"""
#Exercise:

https://projecteuler.net/problem=332

# Hints: 
"""
function euler332()

end
"""
#Exercise:

https://projecteuler.net/problem=333

# Hints: 
"""
function euler333()

end
"""
#Exercise:

https://projecteuler.net/problem=334

# Hints: 
"""
function euler334()

end
"""
#Exercise:

https://projecteuler.net/problem=335

# Hints: 
"""
function euler335()

end
"""
#Exercise:

https://projecteuler.net/problem=336

# Hints: 
"""
function euler336()

end
"""
#Exercise:

https://projecteuler.net/problem=337

# Hints: 
"""
function euler337()

end
"""
#Exercise:

https://projecteuler.net/problem=338

# Hints: 
"""
function euler338()

end
"""
#Exercise:

https://projecteuler.net/problem=339

# Hints: 
"""
function euler339()

end
"""
#Exercise:

https://projecteuler.net/problem=340

# Hints: 
"""
function euler340()

end
"""
#Exercise:

https://projecteuler.net/problem=341

# Hints: 
"""
function euler341()

end
"""
#Exercise:

https://projecteuler.net/problem=342

# Hints: 
"""
function euler342()

end
"""
#Exercise:

https://projecteuler.net/problem=343

# Hints: 
"""
function euler343()

end
"""
#Exercise:

https://projecteuler.net/problem=344

# Hints: 
"""
function euler344()

end
"""
#Exercise:

https://projecteuler.net/problem=345

# Hints: 
"""
function euler345()

end
"""
#Exercise:

https://projecteuler.net/problem=346

# Hints: 
"""
function euler346()

end
"""
#Exercise:

https://projecteuler.net/problem=347

# Hints: 
"""
function euler347()

end
"""
#Exercise:

https://projecteuler.net/problem=348

# Hints: 
"""
function euler348()

end
"""
#Exercise:

https://projecteuler.net/problem=349

# Hints: 
"""
function euler349()

end
"""
#Exercise:

https://projecteuler.net/problem=350

# Hints: 
"""
function euler350()

end
"""
#Exercise:

https://projecteuler.net/problem=351

# Hints: 
"""
function euler351()

end
"""
#Exercise:

https://projecteuler.net/problem=352

# Hints: 
"""
function euler352()

end
"""
#Exercise:

https://projecteuler.net/problem=353

# Hints: 
"""
function euler353()

end
"""
#Exercise:

https://projecteuler.net/problem=354

# Hints: 
"""
function euler354()

end
"""
#Exercise:

https://projecteuler.net/problem=355

# Hints: 
"""
function euler355()

end
"""
#Exercise:

https://projecteuler.net/problem=356

# Hints: 
"""
function euler356()

end
"""
#Exercise:

https://projecteuler.net/problem=357

# Hints: 
"""
function euler357()

end
"""
#Exercise:

https://projecteuler.net/problem=358

# Hints: 
"""
function euler358()

end
"""
#Exercise:

https://projecteuler.net/problem=359

# Hints: 
"""
function euler359()

end
"""
#Exercise:

https://projecteuler.net/problem=360

# Hints: 
"""
function euler360()

end
"""
#Exercise:

https://projecteuler.net/problem=361

# Hints: 
"""
function euler361()

end
"""
#Exercise:

https://projecteuler.net/problem=362

# Hints: 
"""
function euler362()

end
"""
#Exercise:

https://projecteuler.net/problem=363

# Hints: 
"""
function euler363()

end
"""
#Exercise:

https://projecteuler.net/problem=364

# Hints: 
"""
function euler364()

end
"""
#Exercise:

https://projecteuler.net/problem=365

# Hints: 
"""
function euler365()

end
"""
#Exercise:

https://projecteuler.net/problem=366

# Hints: 
"""
function euler366()

end
"""
#Exercise:

https://projecteuler.net/problem=367

# Hints: 
"""
function euler367()

end
"""
#Exercise:

https://projecteuler.net/problem=368

# Hints: 
"""
function euler368()

end
"""
#Exercise:

https://projecteuler.net/problem=369

# Hints: 
"""
function euler369()

end
"""
#Exercise:

https://projecteuler.net/problem=370

# Hints: 
"""
function euler370()

end
"""
#Exercise:

https://projecteuler.net/problem=371

# Hints: 
"""
function euler371()

end
"""
#Exercise:

https://projecteuler.net/problem=372

# Hints: 
"""
function euler372()

end
"""
#Exercise:

https://projecteuler.net/problem=373

# Hints: 
"""
function euler373()

end
"""
#Exercise:

https://projecteuler.net/problem=374

# Hints: 
"""
function euler374()

end
"""
#Exercise:

https://projecteuler.net/problem=375

# Hints: 
"""
function euler375()

end
"""
#Exercise:

https://projecteuler.net/problem=376

# Hints: 
"""
function euler376()

end
"""
#Exercise:

https://projecteuler.net/problem=377

# Hints: 
"""
function euler377()

end
"""
#Exercise:

https://projecteuler.net/problem=378

# Hints: 
"""
function euler378()

end
"""
#Exercise:

https://projecteuler.net/problem=379

# Hints: 
"""
function euler379()

end
"""
#Exercise:

https://projecteuler.net/problem=380

# Hints: 
"""
function euler380()

end
"""
#Exercise:

https://projecteuler.net/problem=381

# Hints: 
"""
function euler381()

end
"""
#Exercise:

https://projecteuler.net/problem=382

# Hints: 
"""
function euler382()

end
"""
#Exercise:

https://projecteuler.net/problem=383

# Hints: 
"""
function euler383()

end
"""
#Exercise:

https://projecteuler.net/problem=384

# Hints: 
"""
function euler384()

end
"""
#Exercise:

https://projecteuler.net/problem=385

# Hints: 
"""
function euler385()

end
"""
#Exercise:

https://projecteuler.net/problem=386

# Hints: 
"""
function euler386()

end
"""
#Exercise:

https://projecteuler.net/problem=387

# Hints: 
"""
function euler387()

end
"""
#Exercise:

https://projecteuler.net/problem=388

# Hints: 
"""
function euler388()

end
"""
#Exercise:

https://projecteuler.net/problem=389

# Hints: 
"""
function euler389()

end
"""
#Exercise:

https://projecteuler.net/problem=390

# Hints: 
"""
function euler390()

end
"""
#Exercise:

https://projecteuler.net/problem=391

# Hints: 
"""
function euler391()

end
"""
#Exercise:

https://projecteuler.net/problem=392

# Hints: 
"""
function euler392()

end
"""
#Exercise:

https://projecteuler.net/problem=393

# Hints: 
"""
function euler393()

end
"""
#Exercise:

https://projecteuler.net/problem=394

# Hints: 
"""
function euler394()

end
"""
#Exercise:

https://projecteuler.net/problem=395

# Hints: 
"""
function euler395()

end
"""
#Exercise:

https://projecteuler.net/problem=396

# Hints: 
"""
function euler396()

end
"""
#Exercise:

https://projecteuler.net/problem=397

# Hints: 
"""
function euler397()

end
"""
#Exercise:

https://projecteuler.net/problem=398

# Hints: 
"""
function euler398()

end
"""
#Exercise:

https://projecteuler.net/problem=399

# Hints: 
"""
function euler399()

end
"""
#Exercise:

https://projecteuler.net/problem=400

# Hints: 
"""
function euler400()

end
"""
#Exercise:

https://projecteuler.net/problem=401

# Hints: 
"""
function euler401()

end
"""
#Exercise:

https://projecteuler.net/problem=402

# Hints: 
"""
function euler402()

end
"""
#Exercise:

https://projecteuler.net/problem=403

# Hints: 
"""
function euler403()

end
"""
#Exercise:

https://projecteuler.net/problem=404

# Hints: 
"""
function euler404()

end
"""
#Exercise:

https://projecteuler.net/problem=405

# Hints: 
"""
function euler405()

end
"""
#Exercise:

https://projecteuler.net/problem=406

# Hints: 
"""
function euler406()

end
"""
#Exercise:

https://projecteuler.net/problem=407

# Hints: 
"""
function euler407()

end
"""
#Exercise:

https://projecteuler.net/problem=408

# Hints: 
"""
function euler408()

end
"""
#Exercise:

https://projecteuler.net/problem=409

# Hints: 
"""
function euler409()

end
"""
#Exercise:

https://projecteuler.net/problem=410

# Hints: 
"""
function euler410()

end
"""
#Exercise:

https://projecteuler.net/problem=411

# Hints: 
"""
function euler411()

end
"""
#Exercise:

https://projecteuler.net/problem=412

# Hints: 
"""
function euler412()

end
"""
#Exercise:

https://projecteuler.net/problem=413

# Hints: 
"""
function euler413()

end
"""
#Exercise:

https://projecteuler.net/problem=414

# Hints: 
"""
function euler414()

end
"""
#Exercise:

https://projecteuler.net/problem=415

# Hints: 
"""
function euler415()

end
"""
#Exercise:

https://projecteuler.net/problem=416

# Hints: 
"""
function euler416()

end
"""
#Exercise:

https://projecteuler.net/problem=417

# Hints: 
"""
function euler417()

end
"""
#Exercise:

https://projecteuler.net/problem=418

# Hints: 
"""
function euler418()

end
"""
#Exercise:

https://projecteuler.net/problem=419

# Hints: 
"""
function euler419()

end
"""
#Exercise:

https://projecteuler.net/problem=420

# Hints: 
"""
function euler420()

end
"""
#Exercise:

https://projecteuler.net/problem=421

# Hints: 
"""
function euler421()

end
"""
#Exercise:

https://projecteuler.net/problem=422

# Hints: 
"""
function euler422()

end
"""
#Exercise:

https://projecteuler.net/problem=423

# Hints: 
"""
function euler423()

end
"""
#Exercise:

https://projecteuler.net/problem=424

# Hints: 
"""
function euler424()

end
"""
#Exercise:

https://projecteuler.net/problem=425

# Hints: 
"""
function euler425()

end
"""
#Exercise:

https://projecteuler.net/problem=426

# Hints: 
"""
function euler426()

end
"""
#Exercise:

https://projecteuler.net/problem=427

# Hints: 
"""
function euler427()

end
"""
#Exercise:

https://projecteuler.net/problem=428

# Hints: 
"""
function euler428()

end
"""
#Exercise:

https://projecteuler.net/problem=429

# Hints: 
"""
function euler429()

end
"""
#Exercise:

https://projecteuler.net/problem=430

# Hints: 
"""
function euler430()

end
"""
#Exercise:

https://projecteuler.net/problem=431

# Hints: 
"""
function euler431()

end
"""
#Exercise:

https://projecteuler.net/problem=432

# Hints: 
"""
function euler432()

end
"""
#Exercise:

https://projecteuler.net/problem=433

# Hints: 
"""
function euler433()

end
"""
#Exercise:

https://projecteuler.net/problem=434

# Hints: 
"""
function euler434()

end
"""
#Exercise:

https://projecteuler.net/problem=435

# Hints: 
"""
function euler435()

end
"""
#Exercise:

https://projecteuler.net/problem=436

# Hints: 
"""
function euler436()

end
"""
#Exercise:

https://projecteuler.net/problem=437

# Hints: 
"""
function euler437()

end
"""
#Exercise:

https://projecteuler.net/problem=438

# Hints: 
"""
function euler438()

end
"""
#Exercise:

https://projecteuler.net/problem=439

# Hints: 
"""
function euler439()

end
"""
#Exercise:

https://projecteuler.net/problem=440

# Hints: 
"""
function euler440()

end
"""
#Exercise:

https://projecteuler.net/problem=441

# Hints: 
"""
function euler441()

end
"""
#Exercise:

https://projecteuler.net/problem=442

# Hints: 
"""
function euler442()

end
"""
#Exercise:

https://projecteuler.net/problem=443

# Hints: 
"""
function euler443()

end
"""
#Exercise:

https://projecteuler.net/problem=444

# Hints: 
"""
function euler444()

end
"""
#Exercise:

https://projecteuler.net/problem=445

# Hints: 
"""
function euler445()

end
"""
#Exercise:

https://projecteuler.net/problem=446

# Hints: 
"""
function euler446()

end
"""
#Exercise:

https://projecteuler.net/problem=447

# Hints: 
"""
function euler447()

end
"""
#Exercise:

https://projecteuler.net/problem=448

# Hints: 
"""
function euler448()

end
"""
#Exercise:

https://projecteuler.net/problem=449

# Hints: 
"""
function euler449()

end
"""
#Exercise:

https://projecteuler.net/problem=450

# Hints: 
"""
function euler450()

end
"""
#Exercise:

https://projecteuler.net/problem=451

# Hints: 
"""
function euler451()

end
"""
#Exercise:

https://projecteuler.net/problem=452

# Hints: 
"""
function euler452()

end
"""
#Exercise:

https://projecteuler.net/problem=453

# Hints: 
"""
function euler453()

end
"""
#Exercise:

https://projecteuler.net/problem=454

# Hints: 
"""
function euler454()

end
"""
#Exercise:

https://projecteuler.net/problem=455

# Hints: 
"""
function euler455()

end
"""
#Exercise:

https://projecteuler.net/problem=456

# Hints: 
"""
function euler456()

end
"""
#Exercise:

https://projecteuler.net/problem=457

# Hints: 
"""
function euler457()

end
"""
#Exercise:

https://projecteuler.net/problem=458

# Hints: 
"""
function euler458()

end
"""
#Exercise:

https://projecteuler.net/problem=459

# Hints: 
"""
function euler459()

end
"""
#Exercise:

https://projecteuler.net/problem=460

# Hints: 
"""
function euler460()

end
"""
#Exercise:

https://projecteuler.net/problem=461

# Hints: 
"""
function euler461()

end
"""
#Exercise:

https://projecteuler.net/problem=462

# Hints: 
"""
function euler462()

end
"""
#Exercise:

https://projecteuler.net/problem=463

# Hints: 
"""
function euler463()

end
"""
#Exercise:

https://projecteuler.net/problem=464

# Hints: 
"""
function euler464()

end
"""
#Exercise:

https://projecteuler.net/problem=465

# Hints: 
"""
function euler465()

end
"""
#Exercise:

https://projecteuler.net/problem=466

# Hints: 
"""
function euler466()

end
"""
#Exercise:

https://projecteuler.net/problem=467

# Hints: 
"""
function euler467()

end
"""
#Exercise:

https://projecteuler.net/problem=468

# Hints: 
"""
function euler468()

end
"""
#Exercise:

https://projecteuler.net/problem=469

# Hints: 
"""
function euler469()

end
"""
#Exercise:

https://projecteuler.net/problem=470

# Hints: 
"""
function euler470()

end
"""
#Exercise:

https://projecteuler.net/problem=471

# Hints: 
"""
function euler471()

end
"""
#Exercise:

https://projecteuler.net/problem=472

# Hints: 
"""
function euler472()

end
"""
#Exercise:

https://projecteuler.net/problem=473

# Hints: 
"""
function euler473()

end
"""
#Exercise:

https://projecteuler.net/problem=474

# Hints: 
"""
function euler474()

end
"""
#Exercise:

https://projecteuler.net/problem=475

# Hints: 
"""
function euler475()

end
"""
#Exercise:

https://projecteuler.net/problem=476

# Hints: 
"""
function euler476()

end
"""
#Exercise:

https://projecteuler.net/problem=477

# Hints: 
"""
function euler477()

end
"""
#Exercise:

https://projecteuler.net/problem=478

# Hints: 
"""
function euler478()

end
"""
#Exercise:

https://projecteuler.net/problem=479

# Hints: 
"""
function euler479()

end
"""
#Exercise:

https://projecteuler.net/problem=480

# Hints: 
"""
function euler480()

end
"""
#Exercise:

https://projecteuler.net/problem=481

# Hints: 
"""
function euler481()

end
"""
#Exercise:

https://projecteuler.net/problem=482

# Hints: 
"""
function euler482()

end
"""
#Exercise:

https://projecteuler.net/problem=483

# Hints: 
"""
function euler483()

end
"""
#Exercise:

https://projecteuler.net/problem=484

# Hints: 
"""
function euler484()

end
"""
#Exercise:

https://projecteuler.net/problem=485

# Hints: 
"""
function euler485()

end
"""
#Exercise:

https://projecteuler.net/problem=486

# Hints: 
"""
function euler486()

end
"""
#Exercise:

https://projecteuler.net/problem=487

# Hints: 
"""
function euler487()

end
"""
#Exercise:

https://projecteuler.net/problem=488

# Hints: 
"""
function euler488()

end
"""
#Exercise:

https://projecteuler.net/problem=489

# Hints: 
"""
function euler489()

end
"""
#Exercise:

https://projecteuler.net/problem=490

# Hints: 
"""
function euler490()

end
"""
#Exercise:

https://projecteuler.net/problem=491

# Hints: 
"""
function euler491()

end
"""
#Exercise:

https://projecteuler.net/problem=492

# Hints: 
"""
function euler492()

end
"""
#Exercise:

https://projecteuler.net/problem=493

# Hints: 
"""
function euler493()

end
"""
#Exercise:

https://projecteuler.net/problem=494

# Hints: 
"""
function euler494()

end
"""
#Exercise:

https://projecteuler.net/problem=495

# Hints: 
"""
function euler495()

end
"""
#Exercise:

https://projecteuler.net/problem=496

# Hints: 
"""
function euler496()

end
"""
#Exercise:

https://projecteuler.net/problem=497

# Hints: 
"""
function euler497()

end
"""
#Exercise:

https://projecteuler.net/problem=498

# Hints: 
"""
function euler498()

end
"""
#Exercise:

https://projecteuler.net/problem=499

# Hints: 
"""
function euler499()

end
"""
#Exercise:

https://projecteuler.net/problem=500

# Hints: 
"""
function euler500()

end
"""
#Exercise:

https://projecteuler.net/problem=501

# Hints: 
"""
function euler501()

end
"""
#Exercise:

https://projecteuler.net/problem=502

# Hints: 
"""
function euler502()

end
"""
#Exercise:

https://projecteuler.net/problem=503

# Hints: 
"""
function euler503()

end
"""
#Exercise:

https://projecteuler.net/problem=504

# Hints: 
"""
function euler504()

end
"""
#Exercise:

https://projecteuler.net/problem=505

# Hints: 
"""
function euler505()

end
"""
#Exercise:

https://projecteuler.net/problem=506

# Hints: 
"""
function euler506()

end
"""
#Exercise:

https://projecteuler.net/problem=507

# Hints: 
"""
function euler507()

end
"""
#Exercise:

https://projecteuler.net/problem=508

# Hints: 
"""
function euler508()

end
"""
#Exercise:

https://projecteuler.net/problem=509

# Hints: 
"""
function euler509()

end
"""
#Exercise:

https://projecteuler.net/problem=510

# Hints: 
"""
function euler510()

end
"""
#Exercise:

https://projecteuler.net/problem=511

# Hints: 
"""
function euler511()

end
"""
#Exercise:

https://projecteuler.net/problem=512

# Hints: 
"""
function euler512()

end
"""
#Exercise:

https://projecteuler.net/problem=513

# Hints: 
"""
function euler513()

end
"""
#Exercise:

https://projecteuler.net/problem=514

# Hints: 
"""
function euler514()

end
"""
#Exercise:

https://projecteuler.net/problem=515

# Hints: 
"""
function euler515()

end
"""
#Exercise:

https://projecteuler.net/problem=516

# Hints: 
"""
function euler516()

end
"""
#Exercise:

https://projecteuler.net/problem=517

# Hints: 
"""
function euler517()

end
"""
#Exercise:

https://projecteuler.net/problem=518

# Hints: 
"""
function euler518()

end
"""
#Exercise:

https://projecteuler.net/problem=519

# Hints: 
"""
function euler519()

end
"""
#Exercise:

https://projecteuler.net/problem=520

# Hints: 
"""
function euler520()

end
"""
#Exercise:

https://projecteuler.net/problem=521

# Hints: 
"""
function euler521()

end
"""
#Exercise:

https://projecteuler.net/problem=522

# Hints: 
"""
function euler522()

end
"""
#Exercise:

https://projecteuler.net/problem=523

# Hints: 
"""
function euler523()

end
"""
#Exercise:

https://projecteuler.net/problem=524

# Hints: 
"""
function euler524()

end
"""
#Exercise:

https://projecteuler.net/problem=525

# Hints: 
"""
function euler525()

end
"""
#Exercise:

https://projecteuler.net/problem=526

# Hints: 
"""
function euler526()

end
"""
#Exercise:

https://projecteuler.net/problem=527

# Hints: 
"""
function euler527()

end
"""
#Exercise:

https://projecteuler.net/problem=528

# Hints: 
"""
function euler528()

end
"""
#Exercise:

https://projecteuler.net/problem=529

# Hints: 
"""
function euler529()

end
"""
#Exercise:

https://projecteuler.net/problem=530

# Hints: 
"""
function euler530()

end
"""
#Exercise:

https://projecteuler.net/problem=531

# Hints: 
"""
function euler531()

end
"""
#Exercise:

https://projecteuler.net/problem=532

# Hints: 
"""
function euler532()

end
"""
#Exercise:

https://projecteuler.net/problem=533

# Hints: 
"""
function euler533()

end
"""
#Exercise:

https://projecteuler.net/problem=534

# Hints: 
"""
function euler534()

end
"""
#Exercise:

https://projecteuler.net/problem=535

# Hints: 
"""
function euler535()

end
"""
#Exercise:

https://projecteuler.net/problem=536

# Hints: 
"""
function euler536()

end
"""
#Exercise:

https://projecteuler.net/problem=537

# Hints: 
"""
function euler537()

end
"""
#Exercise:

https://projecteuler.net/problem=538

# Hints: 
"""
function euler538()

end
"""
#Exercise:

https://projecteuler.net/problem=539

# Hints: 
"""
function euler539()

end
"""
#Exercise:

https://projecteuler.net/problem=540

# Hints: 
"""
function euler540()

end
"""
#Exercise:

https://projecteuler.net/problem=541

# Hints: 
"""
function euler541()

end
"""
#Exercise:

https://projecteuler.net/problem=542

# Hints: 
"""
function euler542()

end
"""
#Exercise:

https://projecteuler.net/problem=543

# Hints: 
"""
function euler543()

end
"""
#Exercise:

https://projecteuler.net/problem=544

# Hints: 
"""
function euler544()

end
"""
#Exercise:

https://projecteuler.net/problem=545

# Hints: 
"""
function euler545()

end
"""
#Exercise:

https://projecteuler.net/problem=546

# Hints: 
"""
function euler546()

end
"""
#Exercise:

https://projecteuler.net/problem=547

# Hints: 
"""
function euler547()

end
"""
#Exercise:

https://projecteuler.net/problem=548

# Hints: 
"""
function euler548()

end
"""
#Exercise:

https://projecteuler.net/problem=549

# Hints: 
"""
function euler549()

end
"""
#Exercise:

https://projecteuler.net/problem=550

# Hints: 
"""
function euler550()

end
"""
#Exercise:

https://projecteuler.net/problem=551

# Hints: 
"""
function euler551()

end
"""
#Exercise:

https://projecteuler.net/problem=552

# Hints: 
"""
function euler552()

end
"""
#Exercise:

https://projecteuler.net/problem=553

# Hints: 
"""
function euler553()

end
"""
#Exercise:

https://projecteuler.net/problem=554

# Hints: 
"""
function euler554()

end
"""
#Exercise:

https://projecteuler.net/problem=555

# Hints: 
"""
function euler555()

end
"""
#Exercise:

https://projecteuler.net/problem=556

# Hints: 
"""
function euler556()

end
"""
#Exercise:

https://projecteuler.net/problem=557

# Hints: 
"""
function euler557()

end
"""
#Exercise:

https://projecteuler.net/problem=558

# Hints: 
"""
function euler558()

end
"""
#Exercise:

https://projecteuler.net/problem=559

# Hints: 
"""
function euler559()

end
"""
#Exercise:

https://projecteuler.net/problem=560

# Hints: 
"""
function euler560()

end
"""
#Exercise:

https://projecteuler.net/problem=561

# Hints: 
"""
function euler561()

end
"""
#Exercise:

https://projecteuler.net/problem=562

# Hints: 
"""
function euler562()

end
"""
#Exercise:

https://projecteuler.net/problem=563

# Hints: 
"""
function euler563()

end
"""
#Exercise:

https://projecteuler.net/problem=564

# Hints: 
"""
function euler564()

end
"""
#Exercise:

https://projecteuler.net/problem=565

# Hints: 
"""
function euler565()

end
"""
#Exercise:

https://projecteuler.net/problem=566

# Hints: 
"""
function euler566()

end
"""
#Exercise:

https://projecteuler.net/problem=567

# Hints: 
"""
function euler567()

end
"""
#Exercise:

https://projecteuler.net/problem=568

# Hints: 
"""
function euler568()

end
"""
#Exercise:

https://projecteuler.net/problem=569

# Hints: 
"""
function euler569()

end
"""
#Exercise:

https://projecteuler.net/problem=570

# Hints: 
"""
function euler570()

end
"""
#Exercise:

https://projecteuler.net/problem=571

# Hints: 
"""
function euler571()

end
"""
#Exercise:

https://projecteuler.net/problem=572

# Hints: 
"""
function euler572()

end
"""
#Exercise:

https://projecteuler.net/problem=573

# Hints: 
"""
function euler573()

end
"""
#Exercise:

https://projecteuler.net/problem=574

# Hints: 
"""
function euler574()

end
"""
#Exercise:

https://projecteuler.net/problem=575

# Hints: 
"""
function euler575()

end
"""
#Exercise:

https://projecteuler.net/problem=576

# Hints: 
"""
function euler576()

end
"""
#Exercise:

https://projecteuler.net/problem=577

# Hints: 
"""
function euler577()

end
"""
#Exercise:

https://projecteuler.net/problem=578

# Hints: 
"""
function euler578()

end
"""
#Exercise:

https://projecteuler.net/problem=579

# Hints: 
"""
function euler579()

end
"""
#Exercise:

https://projecteuler.net/problem=580

# Hints: 
"""
function euler580()

end
"""
#Exercise:

https://projecteuler.net/problem=581

# Hints: 
"""
function euler581()

end
"""
#Exercise:

https://projecteuler.net/problem=582

# Hints: 
"""
function euler582()

end
"""
#Exercise:

https://projecteuler.net/problem=583

# Hints: 
"""
function euler583()

end
"""
#Exercise:

https://projecteuler.net/problem=584

# Hints: 
"""
function euler584()

end
"""
#Exercise:

https://projecteuler.net/problem=585

# Hints: 
"""
function euler585()

end
"""
#Exercise:

https://projecteuler.net/problem=586

# Hints: 
"""
function euler586()

end
"""
#Exercise:

https://projecteuler.net/problem=587

# Hints: 
"""
function euler587()

end
"""
#Exercise:

https://projecteuler.net/problem=588

# Hints: 
"""
function euler588()

end
"""
#Exercise:

https://projecteuler.net/problem=589

# Hints: 
"""
function euler589()

end
"""
#Exercise:

https://projecteuler.net/problem=590

# Hints: 
"""
function euler590()

end
"""
#Exercise:

https://projecteuler.net/problem=591

# Hints: 
"""
function euler591()

end
"""
#Exercise:

https://projecteuler.net/problem=592

# Hints: 
"""
function euler592()

end
"""
#Exercise:

https://projecteuler.net/problem=593

# Hints: 
"""
function euler593()

end
"""
#Exercise:

https://projecteuler.net/problem=594

# Hints: 
"""
function euler594()

end
"""
#Exercise:

https://projecteuler.net/problem=595

# Hints: 
"""
function euler595()

end
"""
#Exercise:

https://projecteuler.net/problem=596

# Hints: 
"""
function euler596()

end
"""
#Exercise:

https://projecteuler.net/problem=597

# Hints: 
"""
function euler597()

end
"""
#Exercise:

https://projecteuler.net/problem=598

# Hints: 
"""
function euler598()

end
"""
#Exercise:

https://projecteuler.net/problem=599

# Hints: 
"""
function euler599()

end
"""
#Exercise:

https://projecteuler.net/problem=600

# Hints: 
"""
function euler600()

end
"""
#Exercise:

https://projecteuler.net/problem=601

# Hints: 
"""
function euler601()

end
"""
#Exercise:

https://projecteuler.net/problem=602

# Hints: 
"""
function euler602()

end
"""
#Exercise:

https://projecteuler.net/problem=603

# Hints: 
"""
function euler603()

end
"""
#Exercise:

https://projecteuler.net/problem=604

# Hints: 
"""
function euler604()

end
"""
#Exercise:

https://projecteuler.net/problem=605

# Hints: 
"""
function euler605()

end
"""
#Exercise:

https://projecteuler.net/problem=606

# Hints: 
"""
function euler606()

end
"""
#Exercise:

https://projecteuler.net/problem=607

# Hints: 
"""
function euler607()

end
"""
#Exercise:

https://projecteuler.net/problem=608

# Hints: 
"""
function euler608()

end
"""
#Exercise:

https://projecteuler.net/problem=609

# Hints: 
"""
function euler609()

end
"""
#Exercise:

https://projecteuler.net/problem=610

# Hints: 
"""
function euler610()

end
"""
#Exercise:

https://projecteuler.net/problem=611

# Hints: 
"""
function euler611()

end
"""
#Exercise:

https://projecteuler.net/problem=612

# Hints: 
"""
function euler612()

end
"""
#Exercise:

https://projecteuler.net/problem=613

# Hints: 
"""
function euler613()

end
"""
#Exercise:

https://projecteuler.net/problem=614

# Hints: 
"""
function euler614()

end
"""
#Exercise:

https://projecteuler.net/problem=615

# Hints: 
"""
function euler615()

end
"""
#Exercise:

https://projecteuler.net/problem=616

# Hints: 
"""
function euler616()

end
"""
#Exercise:

https://projecteuler.net/problem=617

# Hints: 
"""
function euler617()

end
"""
#Exercise:

https://projecteuler.net/problem=618

# Hints: 
"""
function euler618()

end
"""
#Exercise:

https://projecteuler.net/problem=619

# Hints: 
"""
function euler619()

end
"""
#Exercise:

https://projecteuler.net/problem=620

# Hints: 
"""
function euler620()

end
"""
#Exercise:

https://projecteuler.net/problem=621

# Hints: 
"""
function euler621()

end
"""
#Exercise:

https://projecteuler.net/problem=622

# Hints: 
"""
function euler622()

end
"""
#Exercise:

https://projecteuler.net/problem=623

# Hints: 
"""
function euler623()

end
"""
#Exercise:

https://projecteuler.net/problem=624

# Hints: 
"""
function euler624()

end
"""
#Exercise:

https://projecteuler.net/problem=625

# Hints: 
"""
function euler625()

end
"""
#Exercise:

https://projecteuler.net/problem=626

# Hints: 
"""
function euler626()

end
"""
#Exercise:

https://projecteuler.net/problem=627

# Hints: 
"""
function euler627()

end
"""
#Exercise:

https://projecteuler.net/problem=628

# Hints: 
"""
function euler628()

end
"""
#Exercise:

https://projecteuler.net/problem=629

# Hints: 
"""
function euler629()

end
"""
#Exercise:

https://projecteuler.net/problem=630

# Hints: 
"""
function euler630()

end
"""
#Exercise:

https://projecteuler.net/problem=631

# Hints: 
"""
function euler631()

end
"""
#Exercise:

https://projecteuler.net/problem=632

# Hints: 
"""
function euler632()

end
"""
#Exercise:

https://projecteuler.net/problem=633

# Hints: 
"""
function euler633()

end
"""
#Exercise:

https://projecteuler.net/problem=634

# Hints: 
"""
function euler634()

end
"""
#Exercise:

https://projecteuler.net/problem=635

# Hints: 
"""
function euler635()

end
"""
#Exercise:

https://projecteuler.net/problem=636

# Hints: 
"""
function euler636()

end
"""
#Exercise:

https://projecteuler.net/problem=637

# Hints: 
"""
function euler637()

end
"""
#Exercise:

https://projecteuler.net/problem=638

# Hints: 
"""
function euler638()

end
"""
#Exercise:

https://projecteuler.net/problem=639

# Hints: 
"""
function euler639()

end
"""
#Exercise:

https://projecteuler.net/problem=640

# Hints: 
"""
function euler640()

end
"""
#Exercise:

https://projecteuler.net/problem=641

# Hints: 
"""
function euler641()

end
"""
#Exercise:

https://projecteuler.net/problem=642

# Hints: 
"""
function euler642()

end
"""
#Exercise:

https://projecteuler.net/problem=643

# Hints: 
"""
function euler643()

end
"""
#Exercise:

https://projecteuler.net/problem=644

# Hints: 
"""
function euler644()

end
"""
#Exercise:

https://projecteuler.net/problem=645

# Hints: 
"""
function euler645()

end
"""
#Exercise:

https://projecteuler.net/problem=646

# Hints: 
"""
function euler646()

end
"""
#Exercise:

https://projecteuler.net/problem=647

# Hints: 
"""
function euler647()

end
"""
#Exercise:

https://projecteuler.net/problem=648

# Hints: 
"""
function euler648()

end
"""
#Exercise:

https://projecteuler.net/problem=649

# Hints: 
"""
function euler649()

end
"""
#Exercise:

https://projecteuler.net/problem=650

# Hints: 
"""
function euler650()

end
"""
#Exercise:

https://projecteuler.net/problem=651

# Hints: 
"""
function euler651()

end
"""
#Exercise:

https://projecteuler.net/problem=652

# Hints: 
"""
function euler652()

end
"""
#Exercise:

https://projecteuler.net/problem=653

# Hints: 
"""
function euler653()

end
"""
#Exercise:

https://projecteuler.net/problem=654

# Hints: 
"""
function euler654()

end
"""
#Exercise:

https://projecteuler.net/problem=655

# Hints: 
"""
function euler655()

end
"""
#Exercise:

https://projecteuler.net/problem=656

# Hints: 
"""
function euler656()

end
"""
#Exercise:

https://projecteuler.net/problem=657

# Hints: 
"""
function euler657()

end
"""
#Exercise:

https://projecteuler.net/problem=658

# Hints: 
"""
function euler658()

end
"""
#Exercise:

https://projecteuler.net/problem=659

# Hints: 
"""
function euler659()

end
"""
#Exercise:

https://projecteuler.net/problem=660

# Hints: 
"""
function euler660()

end
"""
#Exercise:

https://projecteuler.net/problem=661

# Hints: 
"""
function euler661()

end
"""
#Exercise:

https://projecteuler.net/problem=662

# Hints: 
"""
function euler662()

end
"""
#Exercise:

https://projecteuler.net/problem=663

# Hints: 
"""
function euler663()

end
"""
#Exercise:

https://projecteuler.net/problem=664

# Hints: 
"""
function euler664()

end
"""
#Exercise:

https://projecteuler.net/problem=665

# Hints: 
"""
function euler665()

end
"""
#Exercise:

https://projecteuler.net/problem=666

# Hints: 
"""
function euler666()

end
"""
#Exercise:

https://projecteuler.net/problem=667

# Hints: 
"""
function euler667()

end
"""
#Exercise:

https://projecteuler.net/problem=668

# Hints: 
"""
function euler668()

end
"""
#Exercise:

https://projecteuler.net/problem=669

# Hints: 
"""
function euler669()

end
"""
#Exercise:

https://projecteuler.net/problem=670

# Hints: 
"""
function euler670()

end
"""
#Exercise:

https://projecteuler.net/problem=671

# Hints: 
"""
function euler671()

end
"""
#Exercise:

https://projecteuler.net/problem=672

# Hints: 
"""
function euler672()

end
"""
#Exercise:

https://projecteuler.net/problem=673

# Hints: 
"""
function euler673()

end
"""
#Exercise:

https://projecteuler.net/problem=674

# Hints: 
"""
function euler674()

end
"""
#Exercise:

https://projecteuler.net/problem=675

# Hints: 
"""
function euler675()

end
"""
#Exercise:

https://projecteuler.net/problem=676

# Hints: 
"""
function euler676()

end
"""
#Exercise:

https://projecteuler.net/problem=677

# Hints: 
"""
function euler677()

end
"""
#Exercise:

https://projecteuler.net/problem=678

# Hints: 
"""
function euler678()

end
"""
#Exercise:

https://projecteuler.net/problem=679

# Hints: 
"""
function euler679()

end
"""
#Exercise:

https://projecteuler.net/problem=680

# Hints: 
"""
function euler680()

end
"""
#Exercise:

https://projecteuler.net/problem=681

# Hints: 
"""
function euler681()

end
"""
#Exercise:

https://projecteuler.net/problem=682

# Hints: 
"""
function euler682()

end
"""
#Exercise:

https://projecteuler.net/problem=683

# Hints: 
"""
function euler683()

end
"""
#Exercise:

https://projecteuler.net/problem=684

# Hints: 
"""
function euler684()

end
"""
#Exercise:

https://projecteuler.net/problem=685

# Hints: 
"""
function euler685()

end
"""
#Exercise:

https://projecteuler.net/problem=686

# Hints: 
"""
function euler686()

end
"""
#Exercise:

https://projecteuler.net/problem=687

# Hints: 
"""
function euler687()

end
"""
#Exercise:

https://projecteuler.net/problem=688

# Hints: 
"""
function euler688()

end
"""
#Exercise:

https://projecteuler.net/problem=689

# Hints: 
"""
function euler689()

end
"""
#Exercise:

https://projecteuler.net/problem=690

# Hints: 
"""
function euler690()

end
"""
#Exercise:

https://projecteuler.net/problem=691

# Hints: 
"""
function euler691()

end
"""
#Exercise:

https://projecteuler.net/problem=692

# Hints: 
"""
function euler692()

end
"""
#Exercise:

https://projecteuler.net/problem=693

# Hints: 
"""
function euler693()

end
"""
#Exercise:

https://projecteuler.net/problem=694

# Hints: 
"""
function euler694()

end
"""
#Exercise:

https://projecteuler.net/problem=695

# Hints: 
"""
function euler695()

end
"""
#Exercise:

https://projecteuler.net/problem=696

# Hints: 
"""
function euler696()

end
"""
#Exercise:

https://projecteuler.net/problem=697

# Hints: 
"""
function euler697()

end
"""
#Exercise:

https://projecteuler.net/problem=698

# Hints: 
"""
function euler698()

end
"""
#Exercise:

https://projecteuler.net/problem=699

# Hints: 
"""
function euler699()

end
"""
#Exercise:

https://projecteuler.net/problem=700

# Hints: 
"""
function euler700()

end
"""
#Exercise:

https://projecteuler.net/problem=701

# Hints: 
"""
function euler701()

end
"""
#Exercise:

https://projecteuler.net/problem=702

# Hints: 
"""
function euler702()

end
"""
#Exercise:

https://projecteuler.net/problem=703

# Hints: 
"""
function euler703()

end
"""
#Exercise:

https://projecteuler.net/problem=704

# Hints: 
"""
function euler704()

end
"""
#Exercise:

https://projecteuler.net/problem=705

# Hints: 
"""
function euler705()

end
"""
#Exercise:

https://projecteuler.net/problem=706

# Hints: 
"""
function euler706()

end
"""
#Exercise:

https://projecteuler.net/problem=707

# Hints: 
"""
function euler707()

end
"""
#Exercise:

https://projecteuler.net/problem=708

# Hints: 
"""
function euler708()

end
"""
#Exercise:

https://projecteuler.net/problem=709

# Hints: 
"""
function euler709()

end
"""
#Exercise:

https://projecteuler.net/problem=710

# Hints: 
"""
function euler710()

end
"""
#Exercise:

https://projecteuler.net/problem=711

# Hints: 
"""
function euler711()

end
"""
#Exercise:

https://projecteuler.net/problem=712

# Hints: 
"""
function euler712()

end
"""
#Exercise:

https://projecteuler.net/problem=713

# Hints: 
"""
function euler713()

end
"""
#Exercise:

https://projecteuler.net/problem=714

# Hints: 
"""
function euler714()

end
"""
#Exercise:

https://projecteuler.net/problem=715

# Hints: 
"""
function euler715()

end
"""
#Exercise:

https://projecteuler.net/problem=716

# Hints: 
"""
function euler716()

end
"""
#Exercise:

https://projecteuler.net/problem=717

# Hints: 
"""
function euler717()

end
"""
#Exercise:

https://projecteuler.net/problem=718

# Hints: 
"""
function euler718()

end
"""
#Exercise:

https://projecteuler.net/problem=719

# Hints: 
"""
function euler719()

end
"""
#Exercise:

https://projecteuler.net/problem=720

# Hints: 
"""
function euler720()

end
"""
#Exercise:

https://projecteuler.net/problem=721

# Hints: 
"""
function euler721()

end
"""
#Exercise:

https://projecteuler.net/problem=722

# Hints: 
"""
function euler722()

end
"""
#Exercise:

https://projecteuler.net/problem=723

# Hints: 
"""
function euler723()

end
"""
#Exercise:

https://projecteuler.net/problem=724

# Hints: 
"""
function euler724()

end
"""
#Exercise:

https://projecteuler.net/problem=725

# Hints: 
"""
function euler725()

end
"""
#Exercise:

https://projecteuler.net/problem=726

# Hints: 
"""
function euler726()

end
"""
#Exercise:

https://projecteuler.net/problem=727

# Hints: 
"""
function euler727()

end
"""
#Exercise:

https://projecteuler.net/problem=728

# Hints: 
"""
function euler728()

end
"""
#Exercise:

https://projecteuler.net/problem=729

# Hints: 
"""
function euler729()

end
"""
#Exercise:

https://projecteuler.net/problem=730

# Hints: 
"""
function euler730()

end
"""
#Exercise:

https://projecteuler.net/problem=731

# Hints: 
"""
function euler731()

end
"""
#Exercise:

https://projecteuler.net/problem=732

# Hints: 
"""
function euler732()

end
"""
#Exercise:

https://projecteuler.net/problem=733

# Hints: 
"""
function euler733()

end
"""
#Exercise:

https://projecteuler.net/problem=734

# Hints: 
"""
function euler734()

end
"""
#Exercise:

https://projecteuler.net/problem=735

# Hints: 
"""
function euler735()

end
"""
#Exercise:

https://projecteuler.net/problem=736

# Hints: 
"""
function euler736()

end
"""
#Exercise:

https://projecteuler.net/problem=737

# Hints: 
"""
function euler737()

end
"""
#Exercise:

https://projecteuler.net/problem=738

# Hints: 
"""
function euler738()

end
"""
#Exercise:

https://projecteuler.net/problem=739

# Hints: 
"""
function euler739()

end
"""
#Exercise:

https://projecteuler.net/problem=740

# Hints: 
"""
function euler740()

end
"""
#Exercise:

https://projecteuler.net/problem=741

# Hints: 
"""
function euler741()

end
"""
#Exercise:

https://projecteuler.net/problem=742

# Hints: 
"""
function euler742()

end
"""
#Exercise:

https://projecteuler.net/problem=743

# Hints: 
"""
function euler743()

end
"""
#Exercise:

https://projecteuler.net/problem=744

# Hints: 
"""
function euler744()

end
"""
#Exercise:

https://projecteuler.net/problem=745

# Hints: 
"""
function euler745()

end
"""
#Exercise:

https://projecteuler.net/problem=746

# Hints: 
"""
function euler746()

end
"""
#Exercise:

https://projecteuler.net/problem=747

# Hints: 
"""
function euler747()

end
"""
#Exercise:

https://projecteuler.net/problem=748

# Hints: 
"""
function euler748()

end
"""
#Exercise:

https://projecteuler.net/problem=749

# Hints: 
"""
function euler749()

end
"""
#Exercise:

https://projecteuler.net/problem=750

# Hints: 
"""
function euler750()

end
"""
#Exercise:

https://projecteuler.net/problem=751

# Hints: 
"""
function euler751()

end
"""
#Exercise:

https://projecteuler.net/problem=752

# Hints: 
"""
function euler752()

end
"""
#Exercise:

https://projecteuler.net/problem=753

# Hints: 
"""
function euler753()

end
"""
#Exercise:

https://projecteuler.net/problem=754

# Hints: 
"""
function euler754()

end
"""
#Exercise:

https://projecteuler.net/problem=755

# Hints: 
"""
function euler755()

end
"""
#Exercise:

https://projecteuler.net/problem=756

# Hints: 
"""
function euler756()

end
"""
#Exercise:

https://projecteuler.net/problem=757

# Hints: 
"""
function euler757()

end
"""
#Exercise:

https://projecteuler.net/problem=758

# Hints: 
"""
function euler758()

end
"""
#Exercise:

https://projecteuler.net/problem=759

# Hints: 
"""
function euler759()

end
"""
#Exercise:

https://projecteuler.net/problem=760

# Hints: 
"""
function euler760()

end
"""
#Exercise:

https://projecteuler.net/problem=761

# Hints: 
"""
function euler761()

end
"""
#Exercise:

https://projecteuler.net/problem=762

# Hints: 
"""
function euler762()

end
"""
#Exercise:

https://projecteuler.net/problem=763

# Hints: 
"""
function euler763()

end
"""
#Exercise:

https://projecteuler.net/problem=764

# Hints: 
"""
function euler764()

end
"""
#Exercise:

https://projecteuler.net/problem=765

# Hints: 
"""
function euler765()

end
"""
#Exercise:

https://projecteuler.net/problem=766

# Hints: 
"""
function euler766()

end
"""
#Exercise:

https://projecteuler.net/problem=767

# Hints: 
"""
function euler767()

end
"""
#Exercise:

https://projecteuler.net/problem=768

# Hints: 
"""
function euler768()

end
"""
#Exercise:

https://projecteuler.net/problem=769

# Hints: 
"""
function euler769()

end
"""
#Exercise:

https://projecteuler.net/problem=770

# Hints: 
"""
function euler770()

end
"""
#Exercise:

https://projecteuler.net/problem=771

# Hints: 
"""
function euler771()

end
"""
#Exercise:

https://projecteuler.net/problem=772

# Hints: 
"""
function euler772()

end
"""
#Exercise:

https://projecteuler.net/problem=773

# Hints: 
"""
function euler773()

end
"""
#Exercise:

https://projecteuler.net/problem=774

# Hints: 
"""
function euler774()

end
"""
#Exercise:

https://projecteuler.net/problem=775

# Hints: 
"""
function euler775()

end
"""
#Exercise:

https://projecteuler.net/problem=776

# Hints: 
"""
function euler776()

end
"""
#Exercise:

https://projecteuler.net/problem=777

# Hints: 
"""
function euler777()

end
"""
#Exercise:

https://projecteuler.net/problem=778

# Hints: 
"""
function euler778()

end
"""
#Exercise:

https://projecteuler.net/problem=779

# Hints: 
"""
function euler779()

end
"""
#Exercise:

https://projecteuler.net/problem=780

# Hints: 
"""
function euler780()

end
"""
#Exercise:

https://projecteuler.net/problem=781

# Hints: 
"""
function euler781()

end
"""
#Exercise:

https://projecteuler.net/problem=782

# Hints: 
"""
function euler782()

end
"""
#Exercise:

https://projecteuler.net/problem=783

# Hints: 
"""
function euler783()

end
"""
#Exercise:

https://projecteuler.net/problem=784

# Hints: 
"""
function euler784()

end
"""
#Exercise:

https://projecteuler.net/problem=785

# Hints: 
"""
function euler785()

end
"""
#Exercise:

https://projecteuler.net/problem=786

# Hints: 
"""
function euler786()

end
"""
#Exercise:

https://projecteuler.net/problem=787

# Hints: 
"""
function euler787()

end
"""
#Exercise:

https://projecteuler.net/problem=788

# Hints: 
"""
function euler788()

end
"""
#Exercise:

https://projecteuler.net/problem=789

# Hints: 
"""
function euler789()

end
"""
#Exercise:

https://projecteuler.net/problem=790

# Hints: 
"""
function euler790()

end
"""
#Exercise:

https://projecteuler.net/problem=791

# Hints: 
"""
function euler791()

end
"""
#Exercise:

https://projecteuler.net/problem=792

# Hints: 
"""
function euler792()

end
"""
#Exercise:

https://projecteuler.net/problem=793

# Hints: 
"""
function euler793()

end
"""
#Exercise:

https://projecteuler.net/problem=794

# Hints: 
"""
function euler794()

end
"""
#Exercise:

https://projecteuler.net/problem=795

# Hints: 
"""
function euler795()

end
"""
#Exercise:

https://projecteuler.net/problem=796

# Hints: 
"""
function euler796()

end
"""
#Exercise:

https://projecteuler.net/problem=797

# Hints: 
"""
function euler797()

end
"""
#Exercise:

https://projecteuler.net/problem=798

# Hints: 
"""
function euler798()

end
"""
#Exercise:

https://projecteuler.net/problem=799

# Hints: 
"""
function euler799()

end
"""
#Exercise:

https://projecteuler.net/problem=800

# Hints: 
"""
function euler800()

end
"""
#Exercise:

https://projecteuler.net/problem=801

# Hints: 
"""
function euler801()

end
"""
#Exercise:

https://projecteuler.net/problem=802

# Hints: 
"""
function euler802()

end
"""
#Exercise:

https://projecteuler.net/problem=803

# Hints: 
"""
function euler803()

end
"""
#Exercise:

https://projecteuler.net/problem=804

# Hints: 
"""
function euler804()

end
"""
#Exercise:

https://projecteuler.net/problem=805

# Hints: 
"""
function euler805()

end
"""
#Exercise:

https://projecteuler.net/problem=806

# Hints: 
"""
function euler806()

end
"""
#Exercise:

https://projecteuler.net/problem=807

# Hints: 
"""
function euler807()

end
"""
#Exercise:

https://projecteuler.net/problem=808

# Hints: 
"""
function euler808()

end
"""
#Exercise:

https://projecteuler.net/problem=809

# Hints: 
"""
function euler809()

end
"""
#Exercise:

https://projecteuler.net/problem=810

# Hints: 
"""
function euler810()

end
"""
#Exercise:

https://projecteuler.net/problem=811

# Hints: 
"""
function euler811()

end
"""
#Exercise:

https://projecteuler.net/problem=812

# Hints: 
"""
function euler812()

end
"""
#Exercise:

https://projecteuler.net/problem=813

# Hints: 
"""
function euler813()

end
"""
#Exercise:

https://projecteuler.net/problem=814

# Hints: 
"""
function euler814()

end
"""
#Exercise:

https://projecteuler.net/problem=815

# Hints: 
"""
function euler815()

end
"""
#Exercise:

https://projecteuler.net/problem=816

# Hints: 
"""
function euler816()

end
"""
#Exercise:

https://projecteuler.net/problem=817

# Hints: 
"""
function euler817()

end
"""
#Exercise:

https://projecteuler.net/problem=818

# Hints: 
"""
function euler818()

end
"""
#Exercise:

https://projecteuler.net/problem=819

# Hints: 
"""
function euler819()

end
"""
#Exercise:

https://projecteuler.net/problem=820

# Hints: 
"""
function euler820()

end
"""
#Exercise:

https://projecteuler.net/problem=821

# Hints: 
"""
function euler821()

end
"""
#Exercise:

https://projecteuler.net/problem=822

# Hints: 
"""
function euler822()

end
"""
#Exercise:

https://projecteuler.net/problem=823

# Hints: 
"""
function euler823()

end
"""
#Exercise:

https://projecteuler.net/problem=824

# Hints: 
"""
function euler824()

end
"""
#Exercise:

https://projecteuler.net/problem=825

# Hints: 
"""
function euler825()

end
"""
#Exercise:

https://projecteuler.net/problem=826

# Hints: 
"""
function euler826()

end
"""
#Exercise:

https://projecteuler.net/problem=827

# Hints: 
"""
function euler827()

end
"""
#Exercise:

https://projecteuler.net/problem=828

# Hints: 
"""
function euler828()

end
"""
#Exercise:

https://projecteuler.net/problem=829

# Hints: 
"""
function euler829()

end
"""
#Exercise:

https://projecteuler.net/problem=830

# Hints: 
"""
function euler830()

end
"""
#Exercise:

https://projecteuler.net/problem=831

# Hints: 
"""
function euler831()

end
"""
#Exercise:

https://projecteuler.net/problem=832

# Hints: 
"""
function euler832()

end
"""
#Exercise:

https://projecteuler.net/problem=833

# Hints: 
"""
function euler833()

end
"""
#Exercise:

https://projecteuler.net/problem=834

# Hints: 
"""
function euler834()

end
"""
#Exercise:

https://projecteuler.net/problem=835

# Hints: 
"""
function euler835()

end
"""
#Exercise:

https://projecteuler.net/problem=836

# Hints: 
"""
function euler836()

end
"""
#Exercise:

https://projecteuler.net/problem=837

# Hints: 
"""
function euler837()

end
"""
#Exercise:

https://projecteuler.net/problem=838

# Hints: 
"""
function euler838()

end
"""
#Exercise:

https://projecteuler.net/problem=839

# Hints: 
"""
function euler839()

end
"""
#Exercise:

https://projecteuler.net/problem=840

# Hints: 
"""
function euler840()

end
"""
#Exercise:

https://projecteuler.net/problem=841

# Hints: 
"""
function euler841()

end
"""
#Exercise:

https://projecteuler.net/problem=842

# Hints: 
"""
function euler842()

end
"""
#Exercise:

https://projecteuler.net/problem=843

# Hints: 
"""
function euler843()

end
"""
#Exercise:

https://projecteuler.net/problem=844

# Hints: 
"""
function euler844()

end
"""
#Exercise:

https://projecteuler.net/problem=845

# Hints: 
"""
function euler845()

end
"""
#Exercise:

https://projecteuler.net/problem=846

# Hints: 
"""
function euler846()

end
"""
#Exercise:

https://projecteuler.net/problem=847

# Hints: 
"""
function euler847()

end
"""
#Exercise:

https://projecteuler.net/problem=848

# Hints: 
"""
function euler848()

end
"""
#Exercise:

https://projecteuler.net/problem=849

# Hints: 
"""
function euler849()

end
"""
#Exercise:

https://projecteuler.net/problem=850

# Hints: 
"""
function euler850()

end
"""
#Exercise:

https://projecteuler.net/problem=851

# Hints: 
"""
function euler851()

end
"""
#Exercise:

https://projecteuler.net/problem=852

# Hints: 
"""
function euler852()

end
"""
#Exercise:

https://projecteuler.net/problem=853

# Hints: 
"""
function euler853()

end
"""
#Exercise:

https://projecteuler.net/problem=854

# Hints: 
"""
function euler854()

end
"""
#Exercise:

https://projecteuler.net/problem=855

# Hints: 
"""
function euler855()

end
"""
#Exercise:

https://projecteuler.net/problem=856

# Hints: 
"""
function euler856()

end
"""
#Exercise:

https://projecteuler.net/problem=857

# Hints: 
"""
function euler857()

end

end # module Euler
