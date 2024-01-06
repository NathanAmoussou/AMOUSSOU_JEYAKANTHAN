# Question 4
# Question 5

import ply.yacc as yacc
from regexp_lex import tokens

# Classe pour représenter les nœuds de l'arbre syntaxique
class Node:
    def __init__(self, type, children=None, leaf=None):
        self.type = type
        if children:
            self.children = children
        else:
            self.children = []
        self.leaf = leaf
    def __str__(self, level=0):
        ret = "  " * level + repr(self.type)
        if self.leaf is not None:
            ret += " (" + repr(self.leaf) + ")"
        ret += "\n"
        for child in self.children:
            ret += child.__str__(level + 1)
        return ret
# Règles de production pour la grammaire

def p_expression_plus(p):
    'expression : expression PLUS term'
    p[0] = Node('union', [p[1], p[3]])

def p_expression_term(p):
    'expression : term'
    p[0] = p[1]

def p_term_dot(p):
    'term : term DOT factor'
    p[0] = Node('concatenation', [p[1], p[3]])

def p_term_factor(p):
    'term : factor'
    p[0] = p[1]

def p_factor_star(p):
    'factor : factor STAR'
    p[0] = Node('star', [p[1]])

def p_factor_primary(p):
    'factor : primary'
    p[0] = p[1]

def p_primary_letter(p):
    'primary : LETTER'
    p[0] = Node('letter', leaf=p[1])

def p_primary_epsilon(p):
    'primary : EPSILON'
    p[0] = Node('epsilon')

def p_primary_emptyset(p):
    'primary : EMPTY_SET'
    p[0] = Node('emptyset')

def p_primary_group(p):
    'primary : PAR_O expression PAR_F'
    p[0] = p[2]  # Les parenthèses ne sont pas conservées, seulement l'expression entre elles

# Règle de gestion des erreurs
def p_error(p):
    print(f"Syntax error at '{p.value}'")

# Construire l'analyseur syntaxique
parser = yacc.yacc()

# Testons l'analyseur syntaxique
def parse(data):
    return parser.parse(data)

# Entrée de test
data = "(a+b)*.E"
result = parse(data)
print(result)
