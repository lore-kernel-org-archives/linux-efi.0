From: Tony Luck <tony.luck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] pstore: avoid incorrectly mark entry as duplicate
Date: Wed, 23 Oct 2013 14:57:02 -0700
Message-ID: <CA+8MBb+0wruR-T8Rkk_WQ6Try4ct2ZCm8o=js4eO8s7cogcs+g@mail.gmail.com>
References: <87r4bcdok1.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87r4bcdok1.fsf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>, Lenny Szubowicz <lszubowi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?B?5oiQ6aqPIOiwog==?= <bbboson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Oct 23, 2013 at 7:55 AM, Madper Xie <cxie-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> The "duplicate" entries won't appear in pstorefs. And a complain will be
> print -- pstore: failed to load 76 record(s) from 'efi'

Maybe I don't quite get this - but it sounds like you have a whole lot
of entries using up space in efivars that have similar names - differing
just in the timestamp - that won't show up in the pstore filesystem - because
we'd try to name them all the same thing.

How did all those things end up in efivars?

Wouldn't the right fix be to make pstore allow them all to appear (using the
timestamp to differentiate names?) so that we could see them, log them,
and then remove them from pstore (in turn freeing up efivars space - which
people keep telling me is in short supply).

-Tony
