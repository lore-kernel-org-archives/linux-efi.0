Received: from mail1.nectarine.be (hip.nectarine.be [185.213.22.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57B73378D74;
	Mon, 28 Sep 2026 07:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.213.22.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790581030; cv=none; b=WiwT2YPZ0LiA4zJ2eUu77HaOj3kiuIhwNRlo8pgp/TQkJZRIUOg0zaM5k1DbwQMQGeTvpPCCr9G1ds5CQmoxxhCYw5VE2b49lhXXur+HkBQkIrBZr++eW+zCxCwencOn5HNkuzx7H+R9EhRlmwCZvo6b8LRXWy6jVQs/Ypvwg1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790581030; c=relaxed/simple;
	bh=1jAsz6EiBgb/ZwkMPYRS1MwuvKAbkkHDr/aokCGi6J4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QZzjyTw/zLP8Pe483QKj7q4CynehdCm+ts5r/sEv5t8yIKObxJ42ydcOFTa4ZzfGgHRFqb4zM3LliE6XZudwMniomMs14zJ+W5po4v0OaqFpAtIl/tP41rviDJBd2sXJBC8KPB8f44NhiazJxXfvV4QNdxVh6BaeqYhLPdwNkWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainez.net; spf=pass smtp.mailfrom=brainez.net; arc=none smtp.client-ip=185.213.22.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=brainez.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=brainez.net
From: Nicolas Brainez <nicolas@brainez.net>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Lukas Wunner <lukas@wunner.de>,
	linux-efi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Nicolas Brainez <nicolas@brainez.net>,
	stable@vger.kernel.org
Subject: [PATCH] efistub/x86: Fix the size type of the Apple properties protocol
Date: Mon, 28 Sep 2026 09:28:32 +0200
Message-ID: <20260928072832.25399-1-nicolas@brainez.net>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The size argument of the get(), set() and get_all() methods of the
Apple device properties protocol is a UINTN, not a u32. The reverse
engineered declaration added by commit 58c5475aba67 ("x86/efi: Retrieve
and assign Apple device properties") uses u32, and
retrieve_apple_device_properties() passes the address of a u32 on the
stack to get_all(). 64-bit Apple firmware writes 8 bytes through that
pointer, so the upper half of the store lands on whatever the compiler
placed next to the variable. OpenCore's
Include/Apple/Protocol/DevicePathPropertyDatabase.h declares the same
methods with UINTN, and a u32 canary placed right after the u32 size
is zeroed by both get_all() calls on a Mac mini 2018 (Macmini8,1).

With clang and CONFIG_EFI_MIXED=n, the neighbour is the protocol
pointer p: the first get_all() call zeroes its low half, the second
call jumps through the corrupted pointer, and the machine powers off
before printing anything. A GCC build leaves padding in that slot, and
a clang build with CONFIG_EFI_MIXED=y places the setup_data pointer
there; neither crashes, so the bug went unnoticed since 2016. Talos
Linux, which builds its kernel with clang, reported it on several Mac
generations.

Declare the size as unsigned long, as the stub does for every other
UINTN. No mixed mode argument mapping is needed: 32-bit firmware
writes the low 32 bits of the zero-initialised value, and the upper
half stays zero across both calls.

Tested on a Macmini8,1 with v6.18.51, clang 22.1.8 and LLD,
CONFIG_EFI_MIXED=n, booted as EFI/BOOT/BOOTX64.EFI: the machine powers
off without the patch and boots with it. Builds with clang and GCC,
with and without CONFIG_EFI_MIXED. Mixed mode was not boot tested (no
32-bit EFI Mac at hand).

Claude Code assisted with reading the disassembly, writing the debug
patches and drafting this changelog; the tests ran on the hardware
above.

Fixes: 58c5475aba67 ("x86/efi: Retrieve and assign Apple device properties")
Cc: stable@vger.kernel.org
Cc: Lukas Wunner <lukas@wunner.de>
Link: https://github.com/siderolabs/talos/issues/13231
Link: https://github.com/siderolabs/talos/issues/13579
Assisted-by: LLM
Signed-off-by: Nicolas Brainez <nicolas@brainez.net>
---
 drivers/firmware/efi/libstub/efistub.h  | 8 +++++---
 drivers/firmware/efi/libstub/x86-stub.c | 2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/firmware/efi/libstub/efistub.h b/drivers/firmware/efi/libstub/efistub.h
index fd91fc15e..1002c17a8 100644
--- a/drivers/firmware/efi/libstub/efistub.h
+++ b/drivers/firmware/efi/libstub/efistub.h
@@ -838,15 +838,17 @@ union apple_properties_protocol {
 		unsigned long version;
 		efi_status_t (__efiapi *get)(apple_properties_protocol_t *,
 					     struct efi_dev_path *,
-					     efi_char16_t *, void *, u32 *);
+					     efi_char16_t *, void *,
+					     unsigned long *);
 		efi_status_t (__efiapi *set)(apple_properties_protocol_t *,
 					     struct efi_dev_path *,
-					     efi_char16_t *, void *, u32);
+					     efi_char16_t *, void *,
+					     unsigned long);
 		efi_status_t (__efiapi *del)(apple_properties_protocol_t *,
 					     struct efi_dev_path *,
 					     efi_char16_t *);
 		efi_status_t (__efiapi *get_all)(apple_properties_protocol_t *,
-						 void *buffer, u32 *);
+						 void *buffer, unsigned long *);
 	};
 	struct {
 		u32 version;
diff --git a/drivers/firmware/efi/libstub/x86-stub.c b/drivers/firmware/efi/libstub/x86-stub.c
index cef32e2c8..87e142cae 100644
--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -158,7 +158,7 @@ static void retrieve_apple_device_properties(struct boot_params *boot_params)
 	efi_guid_t guid = APPLE_PROPERTIES_PROTOCOL_GUID;
 	struct setup_data *data, *new;
 	efi_status_t status;
-	u32 size = 0;
+	unsigned long size = 0;
 	apple_properties_protocol_t *p;
 
 	status = efi_bs_call(locate_protocol, &guid, NULL, (void **)&p);
-- 
2.47.3

