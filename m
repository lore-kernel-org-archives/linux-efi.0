From: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Wed, 31 Oct 2012 17:04:26 +0100 (CET)
Message-ID: <alpine.LNX.2.00.1210311703560.12781@pobox.suse.cz>
References: <1348152065-31353-1-git-send-email-mjg@redhat.com> <alpine.LRH.2.00.1210290848450.10392@twin.jikos.cz> <20121029174131.GC7580@srcf.ucam.org> <alpine.LNX.2.00.1210311444080.12781@pobox.suse.cz>
 <CA+5PVA63EHiXbGAox+FmJPvztSj_i7QgnDG8vdj=p0xE+dqgGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+5PVA63EHiXbGAox+FmJPvztSj_i7QgnDG8vdj=p0xE+dqgGQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Matthew Garrett <mjg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 31 Oct 2012, Josh Boyer wrote:

> I have a patch that disables that.  I imagine it will be included in the
> next submission of the patchset.
> 
> You can find it here in the meantime:
> 
> http://jwboyer.fedorapeople.org/pub/0001-hibernate-Disable-in-a-Secure-Boot-environment.patch

I don't see that patch touching kernel/power/user.c, so using 's2disk' to 
suspend machine seems to be still possible even with this patch applied, 
right?

-- 
Jiri Kosina
SUSE Labs
