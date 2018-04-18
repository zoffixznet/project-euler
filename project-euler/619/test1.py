#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2018 shlomif <shlomif@cpan.org>
#
# Distributed under terms of the MIT license.

"""

"""
i = 1
e = 1
while i != 975523611:
    e += 1
    i = ((i << 1) | 1) % 1000000007
print(e)
