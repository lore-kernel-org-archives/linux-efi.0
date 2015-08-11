From: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>
Subject: [PATCH v2 16/16] PM / hibernate: Document signature verification of hibernate snapshot
Date: Tue, 11 Aug 2015 14:16:36 +0800
Message-ID: <1439273796-25359-17-git-send-email-jlee@suse.com>
References: <1439273796-25359-1-git-send-email-jlee@suse.com>
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <1439273796-25359-1-git-send-email-jlee@suse.com>
Sender: linux-pm-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Matt Fleming <matt.fleming@intel.com>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>, "Lee, Chun-Yi" <jlee@suse.com>
List-Id: linux-efi@vger.kernel.org

Reviewed-by: Jiri Kosina <jkosina@suse.com>
Tested-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
---
 Documentation/power/swsusp-signature-verify.txt | 86 +++++++++++++++++++++++++
 1 file changed, 86 insertions(+)
 create mode 100644 Documentation/power/swsusp-signature-verify.txt

diff --git a/Documentation/power/swsusp-signature-verify.txt b/Documentation/power/swsusp-signature-verify.txt
new file mode 100644
index 0000000..7ba4a3f
--- /dev/null
+++ b/Documentation/power/swsusp-signature-verify.txt
@@ -0,0 +1,86 @@
+Signature verification of hibernate snapshot
+============================================
+
+1) Introduction
+2) How to enable
+3) How does it work
+4) Trigger key re-generate
+
+1) Introduction
+---------------------
+
+The hibernate function provided by kernel was used to snapshot memory
+to be a image for keeping in storage, then restored in appropriate time.
+There have potential threat from hacking the memory snapshot image.
+Cracker may triggers hibernating process through ioctl to grab snapshot
+image, then restoring modified image back to memory. Another situation
+is booting to other hacked OS to modify the snapshot image in swap
+partition or file, then user may runs malware after image restored to
+memory. In addition, the above weakness cause kernel is not fully trusted
+in EFI secure boot environment.
+
+So, kernel hibernate function needs a mechanism to verify integrity of
+hibernate snapshot image.
+
+The origin idea is from Jiri Kosina: Let EFI bootloader generates key-pair
+in UEFI secure boot environment, then forwarding keys to boot kernel for
+signing/verifying snapshot image.
+
+
+2) How to enable
+-----------------
+
+If the HIBERNATE_VERIFICATION compile option is true, kernel hibernate code
+will generating and verifying the signature of memory snapshot image by
+HMAC-SHA1 algorithm. Current solution relies on EFI stub on x86 architecture,
+so the signature verification logic will be bypassed on legacy BIOS.
+
+When the snapshot image unsigned or signed with an unknown key, the signature
+verification will be failed. The default behavior of verifying failed is
+accept restoring image but tainting kernel with H taint flag.
+
+Like kernel module signature checking, there's both a config option and
+a boot parameter which control whether we accept or stop whole recovery
+process when verification failed. Using HIBERNATE_VERIFICATION_FORCE kernel
+compile option or "sigenforce" kernel parameter to force hibernate recovery
+process stop when verification failed.
+
+
+3) How does it work
+-------------------
+
+For signing hibernate image, kernel need a key for generating signature of
+image. The origin idea is using PKI, the EFI bootloader, shim generates key
+pair and forward to boot kernel for signing/verifying image. In Linux Plumbers
+Conference 2013, we got response from community experts for just using
+symmetric key algorithm to generate signature, that's simpler and no EFI
+bootloader's involving.
+
+Current solution is using HMAC-SHA1 algorithm, it generating HMAC key in EFI
+stub by using RDRAND, RDTSC and EFI RNG protocol to grab random number to be
+the entropy of key. Then the HMAC key stored in efi boot service variable,
+key's security relies on EFI secure boot: When EFI secure boot enabled, only
+trusted efi program allowed accessing boot service variables.
+
+In every EFI stub booting stage, it loads key from variable then forward key
+to boot kernel for waiting to sign snapshot image by user trigger hibernating.
+The HMAC-SHA1 algorithm generates signature then kernel put signature to the
+header with the memory snapshot image. The signature with image is delivered
+to userspace hibernating application or direct stored in swap partition.
+
+When hibernate recovering, kernel will verify the image signature before
+switch whole system to image kernel and image memory space. When verifying
+failed, kernel is tainted or stop recovering and discarding image.
+
+
+4) Trigger key re-generate
+--------------------------
+
+The hibernate signature verifying function allows user to trigger the key
+re-generating process in EFI stub through SNAPSHOT_REGENERATE_KEY ioctl.
+
+User can raise a key-regen flag in kernel through ioctl. When system runs
+normal shutdown or reboot, kernel writes a efi runtime variable as a flag
+then EFI stub will query the flag in next boot cycle. To avoid the hibernation
+key changes in hibernating cycle that causes hibernate restoring failed,
+the regen flag will be clear in a hibernate cycle.
-- 
2.1.4

