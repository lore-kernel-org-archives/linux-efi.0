From: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
Subject: Re: [PATCH] Make efi-pstore return a unique id
Date: Fri, 01 Nov 2013 21:08:26 +0100
Message-ID: <52740A3A.70202@nod.at>
References: <87ppqk6qvx.fsf@redhat.com> <CAFLxGvz3pCevxE43zGnrbX4MxPmwyb=9MVNpzFRpELt1+AmtrA@mail.gmail.com> <CA+8MBbJefz7L-C-LnhAAXB5zf-8XoMPhESPU4yd0wnuZ_YqO1w@mail.gmail.com> <A5ED84D3BB3A384992CBB9C77DEDA4D47F9DD941@USINDEM103.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D47F9DD941-ohthHghroY0jroPwUH3sq+6wyyQG6/Uh@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Cc: Tony Luck <tony.luck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, =?GB2312?B?0Luzyb+l?= <bbboson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Am 01.11.2013 20:22, schrieb Seiji Aguchi:
>>>> +{
>>>> +       char id_str[64];
>>>> +       u64 id = 0;
>>>> +
>>>> +       sprintf(id_str, "%lu%u%d", timestamp, part, count);
>>>> +       if (kstrtoull(id_str, 10, &id))
>>>> +               pr_warn("efi-pstore: failed to generate id\n");
>>>> +       return id;
>>>> +}
>>>
>>> This is just odd. You make a string from three ints and then a parse
>>> it to a int again.
>>
>> Agreed.  I liked your ((timestamp * 100 + part) * 100 + count function much
>> more than this.
> 
> I was worried that the part and count could be more than 100.
> If it happens, the id may not be unique...
> 
> But, currently, size of nvram storage is limited, so it is a corner case.
> I respect your opinion.

What about feeding the bytes of all three integers into a non-cryptographic hash function?
Using this way you get a cheap unique id.

Thanks,
//richard
