def a(args):
    args['b'] = 'changed'

ar = { 'b': 'test'}
a(ar)

print(ar)