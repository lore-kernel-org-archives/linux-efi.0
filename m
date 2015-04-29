From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC 3/3] efi: add capsule update capability via sysfs
Date: Wed, 29 Apr 2015 16:39:54 -0700
Message-ID: <CALCETrWhe7YWYME0CLo4py1QYOaYptqWDZtrUdnFocdC6SqbLg@mail.gmail.com>
References: <1430348859.2189.37.camel@HansenPartnership.com>
 <1430349130.2189.43.camel@HansenPartnership.com> <CALCETrV8bRj_CmCwZfHSV8bMF-vv0sab_7v5t0rpdhx2ib=wPw@mail.gmail.com>
 <1430350592.2189.50.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430350592.2189.50.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Apr 29, 2015 at 4:36 PM, James Bottomley
<James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
> On Wed, 2015-04-29 at 16:25 -0700, Andy Lutomirski wrote:
>> On Wed, Apr 29, 2015 at 4:12 PM, James Bottomley
>> <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
>> > From: James Bottomley <JBottomley-O3H1v1f1dlM@public.gmane.org>
>> >
>> > The firmware update should be applied simply by doing
>> >
>> > cat fw_file > /sys/firmware/capsule/update
>> >
>> > With a properly formatted fw_file.  Any error will be returned on close of
>> > stdout.  util-linux returns errors correctly from closing stdout, but firmware
>> > shippers should check whatever utilities package they use correctly captures
>> > the error return on close.
>>
>> s/util-linux/coreutils/
>>
>> This still makes my API sense itch.  It's kind of an abuse of
>> open/write/close.
>
> It works ... and according to Alan, NFS is already doing it.  I suppose
> we can have a do over of the whole debate again ...

I think that NFS is at least writing to actual files as opposed to
trying to implement some kind of transactions.

Blech, whatever.  This approach certainly works, as long as no one
trips over the busybox thing.  Maybe there should also be
/sys/something_that_errors_on_close that people can use as a test.

--Andy
