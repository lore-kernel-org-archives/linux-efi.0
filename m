From: Sylvain Chouleur <sylvain.chouleur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 3/3] efi: implement interruptible runtime services
Date: Thu, 11 Feb 2016 15:23:11 +0100
Message-ID: <CAD_mUW16=jzSXDzwazo6rHVxT4X6-Cwqxsuv_JmVZpMjoprLZQ@mail.gmail.com>
References: <1452119637-10958-1-git-send-email-sylvain.chouleur@gmail.com>
 <1452702762-27216-1-git-send-email-sylvain.chouleur@gmail.com>
 <1452702762-27216-4-git-send-email-sylvain.chouleur@gmail.com> <20160211141937.GD4134@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160211141937.GD4134-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Sylvain Chouleur <sylvain.chouleur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

2016-02-11 15:19 GMT+01:00 Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>:
> Did you have any luck binding this driver to the other
> Broxton-specific drivers?
>
> Additionally, you're going to want to make sure that
> efi_enabled(EFI_OLD_MEMMAP) is false in efi_interruptible_init(),
> otherwise you can't use the new EFI page table scheme, e.g. if someone
> boots with efi=old_map.

I didn't have very much time to work on this but yes, we should be
able to make efi_interruptible a platform driver which would be probed
by SPD driver or something like that.
I'll upload it as soon as I've something

-- 
Sylvain
