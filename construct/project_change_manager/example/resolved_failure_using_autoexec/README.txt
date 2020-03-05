This example demonstrates a failed Project Change Manager execution, followed by a successful Project Change Manager execution of identical programs.
It also demonstrates the use of an optional autoexec file which runs before each changeset.

To run through the example, execute 01_pcm_fail.sh with bin as the working directory.
You may need to enable execute permissions on pcm.sh (e.g. using chmod 744 01_pcm_fail.sh).
This will result in a failure.
Next execute 02_pcm_success.sh with bin as the working directory.
You may need to enable execute permissions on pcm.sh (e.g. using chmod 744 02_pcm_success.sh).
This will result in a success.
You may review the log files in the log directory, and the changelog database in the installs directory.