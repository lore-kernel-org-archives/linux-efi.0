From: Dave Young <dyoung@redhat.com>
Subject: [PATCH] kexec_file: do not add extra alignment to efi memmap
Date: Tue, 17 Apr 2018 16:36:00 +0800
Message-ID: <20180417083600.GA1972@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: joeyli <jlee@suse.com>, Randy Wright <rwright@hpe.com>, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Chun-Yi reported a kernel warning message below:
WARNING: CPU: 0 PID: 0 at ../mm/early_ioremap.c:182 early_iounmap+0x4f/0x12c()
early_iounmap(ffffffffff200180, 00000118) [0] size not consistent 00000120

The problem is x86 kexec_file_load adds extra alignment to the efi memmap:
in bzImage64_load()
        efi_map_sz = efi_get_runtime_map_size();
        efi_map_sz = ALIGN(efi_map_sz, 16);

And __efi_memmap_init maps with the size including the alignment bytes
but efi_memmap_unmap use nr_maps * desc_size which does not include the
extra bytes.

The alignment in kexec code is only needed for the kexec buffer internal use
Actually kexec should pass exact size of the efi memmap to 2nd kernel.

Signed-off-by: Dave Young <dyoung@redhat.com>
Reported-by: joeyli <jlee@suse.com>
Tested-by: Randy Wright <rwright@hpe.com>
---
 arch/x86/kernel/kexec-bzimage64.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- linux.orig/arch/x86/kernel/kexec-bzimage64.c
+++ linux/arch/x86/kernel/kexec-bzimage64.c
@@ -398,11 +398,10 @@ static void *bzImage64_load(struct kimag
 	 * little bit simple
 	 */
 	efi_map_sz = efi_get_runtime_map_size();
-	efi_map_sz = ALIGN(efi_map_sz, 16);
 	params_cmdline_sz = sizeof(struct boot_params) + cmdline_len +
 				MAX_ELFCOREHDR_STR_LEN;
 	params_cmdline_sz = ALIGN(params_cmdline_sz, 16);
-	kbuf.bufsz = params_cmdline_sz + efi_map_sz +
+	kbuf.bufsz = params_cmdline_sz + ALIGN(efi_map_sz, 16) +
 				sizeof(struct setup_data) +
 				sizeof(struct efi_setup_data);
 
@@ -410,7 +409,7 @@ static void *bzImage64_load(struct kimag
 	if (!params)
 		return ERR_PTR(-ENOMEM);
 	efi_map_offset = params_cmdline_sz;
-	efi_setup_data_offset = efi_map_offset + efi_map_sz;
+	efi_setup_data_offset = efi_map_offset + ALIGN(efi_map_sz, 16);
 
 	/* Copy setup header onto bootparams. Documentation/x86/boot.txt */
 	setup_header_size = 0x0202 + kernel[0x0201] - setup_hdr_offset;
