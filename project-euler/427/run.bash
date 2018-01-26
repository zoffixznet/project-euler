# Copyright by Shlomi Fish, 2018 under the Expat licence
# https://opensource.org/licenses/mit-license.php
perl feed.pl | parallel -j4 perl run-job.pl
