From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 06/24] Add a sysrq option to exit secure boot mode
Date: Fri, 14 Apr 2017 19:15:41 +0100
Message-ID: <CAKv+Gu-FDzdqACyr_z6Zsgb51mg8Lc0YgfLs4oGURWnX4WewSw@mail.gmail.com>
References: <149142326734.5101.4596394505987813763.stgit@warthog.procyon.org.uk>
 <149142332458.5101.14654616837280513947.stgit@warthog.procyon.org.uk> <alpine.DEB.2.20.1704142003570.2327@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1704142003570.2327@nanos>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kyle McMartin <kyle-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <matthew.garrett-05XSO3Yj/JvQT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 14 April 2017 at 19:05, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> wrote:
> On Wed, 5 Apr 2017, David Howells wrote:
>
>> From: Kyle McMartin <kyle-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>
>> Make sysrq+x exit secure boot mode on x86_64, thereby allowing the running
>> kernel image to be modified.  This lifts the lockdown.
>>
>> Signed-off-by: Kyle McMartin <kyle-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
>
> Matt, Ard?
>
> Any opinions on this?
>

>From an EFI point of view, there is not a lot to see here. I think
having a SysRq to lift lockdown makes sense, although I think we
should avoid 'secure boot' when referring to lockdown because they are
really two different things. As someone else pointed out, you may have
other ways of trusting your kernel, in which case you should be able
to lock it down as well.

That does bring me to another EFI related point: many of these patches
are x86 specific for no good reason. We have been working really hard
over the past couple of years to move EFI plumbing into
drivers/firmware/efi, and things are not intimately related to an
architecture should ideally be implemented there. Looking at the
diffstat of this patch, I don't see why this should be a x86 only
feature.

In general, though, I think this should be two patches, one that
introduces the functionality to restrict some SysRq keys to console
only, and one that adds the 'x' for lockdown lift.

I haven't gotten around to responding to David's general email
regarding the point of all of this. I will do so asap, but it will
need to wait until Tuesday at least.

-- 
Ard.


On 14 April 2017 at 19:05, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> wrote:
> On Wed, 5 Apr 2017, David Howells wrote:
>
>> From: Kyle McMartin <kyle-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>
>> Make sysrq+x exit secure boot mode on x86_64, thereby allowing the running
>> kernel image to be modified.  This lifts the lockdown.
>>
>> Signed-off-by: Kyle McMartin <kyle-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
>
> Matt, Ard?
>
> Any opinions on this?
>
> Thanks,
>
>         tglx
