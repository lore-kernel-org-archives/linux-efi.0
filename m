From: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH 07/27] kexec_file: Disable at runtime if securelevel has
 been set
Date: Mon, 30 Oct 2017 12:43:58 -0400
Message-ID: <1509381838.3583.134.camel@linux.vnet.ibm.com>
References: <1509032805.5886.52.camel@linux.vnet.ibm.com>
         <20171026074243.GM8550@linux-l9pv.suse>
         <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
         <150842468754.7923.10037578333644594134.stgit@warthog.procyon.org.uk>
         <1508774083.3639.124.camel@linux.vnet.ibm.com>
         <26694.1509030144@warthog.procyon.org.uk>
         <32764.1509378584@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32764.1509378584-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: joeyli <jlee-IBi9RG/b67k@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jforbes-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 2017-10-30 at 15:49 +0000, David Howells wrote:
> Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
> 
> > Huh?!  With the "secure_boot" policy enabled on the boot command line,
> > IMA-appraisal would verify the kexec kernel image, firmware, kernel
> > modules, and custom IMA policy signatures.
> 
> What happens if the "secure_boot" policy isn't enabled on the boot command
> line?  Can you sum up both cases in a paragraph I can add to the patch
> description?

The other patch automatically enables "secure_boot" for lockdown mode.
So there is no need to specify "secure_boot" on the boot command line.
 Reordering the patches so that the other patch comes before any call
to is_ima_appraise_enabled() will simplify this patch description.

> > Other patches in this patch series need to be updated as well to check
> > if IMA-appraisal is enabled.
> 
> Which exactly?  I've added your "!is_ima_appraise_enabled() &&" line to
> kexec_file() and module_sig_check().  Anything else?

load_module(), which calls module_sig_check(), is called by both the
old and new kernel module syscalls.  IMA is only on the new syscall.
 Did you differentiate between the kernel module syscalls?

There doesn't seem to be any other patches affected.  That said, the
IMA "secure_boot" policy is more stringent than what you have without
it.  For example, with the "secure_boot" policy enabled, firwmware
needs to be signed as well.  At some point, we'll want to also require
the initramfs be signed as well.

Both methods work independently of each other, but there needs to be
better coordination for when both methods are enabled at the same time
(eg. are both signatures required?).

For testing purposes, you can use the same certs/signing_key to sign
the kexec image, kernel modules and firmware, by loading the
signing_key on the .ima keyring.  Using evmctl, sign the files
(eg. evmctl ima_sign -a sha256 -k certs/signing_key.pem  --imasig
/boot/<vmlinuz>).

Mimi
