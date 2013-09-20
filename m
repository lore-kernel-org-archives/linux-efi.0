From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH 00/11] EFI runtime services virtual mapping
Date: Fri, 20 Sep 2013 13:29:15 +0100
Message-ID: <20130920122915.GB21381@console-pimps.org>
References: <1379602494-26684-1-git-send-email-bp@alien8.de>
 <20130920072904.GA21922@dhcp-16-126.nay.redhat.com>
 <20130920090544.GA9574@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130920090544.GA9574-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Fri, 20 Sep, at 11:05:44AM, Borislav Petkov wrote:
> On Fri, Sep 20, 2013 at 03:29:04PM +0800, Dave Young wrote:
> > Just tested this series, for 1st kernel It boots ok in qemu+ovmf. But
> > it immediately reboot on my Thinkpad T420. Unfortunately there's no
> > way to debug this very early problem because there's no serial port
> > also earlyprintk does not work for efi boot. No usb debug as well on
> > this machine. I will test it when I go back to work after the china
> > holiday.
> 
> Hmm, I'm booting with the efi boot stub, how do you do it?

Dave, could you try this patch?

---

diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 06e71c2..9bcc15c 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -207,6 +207,8 @@ ENTRY(startup_64)
 	jmp	preferred_addr
 
 ENTRY(efi_pe_entry)
+	movq	%cr3, %r15
+	movq	%r15, efi_scratch+16(%rip)
 	mov	%rcx, %rdi
 	mov	%rdx, %rsi
 	pushq	%rdi
@@ -219,6 +221,8 @@ ENTRY(efi_pe_entry)
 	popq	%rdi
 
 ENTRY(efi_stub_entry)
+	movq	%cr3, %r15
+	movq	%r15, efi_scratch+16(%rip)
 	call	efi_main
 	movq	%rax,%rsi
 	cmpq	$0,%rax

-- 
Matt Fleming, Intel Open Source Technology Center
