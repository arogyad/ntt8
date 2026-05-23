def brv(x, n):
  """ Reverses a n-bit number """
  return int(''.join(reversed(bin(x)[2:].zfill(n))), 2)

import math

def ntt_iter(a, gen=9, modulus=17):
  deg_d = len(a)

  # Start with stride = 1.
  stride = 1

  # Shuffle the input array in bit-reversal order.
  nbits = int(math.log2(deg_d))
  res = [a[brv(i, nbits)] for i in range(deg_d)]

  # Pre-compute the generators used in different stages of the recursion.
  gens = [pow(gen, pow(2, i), modulus) for i in range(nbits)]
  # The first layer uses the lowest (2nd) root of unity, hence the last one.
  gen_ptr = len(gens) - 1

  # Iterate until the last layer.
  while stride < deg_d:
    # For each stride, iterate over all N//(stride*2) slices.
    for start in range(0, deg_d, stride * 2):
      # For each pair of the CT butterfly operation.
      for i in range(start, start + stride):
        # Compute the omega multiplier. Here j = i - start.
        zp = pow(gens[gen_ptr], i - start, modulus)

        # Cooley-Tukey butterfly.
        a = res[i]
        b = res[i+stride]
        res[i] = (a + zp * b) % modulus
        res[i+stride] = (a - zp * b) % modulus

    # Grow the stride.
    stride <<= 1
    # Move to the next root of unity.
    gen_ptr -= 1

  return res
 
a_ntt_iter = ntt_iter([3, 5, 0, 16, 7, 9, 2, 11])
print(a_ntt_iter)