.section .text
.globl uintgemm

# a0 = K
# a1 = C
# a2 = B
# a3 = A
# a4 = ldc
# a5 = ldb
# a6 = lda
uintgemm:
    mzero m0                # Reset accumulator
    li t0, 0                # k = 0
    li t1, 16               # Register row size in bytes
    sll a0, a0, 2           # K *= sizeof(float)
loop_int:
    add t2, a3, t0          # A + k
    mls m20, (t2), a6
    add t3, a2, t0          # B + k
    mls m25, (t3), a5
    mmac m0, m20, m25
    add t0, t0, t1          # k += 4
    blt t0, a0, loop_int    # if k >= K, exit loop
end_loop_int:
    mss m0, (a1), a4
    srl a0, a0, 2           # K /= sizeof(float)
    ret
