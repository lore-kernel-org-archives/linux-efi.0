From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH v9 1/1] efi: a misc char interface for user to update efi
 firmware
Date: Sun, 1 Nov 2015 13:58:35 +0100
Message-ID: <20151101125835.GC12711@pd.tnic>
References: <1446055138-26047-1-git-send-email-hock.leong.kweh@intel.com>
 <1446055138-26047-2-git-send-email-hock.leong.kweh@intel.com>
 <20151101102944.GA12711@pd.tnic>
 <F54AEECA5E2B9541821D670476DAE19C4A8799FB@PGSMSX102.gar.corp.intel.com>
 <20151101105801.GB12711@pd.tnic>
 <F54AEECA5E2B9541821D670476DAE19C4A879A18@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C4A879A18-j2khPEwRog0FyVwBAnZdSLfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleming, Matt" <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Anvin, H Peter" <h.peter.anvin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Sun, Nov 01, 2015 at 11:11:23AM +0000, Kweh, Hock Leong wrote:
> Hmm .... If I combine these 2 flags to become one as
> "NO_MORE_WRITE_ACTION" to better describing the situation, you Okay
> with it?

I don't understand, why combine?

Why not simply make UPLOAD_DONE a positive value:

#define UPLOAD_DONE	1
#define ERR_OCCURRED	-1

0 would obviously mean, no errors occurred whatsoever.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
