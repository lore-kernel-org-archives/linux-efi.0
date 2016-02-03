From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 10/14] efi: Make checkpatch complain less about efi.h
 GUID additions
Date: Wed, 3 Feb 2016 12:27:05 +0100
Message-ID: <20160203112704.GA27850@gmail.com>
References: <1454364428-494-1-git-send-email-matt@codeblueprint.co.uk>
 <1454364428-494-11-git-send-email-matt@codeblueprint.co.uk>
 <20160203103335.GA7310@gmail.com>
 <20160203104432.GA2597@codeblueprint.co.uk>
 <20160203105035.GB21257@gmail.com>
 <20160203111838.GB2597@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160203111838.GB2597-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


* Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:

> On Wed, 03 Feb, at 11:50:35AM, Ingo Molnar wrote:
> > 
> > Hm, so the GUIDs are line-broken in the same fashion in the spec, after the third 
> > parameter?
>  
> Yep, they are.
> 
> > That's a strong reason indeed - and then the changelog and title should say that: 
> > 're-format GUID tables to follow the format of the UEFI spec'. That it also 
> > pacifies checkpatch is a side effect.
> 
> I think that's a fair change.
> 
> Peter could you take a look at updating the changelog in a v2? If not,
> I'll do it.

Note that I applied most of your patches to tip:efi/core, which I've just pushed 
out. You might want to base v2 on that.

Thanks,

	Ingo
