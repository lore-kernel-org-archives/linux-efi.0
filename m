From: Madper Xie <bbboson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Make efi-pstore return a unique id
Date: Thu, 21 Nov 2013 21:53:07 +0800
Message-ID: <87txf5n9oc.fsf@gmail.com>
References: <87ppqk6qvx.fsf@redhat.com> <CAFLxGvz3pCevxE43zGnrbX4MxPmwyb=9MVNpzFRpELt1+AmtrA@mail.gmail.com> <CA+8MBbJefz7L-C-LnhAAXB5zf-8XoMPhESPU4yd0wnuZ_YqO1w@mail.gmail.com> <A5ED84D3BB3A384992CBB9C77DEDA4D47F9DD941@USINDEM103.corp.hds.com> <52740A3A.70202@nod.at> <87r4abmnfb.fsf@redhat.com> <A5ED84D3BB3A384992CBB9C77DEDA4D47FA0B6EF@USINDEM103.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <A5ED84D3BB3A384992CBB9C77DEDA4D47FA0B6EF-ohthHghroY0jroPwUH3sq+6wyyQG6/Uh@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Cc: Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Tony Luck <tony.luck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "matt.fleming@intel.com" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, =?utf-8?B?6LCi5oiQ6aqP?= <bbboson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org


seiji.aguchi-7rDLJAbr9SE@public.gmane.org writes:

>> Then will lost the sequence of our log. We will get lots of entries like
>> "dmesg-efi-`unique but meaningless number here`" in pstore fs. Who will
>> know which file is the latest record?
>
> Ah, that's good point.
>
>> And another side, the combin of timestamp, count and part is unique. Why
>> we generate a unique number from a unique number?
>> if you think "making a string from three ints and then a parse it to a
>> int again" is odd, i'd like to use ((timestamp * 100 + part) * 100 +
>> count.
>
> How about calculating the number of digit of part /count, instead of using fixed "100"?
> We can ensure the uniqueness of each id by doing it.
>
> digit_num = log2(part)/log2(10) + 1
> timestamp * 10^(digit_num + 1)
>
Then we must implement a log10 and a pow func...
And reverting id to timestamp, part and count will hard if we using
unfixed length of count and id.

So i'd like to using fixed length. My dell xps has 128kb nvram
space. and it at most store 126 pstore entries. So I think 1000 will be
a safe value for count. For part, 100 should be okay. I don't think
there will be a large kmsg and we must split it into more than 100 parts.

> Seiji
