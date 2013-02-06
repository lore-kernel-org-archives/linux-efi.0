From: Jeremy Kerr <jk@ozlabs.org>
Subject: [PATCH 2/3 v3] selftests/efivarfs: Add empty file creation test
Date: Wed, 06 Feb 2013 22:48:08 +0800
Message-ID: <1360162088.143301.227254679723.2.gpush@pecola>
References: <1360162088.142733.191120808822.0.gpush@pecola>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1360162088.142733.191120808822.0.gpush@pecola>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>, Lingzhu Xiang <lxiang@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-efi@vger.kernel.org

Signed-off-by: Jeremy Kerr <jk@ozlabs.org>

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
