Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBEB4CA777;
	Thu,  3 Sep 2026 21:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788470735; cv=none; b=dIBQI4/q8EyfWCeL2++goMQn/yJ/W+ChWLaLt1Vue0bjLqUAdeajD1CQ0vFuyyTHaZxIdl7ZxqXQM4p7gIgh/berxyLAkK91CKgx+kyA2BASO5ZPRn5+zUbX95VbPxVQ1PBbjTZSnnUr9PkvUszOTuw7sxwHLXNmVUOHiBArB9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788470735; c=relaxed/simple;
	bh=Kn/zVT5tnzTP1S2REZykXEA2mTzGV418WfXL1oWXKiI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=nj+feSbvGwIWoEhYx077G/5YklhqrI2jZIdDupQUJu45hrsj6oHdjkxkC1Z5bUIxQ5z+UQSey8ousPEk+MckyxA0nbFuGnc+vu/P/8w9LYmMMMrjiAKT8MQhapVbJPTtSw5jlLjNZmPLLD3b5rLuzqDAuTuzm2uRkn/1KnlFLLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P3ib2OSs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P3ib2OSs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA2D1F00A3D;
	Thu,  3 Sep 2026 21:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788470732;
	bh=BVx4V8gOy/KPLRPoOT7KDktjPxrhsVoKEFYfErr3ofU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=P3ib2OSs4uCjgi7QFWklue+AzUjEwmvCYGITnZUjdCp+Wi3UJAKR7Woh2Cuq9OIMf
	 bkXrHPEsHte26roytvCmQfIAtyrKtRQ3HZOyZG853+/4lTm/V1ZjvuFHZYAipdkqWe
	 YncJQtaRqsT5ZqVNdA9jzWqEwTJFVmopWCD+nwqLGJyWTEuXhpYutzMd8l+QkRTRJg
	 gAgEWhNQsGQUqTE475vwc/t6IVoB/NVf9yKJoV9z2EQXtisj2ysiHq2vgrg3kSxdlS
	 yZ4VIAWlmy5zMBI3f/eay+EjpBIR8lMjg4W5koLGQmYLR5AhAKwP9oFxa+az/2mrV0
	 lQ6Lxr6Odbsrg==
From: Vincent Mailhol <mailhol@kernel.org>
Date: Thu, 03 Sep 2026 23:25:15 +0200
Subject: [PATCH 1/3] efi/libstub: move direct GUID references to static
 storage
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260903-libstub_guid_cleanup-v1-1-06fcb6216975@kernel.org>
References: <20260903-libstub_guid_cleanup-v1-0-06fcb6216975@kernel.org>
In-Reply-To: <20260903-libstub_guid_cleanup-v1-0-06fcb6216975@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>, 
 Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Vincent Mailhol <mailhol@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8821; i=mailhol@kernel.org;
 h=from:subject:message-id; bh=Kn/zVT5tnzTP1S2REZykXEA2mTzGV418WfXL1oWXKiI=;
 b=owGbwMvMwCV2McXO4Xp97WbG02pJDFkzn55YenbbdcP5m1VPLI1gPjO3taL0gPdDJ4l9lVunG
 e7bn1wY2zGRhUGMi8FSTJFlWTknt0JHoXfYob+WMHNYmUCGSIs0MAABCwNfbmJeqZGOkZ6ptqGe
 IZChY8TAxSkAU/1pKcM/LeMuadvuB8+nvn8q5FvRHvxuyh/OQtdcrq2BxXrXl2zhYPjv56H/e0f
 /YqmXM8UFlvSfzjOS2iClcfPXq86pfbHzjGcyAwA=
X-Developer-Key: i=mailhol@kernel.org; a=openpgp;
 fpr=ED8F700574E67F20E574E8E2AB5FEB886DBB99C2

Some EFI stub call sites pass the address of a GUID macro directly to
EFI boot services. With gcc, this makes the compiler materialize the
GUID data at the call site, which is wasteful in the size-sensitive EFI
stub.

For example, consider this program:

	#include <linux/efi.h>

	#define GUID							\
		EFI_GUID(0xaaaaaaaa, 0xbbbb, 0xcccc,			\
			 0xdd, 0xdd, 0xdd, 0xdd, 0xdd, 0xdd, 0xdd, 0xdd)

	void foo(const efi_guid_t *guid);

	void guid_direct(void)
	{
		foo(&GUID);
	}

	void guid_static(void)
	{
		static efi_guid_t guid = GUID;

		foo(&guid);
	}

For guid_direct(), gcc materializes the GUID on the stack:

   0:	f3 0f 1e fa          	endbr64
   4:	48 b8 aa aa aa aa bb 	movabs $0xccccbbbbaaaaaaaa,%rax
   b:	bb cc cc
   e:	48 83 ec 18          	sub    $0x18,%rsp
  12:	48 89 04 24          	mov    %rax,(%rsp)
  16:	48 89 e7             	mov    %rsp,%rdi
  19:	48 b8 dd dd dd dd dd 	movabs $0xdddddddddddddddd,%rax
  20:	dd dd dd
  23:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  28:	e8 00 00 00 00       	call   2d <guid_direct+0x2d>
  2d:	48 83 c4 18          	add    $0x18,%rsp
  31:	c3                   	ret

For guid_static(), gcc stores the GUID in .data and emits a RIP-relative
address load:

  32:	f3 0f 1e fa          	endbr64
  36:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi
  3d:	e9 00 00 00 00       	jmp    42 <guid_static+0x10>

Overall, guid_direct() consumes 50 bytes in the .text segment whereas
guid_static() needs only 32 bytes in total: 16 bytes in .data and 16
bytes in .text.

Move these direct GUID references to function-local static objects and
pass their address instead. EFI boot service prototypes take non-const
efi_guid_t pointers, so keep the GUID non-const to prevent a
-Wdiscarded-qualifiers warning.

For an x86_64 build with gcc 15.3.0, bloat-o-meter reports:

  add/remove: 6/0 grow/shrink: 0/3 up/down: 112/-458 (-346)
  Function                                     old     new   delta
  graphics_output_guid                           -      32     +32
  smbios_guid                                    -      16     +16
  edid_discovered_guid                           -      16     +16
  edid_active_guid                               -      16     +16
  console_out_device_guid                        -      16     +16
  apple_set_os_guid                              -      16     +16
  efi_stub_entry                              4180    4136     -44
  efi_get_smbios_record                        283     226     -57
  efi_setup_graphics                          2210    1853    -357
  Total: Before=29223, After=28877, chg -1.18%

Signed-off-by: Vincent Mailhol <mailhol@kernel.org>
---
 drivers/firmware/efi/libstub/gop.c      | 17 ++++++++++-------
 drivers/firmware/efi/libstub/smbios.c   |  3 ++-
 drivers/firmware/efi/libstub/x86-stub.c |  3 ++-
 drivers/firmware/efi/libstub/zboot.c    |  3 ++-
 4 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/firmware/efi/libstub/gop.c b/drivers/firmware/efi/libstub/gop.c
index 80dc8cfeb33e..acc2827ba4d7 100644
--- a/drivers/firmware/efi/libstub/gop.c
+++ b/drivers/firmware/efi/libstub/gop.c
@@ -425,6 +425,8 @@ static void setup_edid_info(struct edid_info *edid, u32 gop_size_of_edid, u8 *go
 static efi_handle_t find_handle_with_primary_gop(unsigned long num, const efi_handle_t handles[],
 						 efi_graphics_output_protocol_t **found_gop)
 {
+	static efi_guid_t graphics_output_guid = EFI_GRAPHICS_OUTPUT_PROTOCOL_GUID;
+	static efi_guid_t console_out_device_guid = EFI_CONSOLE_OUT_DEVICE_GUID;
 	efi_graphics_output_protocol_t *first_gop;
 	efi_handle_t h, first_gop_handle;
 
@@ -439,8 +441,7 @@ static efi_handle_t find_handle_with_primary_gop(unsigned long num, const efi_ha
 		efi_graphics_output_mode_info_t *info;
 		void *dummy = NULL;
 
-		status = efi_bs_call(handle_protocol, h,
-				     &EFI_GRAPHICS_OUTPUT_PROTOCOL_GUID,
+		status = efi_bs_call(handle_protocol, h, &graphics_output_guid,
 				     (void **)&gop);
 		if (status != EFI_SUCCESS)
 			continue;
@@ -462,7 +463,7 @@ static efi_handle_t find_handle_with_primary_gop(unsigned long num, const efi_ha
 		 * don't bother looking any further.
 		 */
 		status = efi_bs_call(handle_protocol, h,
-				     &EFI_CONSOLE_OUT_DEVICE_GUID, &dummy);
+				     &console_out_device_guid, &dummy);
 		if (status == EFI_SUCCESS) {
 			if (found_gop)
 				*found_gop = gop;
@@ -480,6 +481,9 @@ static efi_handle_t find_handle_with_primary_gop(unsigned long num, const efi_ha
 
 efi_status_t efi_setup_graphics(struct screen_info *si, struct edid_info *edid)
 {
+	static efi_guid_t graphics_output_guid = EFI_GRAPHICS_OUTPUT_PROTOCOL_GUID;
+	static efi_guid_t edid_active_guid = EFI_EDID_ACTIVE_PROTOCOL_GUID;
+	static efi_guid_t edid_discovered_guid = EFI_EDID_DISCOVERED_PROTOCOL_GUID;
 	efi_handle_t *handles __free(efi_pool) = NULL;
 	efi_handle_t handle;
 	efi_graphics_output_protocol_t *gop;
@@ -487,8 +491,7 @@ efi_status_t efi_setup_graphics(struct screen_info *si, struct edid_info *edid)
 	unsigned long num;
 
 	status = efi_bs_call(locate_handle_buffer, EFI_LOCATE_BY_PROTOCOL,
-			      &EFI_GRAPHICS_OUTPUT_PROTOCOL_GUID, NULL, &num,
-			      &handles);
+			      &graphics_output_guid, NULL, &num, &handles);
 	if (status != EFI_SUCCESS)
 		return status;
 
@@ -510,14 +513,14 @@ efi_status_t efi_setup_graphics(struct screen_info *si, struct edid_info *edid)
 		u32 gop_size_of_edid = 0;
 		u8 *gop_edid = NULL;
 
-		status = efi_bs_call(handle_protocol, handle, &EFI_EDID_ACTIVE_PROTOCOL_GUID,
+		status = efi_bs_call(handle_protocol, handle, &edid_active_guid,
 				     (void **)&active_edid);
 		if (status == EFI_SUCCESS) {
 			gop_size_of_edid = efi_table_attr(active_edid, size_of_edid);
 			gop_edid = efi_table_attr(active_edid, edid);
 		} else {
 			status = efi_bs_call(handle_protocol, handle,
-					     &EFI_EDID_DISCOVERED_PROTOCOL_GUID,
+					     &edid_discovered_guid,
 					     (void **)&discovered_edid);
 			if (status == EFI_SUCCESS) {
 				gop_size_of_edid = efi_table_attr(discovered_edid, size_of_edid);
diff --git a/drivers/firmware/efi/libstub/smbios.c b/drivers/firmware/efi/libstub/smbios.c
index f31410d7e7e1..efbbfc3c2c0d 100644
--- a/drivers/firmware/efi/libstub/smbios.c
+++ b/drivers/firmware/efi/libstub/smbios.c
@@ -35,12 +35,13 @@ union efi_smbios_protocol {
 
 const struct efi_smbios_record *efi_get_smbios_record(u8 type)
 {
+	static efi_guid_t smbios_guid = EFI_SMBIOS_PROTOCOL_GUID;
 	struct efi_smbios_record *record;
 	efi_smbios_protocol_t *smbios;
 	efi_status_t status;
 	u16 handle = 0xfffe;
 
-	status = efi_bs_call(locate_protocol, &EFI_SMBIOS_PROTOCOL_GUID, NULL,
+	status = efi_bs_call(locate_protocol, &smbios_guid, NULL,
 			     (void **)&smbios) ?:
 		 efi_call_proto(smbios, get_next, &handle, &type, &record, NULL);
 	if (status != EFI_SUCCESS)
diff --git a/drivers/firmware/efi/libstub/x86-stub.c b/drivers/firmware/efi/libstub/x86-stub.c
index cef32e2c82d8..cb0abe13a6c4 100644
--- a/drivers/firmware/efi/libstub/x86-stub.c
+++ b/drivers/firmware/efi/libstub/x86-stub.c
@@ -335,6 +335,7 @@ static bool apple_match_product_name(void)
 
 static void apple_set_os(void)
 {
+	static efi_guid_t apple_set_os_guid = APPLE_SET_OS_PROTOCOL_GUID;
 	struct {
 		unsigned long version;
 		efi_status_t (__efiapi *set_os_version)(const char *);
@@ -345,7 +346,7 @@ static void apple_set_os(void)
 	if (!efi_is_64bit() || !apple_match_product_name())
 		return;
 
-	status = efi_bs_call(locate_protocol, &APPLE_SET_OS_PROTOCOL_GUID, NULL,
+	status = efi_bs_call(locate_protocol, &apple_set_os_guid, NULL,
 			     (void **)&set_os);
 	if (status != EFI_SUCCESS)
 		return;
diff --git a/drivers/firmware/efi/libstub/zboot.c b/drivers/firmware/efi/libstub/zboot.c
index 4b76f74c56da..4a5ffe164873 100644
--- a/drivers/firmware/efi/libstub/zboot.c
+++ b/drivers/firmware/efi/libstub/zboot.c
@@ -34,6 +34,7 @@ struct sysfb_display_info *alloc_primary_display(void)
 asmlinkage efi_status_t __efiapi
 efi_zboot_entry(efi_handle_t handle, efi_system_table_t *systab)
 {
+	static efi_guid_t loaded_image_guid = LOADED_IMAGE_PROTOCOL_GUID;
 	char *cmdline_ptr __free(efi_pool) = NULL;
 	unsigned long image_base, alloc_size;
 	efi_loaded_image_t *image;
@@ -42,7 +43,7 @@ efi_zboot_entry(efi_handle_t handle, efi_system_table_t *systab)
 	WRITE_ONCE(efi_system_table, systab);
 
 	status = efi_bs_call(handle_protocol, handle,
-			     &LOADED_IMAGE_PROTOCOL_GUID, (void **)&image);
+			     &loaded_image_guid, (void **)&image);
 	if (status != EFI_SUCCESS) {
 		efi_err("Failed to locate parent's loaded image protocol\n");
 		return status;

-- 
2.55.0

