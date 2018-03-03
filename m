From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/30] security, efi: Add kernel lockdown
Date: Fri, 2 Mar 2018 17:18:01 -0800
Message-ID: <20180302171801.6ed00ef19e0b970d90094556@linux-foundation.org>
References: <151024863544.28329.2436580122759221600.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <151024863544.28329.2436580122759221600.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: linux-security-module@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, jforbes@redhat.com
List-Id: linux-efi@vger.kernel.org

On Thu,  9 Nov 2017 17:30:36 +0000 David Howells <dhowells@redhat.com> wrote:

> Here's a set of patches to institute a "locked-down mode" in the kernel and
> to trigger that mode if the kernel is booted in secure-boot mode or through
> the command line.
> 
> Enabling CONFIG_LOCK_DOWN_KERNEL makes lockdown mode available.
> 
> Enabling CONFIG_ALLOW_LOCKDOWN_LIFT_BY_SYSRQ will allow a SysRq combination
> to lift the lockdown.  On x86 this is SysRq+x.  The keys must be pressed on
> an attached keyboard.
> 
> Enabling CONFIG_LOCK_DOWN_IN_EFI_SECURE_BOOT will cause EFI secure boot to
> trigger kernel lockdown.
> 
> Inside the kernel, kernel_is_locked_down() is used to check if the kernel
> is in lockdown mode.
> 
> Note that the secure boot mode entry doesn't work if the kernel is booted
> from older versions of i386/x86_64 Grub as there's a bug in Grub whereby it
> doesn't initialise the boot_params correctly.  The incorrect initialisation
> causes sanitize_boot_params() to be triggered, thereby zapping the secure
> boot flag determined by the EFI boot wrapper.
> 
> A manual page, kernel_lockdown.7, is proposed, to which people will be
> directed by messages in dmesg.  This lists the features that are restricted
> amongst other things.  [Note: I need to update this to mention IMA, so I'll
> reply with that later].

I saw all this pop up in linux-next and got curious.

This changelog didn't uncurious me at all.  The
LOCK_DOWN_IN_EFI_SECURE_BOOT Kconfig help is unilluminating.  A bit of
googling led me to kernel_lockdown.7 (https://lwn.net/Articles/735564/)
which kinda helped.

But still.  This is a big, straggly feature and presumably is still
missing things and presumably will require ongoing maintenance as we
add new kernel capabilities.  What do we get in return for all of this?
What are the usecases for this feature and why would anyone want one? 
What's the value to our users?

Thanks.
