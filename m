From: Jiri Kosina <jikos-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 08/16] x86/efi: Carrying hibernation key by setup
 data
Date: Sun, 16 Aug 2015 23:23:01 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1508162321100.27871@pobox.suse.cz>
References: <1439273796-25359-1-git-send-email-jlee@suse.com> <1439273796-25359-9-git-send-email-jlee@suse.com> <20150815170737.GA25353@Nokia-N900>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150815170737.GA25353@Nokia-N900>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Cc: "Lee, Chun-Yi" <joeyli.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Len Brown <len.brown-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Josh Boyer <jwboyer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vojtech Pavlik <vojtech-AlSwsSmVLrQ@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sat, 15 Aug 2015, Pavel Machek wrote:

> > For forwarding hibernation key from EFI stub to boot kernel, this patch
> > allocates setup data for carrying hibernation key, size and the status
> > of efi operating.
> > 
> > Reviewed-by: Jiri Kosina <jkosina-IBi9RG/b67k@public.gmane.org>
> 
> Jiri, are you sure you reviewed these? This is not really
> english, afaict, and efi/EFI should be spelled consistently.

Yes, I did review the code and the fact that it is still in compliance 
with my original idea. I think you can blame me on not reviewing 
changelogs super-rigorously though, so all suggestions for improvements 
are absolutely welcome.

Thanks,

-- 
Jiri Kosina
SUSE Labs
