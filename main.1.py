from automate import *

a0 = automate("a")
a1 = automate("b")
a2 = union(a0, a1);
a3 = etoile(a2);
a4 = automate("c")
a5 = concatenation(a3, a4);

a_final = a5
print(a_final);
print(reconnait(a_final,"ab"))
print(reconnait(a_final,"aaaaac"))
print(reconnait(a_final,"c"))

