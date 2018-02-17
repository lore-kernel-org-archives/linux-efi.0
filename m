From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/2] efivars: reading variables can generate SMIs
Date: Sat, 17 Feb 2018 09:36:56 +0000
Message-ID: <CAKv+Gu982mt==TaBRpwLLOLrX03zVJ+RznqCgDrxGNctJUVQVA@mail.gmail.com>
References: <20180215182208.35003-1-joe.konno@linux.intel.com>
 <CAKv+Gu80pJ5tbGoJqBm8CCKrEZXdkE83c944383KbQ5jREUC0Q@mail.gmail.com>
 <1518814319.4419.10.camel@HansenPartnership.com> <3908561D78D1C84285E8C5FCA982C28F7B37942B@ORSMSX110.amr.corp.intel.com>
 <20180216220536.liew4p4kqmaxwmfh@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180216220536.liew4p4kqmaxwmfh-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Joe Konno <joe.konno-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jeremy Kerr <jk-mnsaURCQ41sdnm+yROfE0A@public.gmane.org>, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 16 February 2018 at 22:05, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Fri, Feb 16, 2018 at 09:09:30PM +0000, Luck, Tony wrote:
>> > That said, I'm not sure how many non-root users run the toolkit to
>> > extract their EFI certificates or check on the secure boot status of
>> > the system, but I suspect it might be non-zero: I can see the tinfoil
>> > hat people wanting at least to check the secure boot status when they
>> > log in.
>>
>> Another fix option might be to rate limit EFI calls for non-root users (on X86
>> since only we have the SMI problem). That would:
>>
>> 1) Avoid using memory to cache all the variables
>> 2) Catch any other places where non-root users can call EFI
>
> I could get behind that as well.  Currently the things I maintain do
> approximately this many normal accesses with invocations you can do as a
> user:
>
> "efibootmgr -v" - six files we always try to read, plus one per Boot####
>                   entry.
> "fwupdate --info" - one file it always tries to read, one file for each
>                     ESRT entry.
> "dbxtool -l" - one file it always reads.
> "mokutil --sb-state" - reads the same file twice.  I don't maintain
>                        this, but I'll send a patch to Gary to make it
>                        only read it once.  AFAICS all of the other
>                        invocations you can currently do as a user
>                        /legitimately/ read two files, though.
>
> Some systems seem to *love* making a pile of Boot#### entries; I think
> the most I've seen is something like 16.  So on that machine, one
> "efibootmgr -v" invocation is ~22 efivars files read.  I've never seen a
> machine that advertised more than 2 ESRT entries, but maybe we'll get
> there some day.
>

Would rate limiting (but not only for non-root) help mitigate Spectre
v1 issues in UEFI runtime services code as well? I have been looking
into unmapping the entire kernel while such calls are in progress,
because firmware is likely to remain vulnerable long after the OSes
have been fixed, and we may be able to kill two birds with one stone
here (and not break userland in the process)
