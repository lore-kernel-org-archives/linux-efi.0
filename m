From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: Re: [PATCH v2 3/3] efi: Capsule update with user helper interface
Date: Tue, 10 Mar 2015 10:31:09 -0700
Message-ID: <CALCETrUEVKePqm2EsKsL8B4YLFDBf+1=4YHB5W-5ViS5MFBf2g@mail.gmail.com>
References: <F54AEECA5E2B9541821D670476DAE19C2B8AC95C@PGSMSX102.gar.corp.intel.com>
 <F54AEECA5E2B9541821D670476DAE19C2B8AC9DD@PGSMSX102.gar.corp.intel.com>
 <20150306213912.GA8020@fenchurch.internal.datastacks.com> <20150310122652.GA17573@codeblueprint.co.uk>
 <20150310152155.GB1208@fenchurch.internal.datastacks.com> <CALCETrXMvDqMvRf2yzRvpjHQB5pip5zNiihAccCc9Sm5UWGysg@mail.gmail.com>
 <20150310154000.GD1208@fenchurch.internal.datastacks.com> <CALCETrUDuTt_BK1JSFU=_EEujpm1ekzmkte-c3vxuRW7hWPUPQ@mail.gmail.com>
 <20150310172603.GF1208@fenchurch.internal.datastacks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150310172603.GF1208-FS9oOTXHwv9t4tGkRPVz9tcb/sdHg95EuydrBrBl+0sAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Mar 10, 2015 at 10:26 AM, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, Mar 10, 2015 at 08:51:59AM -0700, Andy Lutomirski wrote:
>> On Tue, Mar 10, 2015 at 8:40 AM, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> >
>> >> >> So, for the sysfs interface, let's not allow loading from /lib. Let's
>> >> >> not require a userland tool. Let's just do,
>> >> >>
>> >> >>   # echo /path/to/my/awesome/capsule.bin > /sys/../capsule
>> >> >
>> >> >>
>> >> >> and be done with it.
>> >> >>
>> >> >> Hmmm?
>> >> >
>> >> > I assume you're implying a) the capsule header with the guid is embedded
>> >> > in the .bin there already, and b) one contiguous write(2) with error
>> >> > reporting coming through something like vars.c's efi_status_to_err()?
>> >> >
>> >> > If so, yes, I prefer this API.
>> >> >
>> >>
>> >> Is using a char device really so bad?  I have a "simple_char" that
>> >> makes this really easy that's pending review.
>> >
>> > As long as there's straightforward propagation of the EFI_STATUS return
>> > from UpdateCapsule() back, sysfs file vs char device makes very little
>> > difference to me.  Either way it's open(), write(), close().  Using the
>> > runtime firmware upload interface designed for wifi and scsi devices is
>> > the part I don't really like.
>> >
>>
>> I'm not 100% happy with write(2) (which is all we have in sysfs) for
>> two reasons:
>>
>> 1. If we write a file name, eww.  That's more complicated, requires
>> temporary files, has annoying mount namespace issues, etc.
>>
>> 2. If we write the full contents, we need to do it in a single call to
>> write.  That means that we can't use cat, which mostly defeats the
>> purpose.  In fact, using cat could be actively harmful.
>
> So if what we wind up with is:
>
> fd = open("/sys/.../capsule", O_RDWR);
> write(fd, buf, size/N);
> ...
> write(fd, buf + M*size/N, size/N);
> close(fd);
>
> You're suggesting the error code would post on close()?  My worry about
> that is that I imagine a lot less code in the wild checks the error code
> on close() than on write() - though gnu cat does do so on both.  But
> there are other questions still - will it post on fdatasync()?  On
> fsync()?

Cat, for example, doesn't check any of the above, which is why I don't
like this approach.

--Andy
