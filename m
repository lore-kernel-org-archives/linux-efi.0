From: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Subject: [PATCH V5 1/3] x86/efi: Make efi_delete_dummy_variable() use set_variable_nonblocking() instead of set_variable()
Date: Mon, 28 May 2018 19:21:02 -0700
Message-ID: <1527560464-19466-2-git-send-email-sai.praneeth.prakhya@intel.com>
References: <1527560464-19466-1-git-send-email-sai.praneeth.prakhya@intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1527560464-19466-1-git-send-email-sai.praneeth.prakhya@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Sai Praneeth <sai.praneeth.prakhya@intel.com>, Lee Chun-Yi <jlee@suse.com>, Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>, Will Deacon <will.deacon@arm.com>, Dave Hansen <dave.hansen@intel.com>, Mark Rutland <mark.rutland@arm.com>, Bhupesh Sharma <bhsharma@redhat.com>, Naresh Bhat <naresh.bhat@linaro.org>, Ricardo Neri <ricardo.neri@intel.com>, Peter Zijlstra <peterz@infradead.org>, Ravi Shankar <ravi.v.shankar@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Dan Williams <dan.j.williams@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
List-Id: linux-efi@vger.kernel.org

From: Sai Praneeth <sai.praneeth.prakhya@intel.com>

Presently, efi_delete_dummy_variable() uses set_variable() which might
block and hence kernel prints stack trace with a warning "bad:
scheduling from the idle thread!". So, make efi_delete_dummy_variable()
use set_variable_nonblocking(), which, as the name suggests doesn't
block.

Signed-off-by: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
Suggested-by: Andy Lutomirski <luto@kernel.org>
Cc: Lee Chun-Yi <jlee@suse.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Bhupesh Sharma <bhsharma@redhat.com>
Cc: Naresh Bhat <naresh.bhat@linaro.org>
Cc: Ricardo Neri <ricardo.neri@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ravi Shankar <ravi.v.shankar@intel.com>
Cc: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
---
 arch/x86/platform/efi/quirks.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/arch/x86/platform/efi/quirks.c b/arch/x86/platform/efi/quirks.c
index 36c1f8b9f7e0..6af39dc40325 100644
--- a/arch/x86/platform/efi/quirks.c
+++ b/arch/x86/platform/efi/quirks.c
@@ -105,12 +105,11 @@ early_param("efi_no_storage_paranoia", setup_storage_paranoia);
 */
 void efi_delete_dummy_variable(void)
 {
-	efi.set_variable((efi_char16_t *)efi_dummy_name,
-			 &EFI_DUMMY_GUID,
-			 EFI_VARIABLE_NON_VOLATILE |
-			 EFI_VARIABLE_BOOTSERVICE_ACCESS |
-			 EFI_VARIABLE_RUNTIME_ACCESS,
-			 0, NULL);
+	efi.set_variable_nonblocking((efi_char16_t *)efi_dummy_name,
+				     &EFI_DUMMY_GUID,
+				     EFI_VARIABLE_NON_VOLATILE |
+				     EFI_VARIABLE_BOOTSERVICE_ACCESS |
+				     EFI_VARIABLE_RUNTIME_ACCESS, 0, NULL);
 }
 
 /*
-- 
2.7.4
