From: Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/3] selftests/efivarfs: Add empty file creation test
Date: Sun, 27 Jan 2013 06:47:40 +0800
Message-ID: <1359240460.11649.375507806137.2.gpush@pororo>
References: <1359240460.10567.220444825101.0.gpush@pororo>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1359240460.10567.220444825101.0.gpush@pororo>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Lingzhu Xiang <lxiang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Signed-off-by: Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>

---
 tools/testing/selftests/efivarfs/efivarfs.sh |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/tools/testing/selftests/efivarfs/efivarfs.sh b/tools/testing/selftests/efivarfs/efivarfs.sh
index e8c0d27..3af4b37 100755
--- a/tools/testing/selftests/efivarfs/efivarfs.sh
+++ b/tools/testing/selftests/efivarfs/efivarfs.sh
@@ -58,6 +58,18 @@ test_create()
 	fi
 }
 
+test_create_empty()
+{
+	local file=$efivarfs_mount/$FUNCNAME-$test_guid
+
+	: > $file
+
+	if [ ! -e $file ]; then
+		echo "$file can not be created without writing" >&2
+		exit 1
+	fi
+}
+
 test_delete()
 {
 	local attrs='\x07\x00\x00\x00'
@@ -112,6 +124,7 @@ check_prereqs
 rc=0
 
 run_test test_create
+run_test test_create_empty
 run_test test_delete
 run_test test_zero_size_delete
 run_test test_open_unlink
