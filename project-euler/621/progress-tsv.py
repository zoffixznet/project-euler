import os.path
print("i\tt")
for i in range(0, 10000):
    fn = "parts/%d.t" % i
    if os.path.isfile(fn):
        print("%d\t%d" % (i, os.path.getmtime(fn)))
