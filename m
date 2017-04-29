From: Geliang Tang <geliangtang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] efi/efi_test: drop useless kfree
Date: Sat, 29 Apr 2017 09:42:53 +0800
Message-ID: <427b03b5f10b41014818b9e78f79da9581b213df.1493383416.git.geliangtang@gmail.com>
References: <d0d524b81d55b4e5f1708d5441e655c75365c0b8.1493383416.git.geliangtang@gmail.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <d0d524b81d55b4e5f1708d5441e655c75365c0b8.1493383416.git.geliangtang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
In-Reply-To: <d0d524b81d55b4e5f1708d5441e655c75365c0b8.1493383416.git.geliangtang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
References: <d0d524b81d55b4e5f1708d5441e655c75365c0b8.1493383416.git.geliangtang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ivan Hu <ivan.hu-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Geliang Tang <geliangtang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Drop useless kfree when memdup_user() failed, since we have already
called kfree in memdup_user().

Signed-off-by: Geliang Tang <geliangtang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efi/test/efi_test.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/firmware/efi/test/efi_test.c b/drivers/firmware/efi/test/efi_test.c
index 08129b7..00332ae 100644
--- a/drivers/firmware/efi/test/efi_test.c
+++ b/drivers/firmware/efi/test/efi_test.c
@@ -261,10 +261,8 @@ static long efi_runtime_set_variable(unsigned long arg)
 	}
 
 	data = memdup_user(setvariable.data, setvariable.data_size);
-	if (IS_ERR(data)) {
-		kfree(name);
+	if (IS_ERR(data))
 		return PTR_ERR(data);
-	}
 
 	status = efi.set_variable(name, &vendor_guid,
 				setvariable.attributes,
-- 
2.9.3
