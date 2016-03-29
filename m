From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH RFC 1/1] x86: fix bad memory access in
 fb_is_primary_device()
Date: Tue, 29 Mar 2016 13:12:01 +0100
Message-ID: <20160329121201.GB3625@codeblueprint.co.uk>
References: <1455528649-26629-1-git-send-email-alpopov@ptsecurity.com>
 <20160216075521.GA27491@gmail.com>
 <20160216134918.GD2769@codeblueprint.co.uk>
 <20160216151859.GB11373@redhat.com>
 <56E01B0F.3000306@ptsecurity.com>
 <56F52111.6050500@ptsecurity.com>
 <20160329115347.GA3625@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160329115347.GA3625-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alexander Popov <alpopov-rHsQqRFQpp1OSnsfY10OVw@public.gmane.org>
Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Tomi Valkeinen <tomi.valkeinen-l0cyMroinI0@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 29 Mar, at 12:53:47PM, Matt Fleming wrote:
> On Fri, 25 Mar, at 02:29:21PM, Alexander Popov wrote:
> > 
> > Excuse me, there is no reply for a long time. Did I touch any taboo topic?
> > Hope to fix this bug. Thanks.
> 
> Unless anyone complains soonish I'll send this to tip as part of the
> EFI urgent queue.

Oh, looks like this issue was already fixed here,

  https://lkml.kernel.org/r/tip-743146db071c4a828159211a295d12ff4f61752f-Ckxz5ZWcFp/9qxiX1TGQuw@public.gmane.org
