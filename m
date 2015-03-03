From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: Re: [PATCH v2 3/3] efi: Capsule update with user helper interface
Date: Tue, 3 Mar 2015 21:49:56 +0100
Message-ID: <20150303204956.GG25768@pd.tnic>
References: <F54AEECA5E2B9541821D670476DAE19C2B8AD9CA@PGSMSX102.gar.corp.intel.com>
 <20150302122955.GB24476@codeblueprint.co.uk>
 <F54AEECA5E2B9541821D670476DAE19C2B8ADC41@PGSMSX102.gar.corp.intel.com>
 <CALCETrXfjbKcYSSRQXZbam7TgHU34LXM0BhvMuba_vYyCCPTig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALCETrXfjbKcYSSRQXZbam7TgHU34LXM0BhvMuba_vYyCCPTig-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Mar 03, 2015 at 12:37:54PM -0800, Andy Lutomirski wrote:
> The user *should not* be required to have write access to anything in
> /lib to install a UEFI capsule that they download from their
> motherboard vendor's website.  /lib belongs to the distro, and UEFI
> capsules do not belong to the distro.  In this regard, UEFI capsules
> are completely unlike your wireless card firmware, your cpu microcode,
> etc.

Oh oh but but, if an UEFI capsule can brick the system, a normal user
would be able to brick that system then. I think we should forbid that.

I agree with the rest of your note that a simple

cat <fw_blob> > /sys/...

should be enough.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
