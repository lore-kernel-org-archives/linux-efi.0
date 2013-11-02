From: Tony Luck <tony.luck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Make efi-pstore return a unique id
Date: Fri, 1 Nov 2013 17:17:00 -0700
Message-ID: <CA+8MBbKMRw28Ubr5F8U=5SKuaeutR+KEVDgJC70Xebj4O5BzpA@mail.gmail.com>
References: <87ppqk6qvx.fsf@redhat.com>
	<CAFLxGvz3pCevxE43zGnrbX4MxPmwyb=9MVNpzFRpELt1+AmtrA@mail.gmail.com>
	<CA+8MBbJefz7L-C-LnhAAXB5zf-8XoMPhESPU4yd0wnuZ_YqO1w@mail.gmail.com>
	<A5ED84D3BB3A384992CBB9C77DEDA4D47F9DD941@USINDEM103.corp.hds.com>
	<52740A3A.70202@nod.at>
	<A5ED84D3BB3A384992CBB9C77DEDA4D47F9DDA4D@USINDEM103.corp.hds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D47F9DDA4D-ohthHghroY0jroPwUH3sq+6wyyQG6/Uh@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>
Cc: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, =?UTF-8?B?6LCi5oiQ6aqP?= <bbboson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, Nov 1, 2013 at 1:57 PM, Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org> wrote:
>> What about feeding the bytes of all three integers into a non-cryptographic hash function?
>> Using this way you get a cheap unique id.
>
> It is reasonable to me.

How does efivars backend handle "unlink(2)" in the pstore file system.
pstore will call the backend->erase function passing the "id".  The
backend should then erase the right record from persistent storage.

With the  ((timestamp * 100 + part) * 100 + count function - you can
easily reverse it to find timestamp, part and count - would that make life
easier for the backend to find the record to be erased?  If you use a
hash function you will need to check each record and compute the
hash to see if it matches (probably not a big deal because the backend
will generally only hold a handful of records).

-Tony
