From: Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] Make efi-pstore return a unique id
Date: Wed, 20 Nov 2013 17:29:12 +0800
Message-ID: <87r4abmnfb.fsf@redhat.com>
References: <87ppqk6qvx.fsf@redhat.com> <CAFLxGvz3pCevxE43zGnrbX4MxPmwyb=9MVNpzFRpELt1+AmtrA@mail.gmail.com> <CA+8MBbJefz7L-C-LnhAAXB5zf-8XoMPhESPU4yd0wnuZ_YqO1w@mail.gmail.com> <A5ED84D3BB3A384992CBB9C77DEDA4D47F9DD941@USINDEM103.corp.hds.com> <52740A3A.70202@nod.at>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <52740A3A.70202-/L3Ra7n9ekc@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Cc: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>, Tony Luck <tony.luck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "matt.fleming@intel.com" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, =?utf-8?B?6LCi5oiQ6aqP?= <bbboson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


richard-/L3Ra7n9ekc@public.gmane.org writes:

> Am 01.11.2013 20:22, schrieb Seiji Aguchi:
>>>
>>> Agreed.  I liked your ((timestamp * 100 + part) * 100 + count function much
>>> more than this.
>> 
>> I was worried that the part and count could be more than 100.
>> If it happens, the id may not be unique...
>> 
>> But, currently, size of nvram storage is limited, so it is a corner case.
>> I respect your opinion.
>
> What about feeding the bytes of all three integers into a
> non-cryptographic hash function?

Then will lost the sequence of our log. We will get lots of entries like
"dmesg-efi-`unique but meaningless number here`" in pstore fs. Who will
know which file is the latest record?
A possible way is sort them by created time. But pstore splits large
messages into many parts. So they will have the same created-time. Like
the following case:
[root@dhcp-13-41 ~]# ls -rtl /dev/pstore/
total 0
-r--r--r--. 1 root root  930 Nov 15 08:42 dmesg-efi-9
-r--r--r--. 1 root root 1017 Nov 15 08:42 dmesg-efi-8
-r--r--r--. 1 root root  993 Nov 15 08:42 dmesg-efi-7
-r--r--r--. 1 root root  984 Nov 15 08:42 dmesg-efi-6
-r--r--r--. 1 root root 1008 Nov 15 08:42 dmesg-efi-5
-r--r--r--. 1 root root  909 Nov 15 08:42 dmesg-efi-10
-r--r--r--. 1 root root 1003 Nov 15 08:42 dmesg-efi-11
-r--r--r--. 1 root root  980 Nov 18 00:41 dmesg-efi-4
-r--r--r--. 1 root root  990 Nov 18 00:41 dmesg-efi-3
-r--r--r--. 1 root root  966 Nov 18 00:41 dmesg-efi-2
-r--r--r--. 1 root root 1010 Nov 18 00:41 dmesg-efi-1

or more intuitive:
ls /sys/firmware/efi/efivars/ | grep -i "dump" | cut -d'-' -f5 | sort |wc -l
103
ls /sys/firmware/efi/efivars/ | grep -i "dump" | cut -d'-' -f5 | sort |uniq |wc -l
26

So if we using a hashed unique number for uniqueness, we will lose the
sequence. We must sort them manually.

And another side, the combin of timestamp, count and part is unique. Why
we generate a unique number from a unique number?
if you think "making a string from three ints and then a parse it to a
int again" is odd, i'd like to use ((timestamp * 100 + part) * 100 +
count.

> Using this way you get a cheap unique id.
>
> Thanks,
> //richard
