From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 5/8] efi: Get the secure boot status [ver #6]
Date: Fri, 27 Jan 2017 14:01:01 +0000
Message-ID: <20170127140101.GD31613@codeblueprint.co.uk>
References: <20170123212642.GA2766@codeblueprint.co.uk>
 <20170116144954.GB27351@codeblueprint.co.uk>
 <20170111143304.GA29649@codeblueprint.co.uk>
 <148120020832.5854.5448601415491330495.stgit@warthog.procyon.org.uk>
 <148120024570.5854.10638278395097394138.stgit@warthog.procyon.org.uk>
 <7948.1484148443@warthog.procyon.org.uk>
 <794.1484581158@warthog.procyon.org.uk>
 <6306.1485209503@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <6306.1485209503@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: ard.biesheuvel@linaro.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, linux-arm-kernel@lists.infradead.org, "H. Peter Anvin" <hpa@zytor.com>, Peter Jones <pjones@redhat.com>, Michael Chang <mchang@suse.com>
List-Id: linux-efi@vger.kernel.org

On Mon, 23 Jan, at 10:11:43PM, David Howells wrote:
> Matt Fleming <matt@codeblueprint.co.uk> wrote:
> 
> > >  (4) extract_kernel() calls sanitize_boot_params() which would otherwise clear
> > >      the secure-boot flag.
> >  
> > The ->sentinel flag should be clear (because you zero'd boot_params on
> > alloc), so the code inside of sanitize_boot_params() should never
> > trigger for the secure boot case.
> 
> But it *does* trigger, otherwise I wouldn't've noticed this.

This looks like it's triggered because of a grub2 bug, if I'm reading
the code correctly (big if).

grub2 memcpy()'s 1024 bytes from the start of kernel image header into
the allocated (and zeroed) boot_params object. Unfortunately, it
should only be copying the second 512-byte chunk, not the first too.

The boot loader should only fill out those fields in the first 512
bytes that it understands. Everything else should be zero, which
allows us to add fields (and give them default non-zero values in the
header) in the future without breaking old boot loaders.

Something like this might fix it (not compiled tested). Could one of
the grub2 folks take a look?

---->8----

diff --git a/grub-core/loader/i386/efi/linux.c b/grub-core/loader/i386/efi/linux.c
index 010bf98..fe5771e 100644
--- a/grub-core/loader/i386/efi/linux.c
+++ b/grub-core/loader/i386/efi/linux.c
@@ -269,7 +269,7 @@ grub_cmd_linux (grub_command_t cmd __attribute__ ((unused)),
   loaded=1;
 
   lh.code32_start = (grub_uint32_t)(grub_uint64_t) kernel_mem;
-  grub_memcpy (params, &lh, 2 * 512);
+  grub_memcpy (params, (grub_uint8_t *)&lh[512], 512);
 
   params->type_of_loader = 0x21;
 
