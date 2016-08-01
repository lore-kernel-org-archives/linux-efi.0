From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH] x86/efi: initialize status to ensure garbage is not
 returned on small size
Date: Mon, 1 Aug 2016 12:50:41 +0100
Message-ID: <20160801115041.GD3636@codeblueprint.co.uk>
References: <1469009466-19980-1-git-send-email-colin.king@canonical.com>
 <20160727143813.GG31759@codeblueprint.co.uk>
 <ada10a97-f3d3-91af-51b8-6d2f973c95a1@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ada10a97-f3d3-91af-51b8-6d2f973c95a1-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Colin Ian King <colin.king-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, 27 Jul, at 03:50:16PM, Colin Ian King wrote:
> 
> I'd rather put extra guarding in rather than getting some potential
> garbage return from the stack, but I am playing it rather conservatively
> here.

I think that's sensible, I just wanted to confirm your rationale.

Thanks, applied.
