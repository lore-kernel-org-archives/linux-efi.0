From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: Re: [PATCH v2 3/3] efi: Capsule update with user helper interface
Date: Tue, 10 Mar 2015 08:51:59 -0700
Message-ID: <CALCETrUDuTt_BK1JSFU=_EEujpm1ekzmkte-c3vxuRW7hWPUPQ@mail.gmail.com>
References: <F54AEECA5E2B9541821D670476DAE19C2B8AC95C@PGSMSX102.gar.corp.intel.com>
 <F54AEECA5E2B9541821D670476DAE19C2B8AC9DD@PGSMSX102.gar.corp.intel.com>
 <20150306213912.GA8020@fenchurch.internal.datastacks.com> <20150310122652.GA17573@codeblueprint.co.uk>
 <20150310152155.GB1208@fenchurch.internal.datastacks.com> <CALCETrXMvDqMvRf2yzRvpjHQB5pip5zNiihAccCc9Sm5UWGysg@mail.gmail.com>
 <20150310154000.GD1208@fenchurch.internal.datastacks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150310154000.GD1208@fenchurch.internal.datastacks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Jones <pjones@redhat.com>
Cc: Matt Fleming <matt@console-pimps.org>, "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, Sam Protsenko <semen.protsenko@linaro.org>, Ming Lei <ming.lei@canonical.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Ong, Boon Leong" <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Mar 10, 2015 at 8:40 AM, Peter Jones <pjones@redhat.com> wrote:
>
>> >> So, for the sysfs interface, let's not allow loading from /lib. Let's
>> >> not require a userland tool. Let's just do,
>> >>
>> >>   # echo /path/to/my/awesome/capsule.bin > /sys/../capsule
>> >
>> >>
>> >> and be done with it.
>> >>
>> >> Hmmm?
>> >
>> > I assume you're implying a) the capsule header with the guid is embedded
>> > in the .bin there already, and b) one contiguous write(2) with error
>> > reporting coming through something like vars.c's efi_status_to_err()?
>> >
>> > If so, yes, I prefer this API.
>> >
>>
>> Is using a char device really so bad?  I have a "simple_char" that
>> makes this really easy that's pending review.
>
> As long as there's straightforward propagation of the EFI_STATUS return
> from UpdateCapsule() back, sysfs file vs char device makes very little
> difference to me.  Either way it's open(), write(), close().  Using the
> runtime firmware upload interface designed for wifi and scsi devices is
> the part I don't really like.
>

I'm not 100% happy with write(2) (which is all we have in sysfs) for
two reasons:

1. If we write a file name, eww.  That's more complicated, requires
temporary files, has annoying mount namespace issues, etc.

2. If we write the full contents, we need to do it in a single call to
write.  That means that we can't use cat, which mostly defeats the
purpose.  In fact, using cat could be actively harmful.


--Andy
