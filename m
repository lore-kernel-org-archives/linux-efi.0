From: Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] pstore: avoid incorrectly mark entry as duplicate
Date: Mon, 28 Oct 2013 21:36:57 +0800
Message-ID: <87iowhv7nq.fsf@redhat.com>
References: <87r4bcdok1.fsf@redhat.com> <CA+8MBb+0wruR-T8Rkk_WQ6Try4ct2ZCm8o=js4eO8s7cogcs+g@mail.gmail.com> <87k3h35xij.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <87k3h35xij.fsf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tony Luck <tony.luck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, "linux-efi@vger.kernel.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel@vger.kernel.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>, Lenny Szubowicz <lszubowi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?utf-8?B?5oiQ6aqPIOiwog==?= <bbboson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Howdy Tony,
  Does this patch still need some rework?
  
cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org writes:

> tony.luck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org writes:
>
>> On Wed, Oct 23, 2013 at 7:55 AM, Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>> The "duplicate" entries won't appear in pstorefs. And a complain will be
>>> print -- pstore: failed to load 76 record(s) from 'efi'
>>
>> Maybe I don't quite get this - but it sounds like you have a whole lot
>> of entries using up space in efivars that have similar names - differing
>> just in the timestamp - that won't show up in the pstore filesystem - because
>> we'd try to name them all the same thing.
>>
> Maybe I misunderstand you...
>
> Sure pstore try to name them all the same thing, but it's another
> issue. and it doesn't prevent entries showing up in pstore fs.
>
> Consider the following case: (after efi-pstore support append mode, it
> always like this case):
>
> I choose four dumped efivars from my DELL XPS:
> dump-type0-9-1-1380441690-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
> dump-type0-9-1-1380448560-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
> dump-type0-9-1-1380460890-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
> dump-type0-9-1-1382496073-cfc8fc79-be2e-4ddc-97f0-9f98bfe298a0
>          ^        ^       [              ^                   ]
>          !        !                      !
>        type    timestamp                GUID
>
> When pstore load them from efivars, pstore incorrectly assuming that
> efivars with the same TYPE, ID and GUID are duplicate.
>
> list_for_each_entry(pos, &allpstore, list) {
> 	if (pos->type == type &&    /---
> 	    pos->id == id &&     <-| as I said, it only check type,id,psi
> 	    pos->psi == psi) {      \---
> 		rc = -EEXIST;    <- then set -EEXIST, and ignore *dup* entry
> 		break;
> 	}
> }
> You can see the code above, for those four entries, only one could be
> showed in pstorefs, all others will get a -EEXIST. So I add a timestamp
> check here, it's the only different part.
>
>> How did all those things end up in efivars?
> before the patch I can see 
> dmesg-efi-1   dmesg-efi-11  dmesg-efi-3  dmesg-efi-5  dmesg-efi-7  dmesg-efi-9
> dmesg-efi-10  dmesg-efi-2   dmesg-efi-4  dmesg-efi-6  dmesg-efi-8
> after apply the patch:
> [root@dhcp-13-41 vars]# ls /dev/pstore/
> dmesg-efi-1  dmesg-efi-1   dmesg-efi-11  dmesg-efi-2  dmesg-efi-3  dmesg-efi-5  dmesg-efi-6  dmesg-efi-8
> dmesg-efi-1  dmesg-efi-10  dmesg-efi-11  dmesg-efi-2  dmesg-efi-3  dmesg-efi-5  dmesg-efi-7  dmesg-efi-8
> dmesg-efi-1  dmesg-efi-10  dmesg-efi-12  dmesg-efi-2  dmesg-efi-4  dmesg-efi-5  dmesg-efi-7  dmesg-efi-8
> dmesg-efi-1  dmesg-efi-10  dmesg-efi-13  dmesg-efi-2  dmesg-efi-4  dmesg-efi-5  dmesg-efi-7  dmesg-efi-9
> dmesg-efi-1  dmesg-efi-10  dmesg-efi-14  dmesg-efi-2  dmesg-efi-4  dmesg-efi-5  dmesg-efi-7  dmesg-efi-9
> dmesg-efi-1  dmesg-efi-10  dmesg-efi-15  dmesg-efi-2  dmesg-efi-4  dmesg-efi-5  dmesg-efi-7  dmesg-efi-9
> dmesg-efi-1  dmesg-efi-10  dmesg-efi-16  dmesg-efi-3  dmesg-efi-4  dmesg-efi-5  dmesg-efi-7  dmesg-efi-9
> dmesg-efi-1  dmesg-efi-10  dmesg-efi-2   dmesg-efi-3  dmesg-efi-4  dmesg-efi-6  dmesg-efi-7  dmesg-efi-9
> dmesg-efi-1  dmesg-efi-10  dmesg-efi-2   dmesg-efi-3  dmesg-efi-4  dmesg-efi-6  dmesg-efi-7  dmesg-efi-9
> dmesg-efi-1  dmesg-efi-10  dmesg-efi-2   dmesg-efi-3  dmesg-efi-4  dmesg-efi-6  dmesg-efi-8  dmesg-efi-9
> dmesg-efi-1  dmesg-efi-11  dmesg-efi-2   dmesg-efi-3  dmesg-efi-4  dmesg-efi-6  dmesg-efi-8  dmesg-efi-9
> dmesg-efi-1  dmesg-efi-11  dmesg-efi-2   dmesg-efi-3  dmesg-efi-4  dmesg-efi-6  dmesg-efi-8  dmesg-efi-9
> dmesg-efi-1  dmesg-efi-11  dmesg-efi-2   dmesg-efi-3  dmesg-efi-5  dmesg-efi-6  dmesg-efi-8
> dmesg-efi-1  dmesg-efi-11  dmesg-efi-2   dmesg-efi-3  dmesg-efi-5  dmesg-efi-6  dmesg-efi-8
> dmesg-efi-1  dmesg-efi-11  dmesg-efi-2   dmesg-efi-3  dmesg-efi-5  dmesg-efi-6  dmesg-efi-8
>
>>
>> Wouldn't the right fix be to make pstore allow them all to appear (using the
>> timestamp to differentiate names?) so that we could see them, log them,
>> and then remove them from pstore (in turn freeing up efivars space - which
>> people keep telling me is in short supply).
>>
> Yeah, many file have the same name, just like my case above. But it not
> really block the file shows up and should be solved in another
> patch. And I'm trying fix it.
>> -Tony


-- 
Best,
Madper Xie.
