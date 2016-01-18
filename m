From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: v4.4-rc8 based tip tree kernel hangs on boot.
Date: Mon, 18 Jan 2016 15:40:01 +0000
Message-ID: <20160118154001.GA2607@codeblueprint.co.uk>
References: <20160110192921.GD17012@linux.vnet.ibm.com>
 <20160111140140.GA2644@codeblueprint.co.uk>
 <20160112103043.GA5707@gmail.com>
 <20160115162011.GA2935@linux.vnet.ibm.com>
 <20160115222921.GA5378@codeblueprint.co.uk>
 <20160117173248.GA28841@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160117173248.GA28841-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Srikar Dronamraju <srikar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sun, 17 Jan, at 11:02:48PM, Srikar Dronamraju wrote:
> 
> Unfortunately even with your below patch on top of c9f2a9a ("x86/efi:
> Hoist page table switching code into efi_call_virt()" also fails to boot
> with and without CONFIG_DEBUG_WX=y. I have added CONFIG_EFI_PGT_DUMP.

What about if you comment out the call to efi_dump_pagetable()? What
if you return early from efi_sync_low_kernel_mappings(), e.g.

diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 71121a9d06cf..e1f8ebb88f84 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -177,6 +177,8 @@ void efi_sync_low_kernel_mappings(void)
 		init_mm.pgd + pgd_index(PAGE_OFFSET),
 		sizeof(pgd_t) * num_pgds);
 
+	return;
+
 	/*
 	 * We can share all PGD entries apart from the one entry that
 	 * covers the EFI runtime mapping space.

Do either of those modifications make your kernel boot when you apply
the patch I sent on Friday? If so, which one? I'm struggling to find
hardware that's similar enough to reproduce this.
