From: Madper Xie <cxie@redhat.com>
Subject: Re: [BUG]: DELL XPS 8500 become a brick after fill too many entries to nvram.
Date: Wed, 13 Nov 2013 20:57:49 +0800
Message-ID: <878uws1msy.fsf@redhat.com>
References: <87fvr3h3b9.fsf@redhat.com> <20131111110701.GE22636@console-pimps.org> <87eh6nt8oo.fsf@redhat.com> <20131113112052.GJ22636@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <20131113112052.GJ22636@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>
Cc: Madper Xie <cxie@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Matt Fleming <matt.fleming@intel.com>
List-Id: linux-efi@vger.kernel.org


matt@console-pimps.org writes:

> On Mon, 11 Nov, at 08:38:31PM, Madper Xie wrote:
>> 
>> matt@console-pimps.org writes:
>> 
>> > On Mon, 11 Nov, at 02:15:22PM, Madper Xie wrote:
>> >> Howdy all,
>> >>   For now we ensure at least ~5kb free space. But my dell xps still
>> >>   become a brick after I add too many entries to my nvram. So maybe 5kb
>> >>   is not safe enough. and 5kb is just aginst Samsung's laptop.
>> >>   So should we enlarge EFI_MIN_RESERVE?
>> >
>
> OK, that's pretty conclusive. Thanks.
>
Ouch, Sorry. My mistake. Seems filling too much entries to nvram is not
the murderer...
For testing, I using following command to fill my nvram:
head -c20480 /dev/urandom | efibootmgr --quiet --create --append-binary-args - 

For occupy lots of nvram space, I run it many times. But when I try to
find the threshold, I find the real murderer is that command. I mean my
dell xps will bricked even if I just run the command once and have more
than 100kb free space...

So the murderer is the new added boot entry. I don't really know if it's
still a bug. And I apologize for my mistake. :-(
>  
> Have you been able to calculate the safe limit of NVRAM we need to
> reserve to avoid bricking your machine?
>
> I was interested in the DMI and other firmware strings from dmesg.


-- 
Best,
Madper Xie.
