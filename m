From: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: 4.9-rc1 boot regression, ambiguous bisect result
Date: Wed, 19 Oct 2016 21:04:29 -0700
Message-ID: <CAPcyv4gDYcahNJ6CEzf2eUGq8sGqW8Yo09T8cscGWTLoja7PXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi,

I am currently unable to boot a Yoga 900 with latest mainline, but 4.8 boots.

The symptom is a reboot before the video console is available.

I bisected to commit 816e76129ed5 "efi: Allow drivers to reserve boot
services forever".  However, that commit is known to be broken.  The
proposed fix, commit 92dc33501bfb "x86/efi: Round EFI memmap
reservations to EFI_PAGE_SIZE", also exhibits the reboot problem.

During the bisect some of the stopping points landed on commits that
caused the boot process to hang rather than cause a reboot.  The
commits that resulted in a hang are marked "git bisect skip" in this
log: https://gist.github.com/djbw/1b501daa98192a42ae848f03bb59c30e

I'll try treating those hangs as bad bisect results and re-run the
full bisect tomorrow.  In the meantime I wonder if the bisect log
implicates a better regression candidate?
