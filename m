From: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Wed, 31 Oct 2012 16:55:04 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1210311653080.12781@pobox.suse.cz>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com> <alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz> <20121029174131.GC7580@srcf.ucam.org> <alpine.LNX.2.00.1210311444080.12781@pobox.suse.cz> <CA+5PVA63EHiXbGAox+FmJPvztSj_i7QgnDG8vdj=p0xE+dqgGQ@mail.gmail.com>
 <20121031155503.1aaf4c93@pyramind.ukuu.org.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121031155503.1aaf4c93-38n7/U1jhRXW96NNrWNlrekiAK3p4hvP@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Cc: Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 31 Oct 2012, Alan Cox wrote:

> All this depends on your threat model. If I have physical access to
> suspend/resume your machine then you already lost. If I don't have
> physical access then I can't boot my unsigned OS to patch your S4 image
> so it doesn't matter.

Prepare (as a root) a hand-crafted image, reboot, let the kernel resume 
from that artificial image.

It can be viewed as a very obscure way of rewriting the kernel through 
/dev/mem (which is obviously not possible when in 'secure boot' 
environment).

-- 
Jiri Kosina
SUSE Labs
