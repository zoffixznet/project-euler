#!/bin/bash

# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php

seq 1 100 | perl -I. -MEuler288=factorial_factor_exp -lanE 'use Math::BigInt lib => "GMP", ":constant"; print factorial_factor_exp(3 ** $_, 3) % 3 ** 20'
