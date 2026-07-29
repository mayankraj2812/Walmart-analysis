# print("helloworld")
# name=input("enter your name:")
# number = str(input("enter a number: "))

# if number > 5:
#     print("high")
# else:
#     print("low")
import numpy as np
# a = np.array([[1,2,3], 
#             [4,5,6], 
#             [7,8,9]]) 
# b = np.array([[2,3,4], 
# [5,6,7], 
# [8,9,10]]) 
# o = np.matmul(a, b) 
# print(o)
a=int(input('a'))
b=int(input('b'))
def sum(a,b):
    return (a+b)
print(sum(a,b))
multiply=lambda a,b:a*b
print(multiply(a,b))