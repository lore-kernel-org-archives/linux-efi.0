From: jerry.hoemann-VXdhtT5mjnY@public.gmane.org
Subject: Re: [PATCH 0/3] Early use of boot service memory
Date: Tue, 12 Nov 2013 14:52:00 -0700
Message-ID: <20131112215200.GB22363@anatevka.fc.hp.com>
References: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com>
 <CAOJsxLEoN2uYR9V3bowv2O7F8L5t+kVrdehHW151cEcfgx-oJg@mail.gmail.com>
 <20131112175500.GA22363@anatevka.fc.hp.com>
 <CAOJsxLEU1SPd=1C8QPgrZGWeOuyOVkozuMR014xBpJTxyFviKA@mail.gmail.com>
Reply-To: jerry.hoemann-VXdhtT5mjnY@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAOJsxLEU1SPd=1C8QPgrZGWeOuyOVkozuMR014xBpJTxyFviKA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Rob Landley <rob-VoJi6FS/r0vR7s880joybQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, x86 maintainers <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yinghai Lu <yinghai-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "list-T1Yj925okcpg9hUCZPvPmw@public.gmane.org:DOCUMENTATION <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>,
	list-T1Yj925okcpg9hUCZPvPmw@public.gmane.org:MEMORY MANAGEMENT <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>," <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 12, 2013 at 08:48:51PM +0200, Pekka Enberg wrote:
> Hi Jerry,
> 
> On Tue, Nov 12, 2013 at 7:55 PM,  <jerry.hoemann-VXdhtT5mjnY@public.gmane.org> wrote:
> > My change does not address platforms that have misbehaving firmware.
> > It just allows platforms that don't have this issue to avoid issues
> > that the call to efi_reserve_boot_services presents.
> 
> The problem I have with your patch is that it (1) relies on users to
> pass a kernel option and (2) leaves machines with "faulty firmware" out
> in the cold.  So I'm wondering if we can fix reserve_crashkernel() to
> deal with reality that there indeed are broken firmware out there?
> 
> If someone is able to come up with a convincing argument why crashkernel
> cannot be fixed on such machines, we'd need to start whitelisting known
> good firmwares, no?
> 
>                            Pekka


Hi Pekka,

I'm cc'ing Matthew Garrett who has the background in the original
problem that efi_reserve_boot_services was used to work around.

Matthew, sorry for not CC'ing you initially.

Also, a more specific message from Matthew from the earlier thread:

	https://lkml.org/lkml/2013/8/7/750

I was anticipating this extended argument to be used by distros
that support servers.  While technically still a problem on smaller
systems, the crash kernel size requirement for larger systems makes
the issue much more apparent.  Also, having this in distros could help
enforce proper behaving platforms going forward as companies will
want to get their platforms certified.

I don't believe the proposed change "hurts" the platforms that
efi_reserve_boot_services was added to protect.  They'll function
as they do now,  they just shouldn't add the new argument.

I've conducted a couple test previously: https://lkml.org/lkml/2013/9/18/457.

Moving reserve crash_kernel after efi_free_boot_services failed.
While moving it before efi_reserve_boot_services seems to work,
this would also move it before trim_platform_memory_ranges, which I was
concerned would break other platforms.


If we were to go to a list method,  i'd rather we tried to define
the blacklist of platforms that require the efi_reserve_boot_services
workaround.

In testing new platforms, its much easier to assume that the platform works.
Only if it doesn't work, and the platform hardware/firmware defects
can't be fixed, then we can black list it.

The issue on how to work around EFI bugs before has been discussed,
but I don't recall seeing a resolution.  If I missed this, point
me in right direction.  :)

thanks

Jerry


-- 

----------------------------------------------------------------------------
Jerry Hoemann            Software Engineer              Hewlett-Packard/MODL

3404 E Harmony Rd. MS 57                        phone:  (970) 898-1022
Ft. Collins, CO 80528                           FAX:    (970) 898-XXXX
                                                email:  jerry.hoemann-VXdhtT5mjnY@public.gmane.org
----------------------------------------------------------------------------
