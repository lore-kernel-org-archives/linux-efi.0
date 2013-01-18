From: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [PATCH] selftests: Add tests for efivarfs
Date: Fri, 18 Jan 2013 17:19:36 +0800
Message-ID: <1358500776.780948.518900415126.1.gpush@pecola>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

This change adds a few initial efivarfs tests to the
tools/testing/selftests directory.

The open-unlink test is based on code from
Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>.

Signed-off-by: Jeremy Kerr <jeremy.kerr-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
CC: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
CC: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
CC: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>

---
 tools/testing/selftests/Makefile               |    2 
 tools/testing/selftests/efivarfs/Makefile      |   12 +
 tools/testing/selftests/efivarfs/efivarfs.sh   |  127 +++++++++++++++++
 tools/testing/selftests/efivarfs/open-unlink.c |   60 ++++++++
 4 files changed, 200 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 85baf11..dee19dd 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -1,4 +1,4 @@
-TARGETS = breakpoints kcmp mqueue vm cpu-hotplug memory-hotplug
+TARGETS = breakpoints kcmp mqueue vm cpu-hotplug memory-hotplug efivarfs
 
 all:
 	for TARGET in $(TARGETS); do \
diff --git a/tools/testing/selftests/efivarfs/Makefile b/tools/testing/selftests/efivarfs/Makefile
new file mode 100644
index 0000000..1a943ee
--- /dev/null
+++ b/tools/testing/selftests/efivarfs/Makefile
@@ -0,0 +1,12 @@
+CC = $(CROSS_COMPILE)gcc
+CFLAGS = -Wall
+
+test_objs = open-unlink
+
+all: $(test_objs)
+
+run_tests: all
+	@./efivarfs.sh || echo "efivarfs selftests: [FAIL]"
+
+clean:
+	rm -f $(test_objs)
diff --git a/tools/testing/selftests/efivarfs/efivarfs.sh b/tools/testing/selftests/efivarfs/efivarfs.sh
new file mode 100755
index 0000000..5abd55e
--- /dev/null
+++ b/tools/testing/selftests/efivarfs/efivarfs.sh
@@ -0,0 +1,127 @@
+#!/bin/bash
+
+efivarfs_mount=/sys/firmware/efi/efivars
+test_guid=210be57c-9849-4fc7-a635-e6382d1aec27
+
+check_prereqs()
+{
+	local msg="skip all tests:"
+
+	if [ $UID != 0 ]; then
+		echo $msg must be run as root >&2
+		exit 0
+	fi
+
+	if ! grep -q "^\S\+ $efivarfs_mount efivarfs" /proc/mounts; then
+		echo $msg efivarfs is not mounted on $efivarfs_mount >&2
+		exit 0
+	fi
+
+	# the open-unlink test relies on deleting the Lang variable at
+	# present; we don't want to do this on an actual machine.
+	if ! grep -q 'model name.* QEMU' /proc/cpuinfo; then
+		echo $msg efivarfs tests should only be run on a VM >&2
+		exit 0
+	fi
+
+}
+
+run_test()
+{
+	local test="$1"
+
+	echo "--------------------"
+	echo "running $test"
+	echo "--------------------"
+
+	if [ "$(type -t $test)" = 'function' ]; then
+		( $test )
+	else
+		( ./$test )
+	fi
+
+	if [ $? -ne 0 ]; then
+		echo "  [FAIL]"
+		rc=1
+	else
+		echo "  [PASS]"
+	fi
+}
+
+test_create()
+{
+	local attrs='\x07\x00\x00\x00'
+	local file=$efivarfs_mount/test.1-$test_guid
+
+	printf "$attrs\x00" > $file
+
+	if [ ! -e $file ]; then
+		echo "$file couldn't be created" >&2
+		exit 1
+	fi
+
+	if [ $(stat -c %s $file) -ne 5 ]; then
+		echo "$file has invalid size" >&2
+		exit 1
+	fi
+}
+
+test_delete()
+{
+	local attrs='\x07\x00\x00\x00'
+	local file=$efivarfs_mount/test.2-$test_guid
+
+	printf "$attrs\x00" > $file
+
+	if [ ! -e $file ]; then
+		echo "$file couldn't be created" >&2
+		exit 1
+	fi
+
+	rm $file
+
+	if [ -e $file ]; then
+		echo "$file couldn't be deleted" >&2
+		exit 1
+	fi
+
+}
+
+# test that we can remove a variable by issuing a write with only
+# attributes specified
+test_zero_size_delete()
+{
+	local attrs='\x07\x00\x00\x00'
+	local file=$efivarfs_mount/test.3-$test_guid
+
+	printf "$attrs\x00" > $file
+
+	if [ ! -e $file ]; then
+		echo "$file does not exist" >&2
+		exit 1
+	fi
+
+	printf "$attrs" > $file
+
+	if [ -e $file ]; then
+		echo "$file should have been deleted" >&2
+		exit 1
+	fi
+}
+
+test_open_unlink()
+{
+	local file=$efivarfs_mount/test.4-$test_guid
+	./open-unlink $file
+}
+
+check_prereqs
+
+rc=0
+
+run_test test_create
+run_test test_delete
+run_test test_zero_size_delete
+run_test test_open_unlink
+
+exit $rc
diff --git a/tools/testing/selftests/efivarfs/open-unlink.c b/tools/testing/selftests/efivarfs/open-unlink.c
new file mode 100644
index 0000000..fd2a542
--- /dev/null
+++ b/tools/testing/selftests/efivarfs/open-unlink.c
@@ -0,0 +1,60 @@
+#include <stdio.h>
+#include <stdint.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <fcntl.h>
+
+int main(int argc, char **argv)
+{
+	const char *path;
+	char buf[5];
+	int fd, rc;
+
+	if (argc < 2) {
+		fprintf(stderr, "usage: %s <path>\n", argv[0]);
+		return EXIT_FAILURE;
+	}
+
+	path = argv[1];
+
+	/* attributes: EFI_VARIABLE_NON_VOLATILE |
+	 *		EFI_VARIABLE_BOOTSERVICE_ACCESS |
+	 *		EFI_VARIABLE_RUNTIME_ACCESS
+	 */
+	*(uint32_t *)buf = 0x7;
+	buf[4] = 0;
+
+	/* create a test variable */
+	fd = open(path, O_WRONLY | O_CREAT);
+	if (fd < 0) {
+		perror("open(O_WRONLY)");
+		return EXIT_FAILURE;
+	}
+
+	rc = write(fd, buf, sizeof(buf));
+	if (rc != sizeof(buf)) {
+		perror("write");
+		return EXIT_FAILURE;
+	}
+
+	close(fd);
+
+	fd = open(path, O_RDONLY);
+	if (fd < 0) {
+		perror("open");
+		return EXIT_FAILURE;
+	}
+
+	if (unlink(path) < 0) {
+		perror("unlink");
+		return EXIT_FAILURE;
+	}
+	if (read(fd, NULL, 0) < 0) {
+		perror("read");
+		return EXIT_FAILURE;
+	}
+
+	return EXIT_SUCCESS;
+}
