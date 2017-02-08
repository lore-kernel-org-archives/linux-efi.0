From: Daniel Drake <drake-6IF/jdPJHihWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] efi/esrt: cleanup bad memory map log messages
Date: Wed, 8 Feb 2017 09:42:34 -0600
Message-ID: <CAD8Lp46MUW95vWVMayYYAwOyjOOze-ABc7Qj+RvtrbGVf46wtw@mail.gmail.com>
References: <20170207190823.10223-1-drake@endlessm.com> <20170208142201.bjwafwxykj3i2icu@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170208142201.bjwafwxykj3i2icu-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Upstreaming Team <linux-6IF/jdPJHihWk0Htik3J/w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Feb 8, 2017 at 8:22 AM, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> The machine you've got does seem to be presenting a valid (if poorly
> considered) table, but I don't quite think this is the right approach.

I don't think it is fully valid. Section 22.3 of the UEFI spec says:
"The ESRT shall be stored in memory of type EfiBootServicesData"

> The first hunk of your patch is fine, but the test on the result of
> efi_mem_desc_lookup() is more or less our check for "might reading this
> table reboot the system or worse".  You're demoting it to a warning
> while still /treating/ it as an error, so at least it remains safe,
> but the when we get to that point, they've (plausibly) given us data
> that could cause horrible behavior, and that is a thing worth logging an
> error about.

Although from the user's perspective (thinking about graphical
experience) it's a bit unfortunate to have early boot code like this
print a cryptic error on-screen, when the system is otherwise
perfectly usable and they might not even be interested in the ESRT's
functionality.

> It would be better to /check/ if it straddles multiple contiguous
> segments which both have reasonable access modes and print an error if
> there are gaps.  I'm still in favor of printing a warning to the log if
> it straddles them and there /aren't/ gaps, because we're *going* to see
> other weird bugs from any code base that decides it's stitching config
> tables together from separate allocations.  It's not a fundamentally
> reasonable thing to do, and as a lens it shows us some code with a
> really worrisome internal structure.

If I'm following your suggestion correctly I think it would not affect
the system I have here, where the ESRT sits entirely within a gap in
the memory map, without touching the allocations on either side.

Here is a dump of the memory map. type and pages are shown as decimal,
the other fields hex. The ESRT pointer is 0x7b141000.

attr=f type=7 addr=0 pages=1
attr=f type=2 addr=1000 pages=1
attr=f type=7 addr=2000 pages=141
attr=f type=10 addr=8f000 pages=1
attr=f type=7 addr=90000 pages=14
attr=f type=0 addr=9e000 pages=2
attr=f type=7 addr=100000 pages=3840
attr=f type=2 addr=1000000 pages=5817
attr=f type=7 addr=26b9000 pages=121159
attr=f type=0 addr=20000000 pages=512
attr=f type=7 addr=20200000 pages=124209
attr=f type=2 addr=3e731000 pages=6351
attr=f type=7 addr=40000000 pages=103375
attr=f type=2 addr=593cf000 pages=122940
attr=f type=7 addr=7740b000 pages=6
attr=f type=2 addr=77411000 pages=3110
attr=f type=1 addr=78037000 pages=259
attr=f type=4 addr=7813a000 pages=7910
attr=f type=7 addr=7a020000 pages=3806
attr=f type=3 addr=7aefe000 pages=533
attr=f type=0 addr=7b113000 pages=48
attr=f type=7 addr=7b143000 pages=261
attr=f type=10 addr=7b248000 pages=1287
attr=800000000000000f type=6 addr=7b74f000 pages=696
attr=800000000000000f type=5 addr=7ba07000 pages=106
attr=f type=7 addr=7ba71000 pages=1
attr=f type=4 addr=7ba72000 pages=4
attr=800000000000000f type=6 addr=7ba76000 pages=1
attr=f type=4 addr=7ba77000 pages=3
attr=800000000000000f type=6 addr=7ba7a000 pages=1
attr=f type=4 addr=7ba7b000 pages=1413
attr=8000000000000001 type=12 addr=e0000000 pages=16384
attr=8000000000000001 type=11 addr=fea00000 pages=256
attr=8000000000000001 type=11 addr=fec00000 pages=1
attr=8000000000000001 type=11 addr=fed01000 pages=1
attr=8000000000000001 type=11 addr=fed03000 pages=1
attr=8000000000000001 type=11 addr=fed06000 pages=1
attr=8000000000000001 type=11 addr=fed08000 pages=2
attr=8000000000000001 type=11 addr=fed1c000 pages=1
attr=8000000000000001 type=11 addr=fed80000 pages=64
attr=8000000000000001 type=11 addr=fee00000 pages=1
attr=8000000000000001 type=11 addr=ffc00000 pages=1024

Thanks
Daniel
