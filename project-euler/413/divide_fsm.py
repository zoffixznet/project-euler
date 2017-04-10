import sys

if sys.version_info > (3,):
    xrange = range


def get_div_fsms(BASE):
    states = []

    rev_states = [[0 for d in xrange(10)] for x in xrange(BASE)]
    for i in xrange(BASE):
        links = [(i*10+x) % BASE for x in xrange(10)]

        for l_idx in xrange(10):
            rev_states[links[l_idx]][l_idx] = i
        states.append(links)

    return (states, rev_states)
