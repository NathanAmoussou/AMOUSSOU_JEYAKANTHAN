
# parsetab.py
# This file is automatically generated. Do not edit.
# pylint: disable=W,C,R
_tabversion = '3.10'

_lr_method = 'LALR'

_lr_signature = 'DOT EMPTY_SET EPSILON LETTER PAR_F PAR_O PLUS STARexpression : expression PLUS termexpression : termterm : term DOT factorterm : factorfactor : factor STARfactor : primaryprimary : LETTERprimary : EPSILONprimary : EMPTY_SETprimary : PAR_O expression PAR_F'
    
_lr_action_items = {'LETTER':([0,8,9,10,],[5,5,5,5,]),'EPSILON':([0,8,9,10,],[6,6,6,6,]),'EMPTY_SET':([0,8,9,10,],[7,7,7,7,]),'PAR_O':([0,8,9,10,],[8,8,8,8,]),'$end':([1,2,3,4,5,6,7,11,13,14,15,],[0,-2,-4,-6,-7,-8,-9,-5,-1,-3,-10,]),'PLUS':([1,2,3,4,5,6,7,11,12,13,14,15,],[9,-2,-4,-6,-7,-8,-9,-5,9,-1,-3,-10,]),'PAR_F':([2,3,4,5,6,7,11,12,13,14,15,],[-2,-4,-6,-7,-8,-9,-5,15,-1,-3,-10,]),'DOT':([2,3,4,5,6,7,11,13,14,15,],[10,-4,-6,-7,-8,-9,-5,10,-3,-10,]),'STAR':([3,4,5,6,7,11,14,15,],[11,-6,-7,-8,-9,-5,11,-10,]),}

_lr_action = {}
for _k, _v in _lr_action_items.items():
   for _x,_y in zip(_v[0],_v[1]):
      if not _x in _lr_action:  _lr_action[_x] = {}
      _lr_action[_x][_k] = _y
del _lr_action_items

_lr_goto_items = {'expression':([0,8,],[1,12,]),'term':([0,8,9,],[2,2,13,]),'factor':([0,8,9,10,],[3,3,3,14,]),'primary':([0,8,9,10,],[4,4,4,4,]),}

_lr_goto = {}
for _k, _v in _lr_goto_items.items():
   for _x, _y in zip(_v[0], _v[1]):
       if not _x in _lr_goto: _lr_goto[_x] = {}
       _lr_goto[_x][_k] = _y
del _lr_goto_items
_lr_productions = [
  ("S' -> expression","S'",1,None,None,None),
  ('expression -> expression PLUS term','expression',3,'p_expression_plus','regexp_parser.py',20),
  ('expression -> term','expression',1,'p_expression_term','regexp_parser.py',24),
  ('term -> term DOT factor','term',3,'p_term_dot','regexp_parser.py',28),
  ('term -> factor','term',1,'p_term_factor','regexp_parser.py',32),
  ('factor -> factor STAR','factor',2,'p_factor_star','regexp_parser.py',36),
  ('factor -> primary','factor',1,'p_factor_primary','regexp_parser.py',40),
  ('primary -> LETTER','primary',1,'p_primary_letter','regexp_parser.py',44),
  ('primary -> EPSILON','primary',1,'p_primary_epsilon','regexp_parser.py',48),
  ('primary -> EMPTY_SET','primary',1,'p_primary_emptyset','regexp_parser.py',52),
  ('primary -> PAR_O expression PAR_F','primary',3,'p_primary_group','regexp_parser.py',56),
]