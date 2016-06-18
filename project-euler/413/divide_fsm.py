def get_div_fsms(BASE):
    states = []

    rev_states = [[0 for d in range(0,10)] for x in range(0,BASE)]
    for i in range(0,BASE):
        links = [(i*10+x) % BASE for x in range(0,10)];

        for l_idx in range(0,10):
            rev_states[links[l_idx]][l_idx] = i;
        states.append(links)

    return (states, rev_states);
