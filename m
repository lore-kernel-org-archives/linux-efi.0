From: Tony Luck <tony.luck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Make efi-pstore return a unique id
Date: Fri, 1 Nov 2013 11:58:17 -0700
Message-ID: <CA+8MBbJefz7L-C-LnhAAXB5zf-8XoMPhESPU4yd0wnuZ_YqO1w@mail.gmail.com>
References: <87ppqk6qvx.fsf@redhat.com>
	<CAFLxGvz3pCevxE43zGnrbX4MxPmwyb=9MVNpzFRpELt1+AmtrA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFLxGvz3pCevxE43zGnrbX4MxPmwyb=9MVNpzFRpELt1+AmtrA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Weinberger <richard.weinberger-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, =?UTF-8?B?6LCi5oiQ6aqP?= <bbboson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

>> +static u64 efi_generate_id(unsigned long timestamp, unsigned int part, int count)

I don't think the "efi_" prefix is needed here. For one thing the
function is static, so
no name space pollution worries. For another - it makes it look like
this is some thing
defined in EFI standard.  If "generate_id()" is too generic for your
tastes ... then a
"pstore_" prefix might be more appropriate.

>> +{
>> +       char id_str[64];
>> +       u64 id = 0;
>> +
>> +       sprintf(id_str, "%lu%u%d", timestamp, part, count);
>> +       if (kstrtoull(id_str, 10, &id))
>> +               pr_warn("efi-pstore: failed to generate id\n");
>> +       return id;
>> +}
>
> This is just odd. You make a string from three ints and then a parse
> it to a int again.

Agreed.  I liked your ((timestamp * 100 + part) * 100 + count function much
more than this.

-Tony
