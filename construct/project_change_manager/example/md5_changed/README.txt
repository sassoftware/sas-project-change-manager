This example demonstrates a failed Project Change Manager execution, due to rerunning a changelog with a modified program that was previously successfully executed. 

To run through the example, execute pcm.sh with bin as the working directory.
You may need to enable execute permissions on pcm.sh (e.g. using chmod 744 pcm.sh).
This will result in a failure.

This failure results because in this example there is a pre-populated database changelog table with an entry for one of the changesets.
This entry will have a different md5 checksum, however, resulting in a a failure.
This dataset was created in a Linux/CentOS server with SAS 9.4.  It has not been tested on other platforms.