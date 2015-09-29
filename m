From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 1/2] x86/efi: Map EFI memmap entries in-order at runtime
Date: Tue, 29 Sep 2015 15:18:07 +0100
Message-ID: <20150929141807.GB4401@codeblueprint.co.uk>
References: <1443218539-7610-1-git-send-email-matt@codeblueprint.co.uk>
 <1443218539-7610-2-git-send-email-matt@codeblueprint.co.uk>
 <20150926055643.GA25877@gmail.com>
 <20150926134329.GA3144@codeblueprint.co.uk>
 <20150927070355.GB26125@gmail.com>
 <CAKv+Gu8M2pmzfeA=NT4c44E6-PQvRKHZjEJt78mryGcp6bBD8w@mail.gmail.com>
 <20150928082245.GA28796@gmail.com>
 <CAKv+Gu-e5CRrJ1S7phXyWCUZ10ptukn0zr0wDGyX14H_SpEp1Q@mail.gmail.com>
 <20150929091230.GA2023@gmail.com>
 <CAKv+Gu8GpaHRL8EZxJCs8dw8ngFVoYNP1Q=hqhZ=LOF+3vXPLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8GpaHRL8EZxJCs8dw8ngFVoYNP1Q=hqhZ=LOF+3vXPLw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Lee, Chun-Yi" <jlee-IBi9RG/b67k@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, James Bottomley <JBottomley-wo1vFcy6AUs@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Denys Vlasenko <dvlasenk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 29 Sep, at 12:41:23PM, Ard Biesheuvel wrote:
> 
> OK, fair enough. I agree that setting the flag for 32-bit would be
> semantically correct. I will leave it to Matt to comment whether it is
> reasonable in terms of changes to other parts of the code.

It should be pretty minimal. Let me take a swing at the patch.
 
-- 
Matt Fleming, Intel Open Source Technology Center
