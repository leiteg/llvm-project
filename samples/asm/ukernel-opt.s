.section .text
.globl uintgemm_4x6


# a0 = K
# a1 = C
# a2 = B
# a3 = A
# a4 = ldc
# a5 = ldb
# a6 = lda 
# s0 = A pointer 
# s1 = B pointer
# t5 = A aux pointer
# t6 = B aux pointer
uintgemm_4x6:  
    addi sp, sp, -16
    sd s0, 0(sp)
    sd s1, 8(sp)

    li t0, 4                                       # Register row size
    sll t1, t0, 2                                  # Register row size in bytes
    
    mul t3, t0, a5                                 # t3 = ldb * Register size 
    mul t4, t0, a6                                 # t4 = lda * Register size 

    # Reset the accumulators
    mzero m0
    mzero m1
    mzero m2
    mzero m3
    mzero m4
    mzero m5
    mzero m6
    mzero m7
    mzero m8
    mzero m9
    mzero m10
    mzero m11
    mzero m12
    mzero m13
    mzero m14
    mzero m15
    mzero m16
    mzero m17
    mzero m18
    mzero m19
    mzero m20
    mzero m21
    mzero m22
    mzero m23

    mv s0, a3                                       # s0 = A                           
    mls m24, (s0), a6
    add t5, s0, t4                                  # A + lda * Register size 
    mls m25, (t5), a6
    mv s1, a2                                       # s1 = B       
    mls m28, (s1), a5
    add t6, s1, t3                                  # t6 = B + Collumn
    mls m29, (t6), a5
    add t2, zero, t0                                # k = Register size
    beq t2, a0, end_loop_4x6_int

loop_4x6_int:

    mmac m0, m24, m28
    add t6, t6, t3                                  # B + Register size
    mls m30, (t6), a5
    mmac m1, m24, m29
    mmac m6, m25, m28
    add t5, t5, t4                                  # A + lda * Register size 
    mls m26, (t5), a6
    mmac m7, m25, m29
    mmac m2, m24, m30
    add t5, t5, t4                                  # A + lda * Register size 
    mls m27, (t5), a6
    mmac m8, m25, m30
    mmac m12, m26, m28
    add t6, t6, t3                                  # B + Register size
    mls m31, (t6), a5
    mmac m18, m27, m28
    mmac m13, m26, m29
    mmac m14, m26, m30
    add t6, t6, t3                                  # B + Register size
    mls m28, (t6), a5
    mmac m19, m27, m29
    mmac m3, m24, m31
    mmac m9, m25, m31
    add t6, t6, t3                                  # B + Register size
    mls m29, (t6), a5
    mmac m15, m26, m31
    mmac m4, m24, m28
    mmac m5, m24, m29
    mmac m11, m25, m29
    add s0, s0, t1                                  # s0 = A + Reg_size         // Prefetch
    mls m24, (s0), a6
    mmac m10, m25, m28
    mmac m16, m26, m28
    add t5, s0, t4                                  # A + lda * Register size   // Prefetch
    mls m25, (t5), a6
    mmac m22, m27, m28
    mmac m17, m26, m29
    add s1, s1, t1                                  # s1 = B + Reg_size         // Prefetch
    mls m28, (s1), a5
    mmac m23, m27, m29
    mmac m20, m27, m30
    add t6, s1, t3                                  # t6 = B + Collumn          // Prefetch
    mls m29, (t6), a5
    mmac m21, m27, m31
    add t2, t2, t0                                  # k += Register size
    blt t2, a0, loop_4x6_int                            # if k >= K, exit loop

end_loop_4x6_int:

    mmac m0, m24, m28
    add t6, t6, t3                                  # B + Register size
    mls m30, (t6), a5
    mmac m1, m24, m29
    mmac m6, m25, m28
    add t5, t5, t4                                  # A + lda * Register size 
    mls m26, (t5), a6
    mmac m7, m25, m29
    mmac m2, m24, m30
    add t5, t5, t4                                  # A + lda * Register size 
    mls m27, (t5), a6
    mmac m8, m25, m30
    mmac m12, m26, m28
    add t6, t6, t3                                  # B + Register size
    mls m31, (t6), a5
    mmac m18, m27, m28
    mmac m13, m26, m29
    mmac m14, m26, m30
    add t6, t6, t3                                  # B + Register size
    mls m28, (t6), a5
    mmac m19, m27, m29
    mmac m3, m24, m31
    mmac m9, m25, m31
    add t6, t6, t3                                  # B + Register size
    mls m29, (t6), a5
    mmac m15, m26, m31
    mmac m4, m24, m28
    mmac m5, m24, m29
    mmac m11, m25, m29
    mmac m10, m25, m28
    mmac m16, m26, m28
    mmac m22, m27, m28
    mmac m17, m26, m29
    mmac m23, m27, m29
    mmac m20, m27, m30
    mmac m21, m27, m31
    mul t3, t0, a4                                  # t3 = ldc * Register size
    # C_ptr = C
    mss m0, (a1), a4
    add t0, a1, t1                                  # C_ptr = C + Reg_size
    mss m1, (t0), a4
    add t0, t0, t1                                  # C_ptr = C + 2 * Reg_size
    mss m2, (t0), a4
    add t0, t0, t1                                  # C_ptr = C + 3 * Reg_size
    mss m3, (t0), a4
    add t0, t0, t1                                  # C_ptr = C + 4 * Reg_size
    mss m4, (t0), a4
    add t0, t0, t1                                  # C_ptr = C + 5 * Reg_size
    mss m5, (t0), a4
    # C_ptr = C + Collumn
    add t2, a1, t3                                  # C_ptr = C + Collumn
    mss m6, (t2), a4
    add t0, t2, t1                                  
    mss m7, (t0), a4
    add t0, t0, t1
    mss m8, (t0), a4
    add t0, t0, t1
    mss m9, (t0), a4
    add t0, t0, t1
    mss m10, (t0), a4
    add t0, t0, t1
    mss m11, (t0), a4
    # C_ptr = C + 2 * Collumn
    add t2, t2, t3                                  
    mss m12, (t2), a4
    add t0, t2, t1                                  
    mss m13, (t0), a4
    add t0, t0, t1
    mss m14, (t0), a4
    add t0, t0, t1
    mss m15, (t0), a4
    add t0, t0, t1
    mss m16, (t0), a4
    add t0, t0, t1
    mss m17, (t0), a4
    # C_ptr = C + 3 * Collumn
    add t2, t2, t3                                  
    mss m18, (t2), a4
    add t0, t2, t1                                  
    mss m19, (t0), a4
    add t0, t0, t1
    mss m20, (t0), a4
    add t0, t0, t1
    mss m21, (t0), a4
    add t0, t0, t1
    mss m22, (t0), a4
    add t0, t0, t1
    mss m23, (t0), a4
    ld s0, 0(sp)
    ld s1, 8(sp)
    addi sp, sp, 16
    ret
