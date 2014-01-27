From: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] efi: Add newline to cper DIMM location messages
Date: Mon, 27 Jan 2014 11:25:14 -0800
Message-ID: <CA+55aFwRE6DNoigx0xN7ZTc8dbCqHZdTopfwYOVuK_0vhZe0rw@mail.gmail.com>
References: <52e6a8d812916d47b@agluck-desk.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52e6a8d812916d47b-E6Nu+q68HHTI/KE9syI0vLvm/XP+8Wra@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Chen, Gong" <gong.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, Jan 27, 2014 at 10:43 AM, Luck, Tony <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> We forgot the newline at the end of two messages. Add it.

So I don't think the patch is necessarily wrong, but does it actually matter?

The thing is, unless the next printk is a continuation (PR_CONT), the
newline should be added at that point. And if it isn't, then that's a
bug. So I'm wondering how this issue got noticed - does it actually
cause user-visible issues, or was it just code reading?

Because I'm wondering if we eventually should start thinking of that
final '\n' as pointless noise... The fact is, printk has different
semantics from printf, and maybe we should start taking advantage of
that rather than just slavishly follow tradition?

               Linus
