From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: Re: [PATCH v2 3/3] efi: Capsule update with user helper interface
Date: Tue, 10 Mar 2015 08:26:40 -0700
Message-ID: <CALCETrXMvDqMvRf2yzRvpjHQB5pip5zNiihAccCc9Sm5UWGysg@mail.gmail.com>
References: <F54AEECA5E2B9541821D670476DAE19C2B8AC95C@PGSMSX102.gar.corp.intel.com>
 <F54AEECA5E2B9541821D670476DAE19C2B8AC9DD@PGSMSX102.gar.corp.intel.com>
 <20150306213912.GA8020@fenchurch.internal.datastacks.com> <20150310122652.GA17573@codeblueprint.co.uk>
 <20150310152155.GB1208@fenchurch.internal.datastacks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150310152155.GB1208-FS9oOTXHwv9t4tGkRPVz9tcb/sdHg95EuydrBrBl+0sAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Mar 10, 2015 at 8:21 AM, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, Mar 10, 2015 at 12:26:52PM +0000, Matt Fleming wrote:
>> On Fri, 06 Mar, at 04:39:12PM, Peter Jones wrote:
>> >
>> > So again: do we really need or want to do this?
>>
>> One thing that we totally lose the ability to do is use the capsule
>> interface for things *other* than firmware updates, e.g.
>>
>>  https://lkml.org/lkml/2013/10/16/327
>>
>> Also, requiring embedded or custom OS to include fwupdate into their
>> existing boot solutions is a bit heavy handed when literally all they
>> want to do is cat a binary blob to a sysfs file.
>>
>> I don't see why we can't have both solutions.
>
> Yeah - we clearly need a kernel interface for some embedded devices, and
> it'd be better for every vendor to not implement it themselves.
>
>> Another thing is that ESRT isn't going to be supported by every
>> platform.
>
> Yeah - though I think you're *mostly* talking about the same platforms
> as above.
>
>> So, for the sysfs interface, let's not allow loading from /lib. Let's
>> not require a userland tool. Let's just do,
>>
>>   # echo /path/to/my/awesome/capsule.bin > /sys/../capsule
>
>>
>> and be done with it.
>>
>> Hmmm?
>
> I assume you're implying a) the capsule header with the guid is embedded
> in the .bin there already, and b) one contiguous write(2) with error
> reporting coming through something like vars.c's efi_status_to_err()?
>
> If so, yes, I prefer this API.
>

Is using a char device really so bad?  I have a "simple_char" that
makes this really easy that's pending review.

--Andy

> --
>         Peter



-- 
Andy Lutomirski
AMA Capital Management, LLC
