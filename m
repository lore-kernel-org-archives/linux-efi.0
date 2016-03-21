From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH][v5] ACPI / PM: Introduce efi poweroff for HW-full
 platforms without _S5
Date: Mon, 21 Mar 2016 14:05:12 +0000
Message-ID: <20160321140512.GA11676@codeblueprint.co.uk>
References: <1458484268-18311-1-git-send-email-yu.c.chen@intel.com>
 <CAJZ5v0j1TpjQ8nD3gr7NYA_dpcghDidsvSoAOuobLMw6-3waCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJZ5v0j1TpjQ8nD3gr7NYA_dpcghDidsvSoAOuobLMw6-3waCg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Chen Yu <yu.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, ACPI Devel Maling List <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 21 Mar, at 01:43:18PM, Rafael J. Wysocki wrote:
> 
> OK, this is fine by me.
> 
> Matt, what do you think?

If possible I'd like to see some mention in the commit message of
future Intel Base-IA platforms requiring this support, so when someone
asks me in the future (and I've forgotten the answer) "Why was this
patch get merged?" I can point to the commit log.

But other than that, yeah, this looks good to me. Thanks!

Reviewed-by: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
