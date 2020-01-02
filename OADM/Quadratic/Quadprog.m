clear all
clc

A = [
    1 2 1 0
    2 3 0 1
    ]

b = [8 2]

Q = -[
    -2  0  0  0
     0 -2  0  0
     0  0  0  0
     0  0  0  0
    ]

c = -[2 0 0 0]

X = quadprog(Q,c,[],[],A,b,[0 0 0 0], [Inf Inf Inf Inf])
