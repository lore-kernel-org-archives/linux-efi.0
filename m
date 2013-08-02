From: "Clea F. Rees" <reescf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: EFI stub boots only with setup_efi_pc() commented
Date: Sat, 3 Aug 2013 00:06:23 +0100
Message-ID: <CA+n4xYYJhoXp6KSeROda9ErrXZ0hFEBM-x-0Obvk3fmHwABfKw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Matt Fleming asked me to email describing a problem I am experiencing
with the EFI stub loader. Matt has been trying to diagnose the cause
of consistent failures of the stub loader in recent kernels on my
machine.

Background: All kernels I tried in 3.7.* booted fine using the stub
loader (via rEFInd). No kernels tried from 3.8.* through 3.9.* and now
into 3.10.* boot using the stub loader. None of the workarounds which
others have used work for me. The problem is reproducible using a
direct NVRAM entry rather than rEFInd. All kernels boot fine with
GRUB.

The problem is reproducible with a kernel compiled from git. A series
of experiments (following Matt's instructions) have determined that
commenting out the call to setup_efi_pc() in eboot.c makes the kernels
boot.

I would be happy to provide any further information which might be
helpful or to run further tests.
