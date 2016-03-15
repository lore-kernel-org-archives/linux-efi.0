From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH] x86/efi: Always map boot service regions into new EFI
 page tables
Date: Tue, 15 Mar 2016 17:05:32 +0100
Message-ID: <20160315160532.GG4559@pd.tnic>
References: <1457695163-29632-2-git-send-email-matt@codeblueprint.co.uk>
 <1457888975.3884.9.camel@talk21.com>
 <20160313215847.GA2619@codeblueprint.co.uk>
 <20160313230736.GB2619@codeblueprint.co.uk>
 <20160314103019.GA32573@gmail.com>
 <20160314113502.GC2619@codeblueprint.co.uk>
 <20160314120502.GA17388@gmail.com>
 <20160314142734.GE2619@codeblueprint.co.uk>
 <20160314164700.GA21726@gmail.com>
 <20160315155418.GH2619@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160315155418.GH2619-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Scott Ashcroft <scott.ashcroft-qw6QB7/foO7QT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maarten Lankhorst <maarten.lankhorst-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Ben Hutchings <ben-/+tVBieCtBitmTQ+vhA3Yw@public.gmane.org>, Raphael Hertzog <hertzog-8fiUuRrzOP0dnm+yROfE0A@public.gmane.org>, Roger Shimizu <rogershimizu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexis Murzeau <amurzeau-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Josh Poimboeuf <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Mar 15, 2016 at 03:54:18PM +0000, Matt Fleming wrote:
> Fengguang, do you run coccinelle scripts currently as part of the
> 0-day lkp build machinery?

Not only that - it generates patches too. For example:

https://lkml.kernel.org/r/20160303015519.GA43500@lkp-nex06

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
