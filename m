From: Geliang Tang <geliangtang@163.com>
Subject: [PATCH v2 2/3] efi-pstore: implement efivars_pstore_exit()
Date: Sat,  7 Nov 2015 12:43:48 +0800
Message-ID: <c203e0cfee351d6f97c6a1a42c3e25b4be339f93.1446869434.git.geliangtang@163.com>
References: <cover.1446869434.git.geliangtang@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1446869434.git.geliangtang@163.com>
In-Reply-To: <337377a3fbcf855d6a5217e06fcd8c8a979f2853.1446869434.git.geliangtang@163.com>
References: <cover.1446869434.git.geliangtang@163.com> <337377a3fbcf855d6a5217e06fcd8c8a979f2853.1446869434.git.geliangtang@163.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>
Cc: Geliang Tang <geliangtang@163.com>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

The original efivars_pstore_exit() is empty. I
 1) add a bufsize check statement.
 2) call pstore_unregister as it is defined now.
 3) free the memory and set bufsize to 0.

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 drivers/firmware/efi/efi-pstore.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/firmware/efi/efi-pstore.c b/drivers/firmware/efi/efi-pstore.c
index eac76a7..62d57d8 100644
--- a/drivers/firmware/efi/efi-pstore.c
+++ b/drivers/firmware/efi/efi-pstore.c
@@ -393,6 +393,13 @@ static __init int efivars_pstore_init(void)
 
 static __exit void efivars_pstore_exit(void)
 {
+	if (!efi_pstore_info.bufsize)
+		return;
+
+	pstore_unregister(&efi_pstore_info);
+	kfree(efi_pstore_info.buf);
+	efi_pstore_info.buf = NULL;
+	efi_pstore_info.bufsize = 0;
 }
 
 module_init(efivars_pstore_init);
-- 
2.5.0
