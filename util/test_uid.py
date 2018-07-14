import pwd
uid = 1000
user = pwd.getpwuid(uid)[0]
print(user)